
// lib/core/services/scan_job_poller.dart  (MODIFIED)

import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../utils/backend_message_translator.dart';
import 'endpoints.dart';
import 'network_caller.dart';

/// প্রতিটা upload-এর জন্য UUID generate করার helper
class ScanJobHelper {
  static const Uuid _uuid = Uuid();

  /// X-Scan-Job-ID header + polling URL, দুই জায়গাতেই এটা যাবে
  static String newJobId() => _uuid.v4();
}

/// Backend-এর scan-jobs endpoint বারবার poll করে প্রতিটা event-এর message
/// একটা একটা করে callback-এ দেয়।
///
/// Flow:
///   GET /api/files/scan-jobs/{uuid}/?after_event_id=0
///   → response-এর সব events queue-তে → last_event_id সংরক্ষণ
///   → পরের request: ?after_event_id={last_event_id}
///   → status COMPLETED / FAILED / REJECTED হলে polling বন্ধ
///
/// Backend response: { "success": true, "data": { status, events, last_event_id, ... } }
/// তাই আগে "data" unwrap করা হয় (না থাকলে top-level-ই ধরা হয়)।
///
/// Message গুলো user-এর selected language-এ translate হয়ে queue-তে যায়
/// (BackendMessageTranslator দেখুন)।
class ScanJobPoller {
  ScanJobPoller({
    required this.onMessage,
    this.interval = const Duration(seconds: 2),
    this.minMessageDuration = const Duration(milliseconds: 1500),
  });

  /// প্রতিটা নতুন message-এর জন্য call হবে (একটা একটা করে)
  /// এটাতে already translated message আসবে।
  final void Function(String message) onMessage;

  /// দুই poll-এর মাঝের বিরতি
  final Duration interval;

  /// একটা message অন্তত এতক্ষণ screen-এ থাকবে
  final Duration minMessageDuration;

  static const Set<String> _terminalStatuses = {
    'COMPLETED',
    'FAILED',
    'REJECTED',
  };

  final NetworkCaller _networkCaller = NetworkCaller();

  int _lastEventId = 0;

  /// প্রতিটা start/stop-এ বাড়ে; পুরোনো loop নিজে থেকেই বন্ধ হয়ে যায়
  int _session = 0;

  // দেখানোর অপেক্ষায় থাকা message-এর queue
  final Queue<String> _queue = Queue<String>();
  bool _isDraining = false;

  /// Polling শুরু করো (await করার দরকার নেই)
  Future<void> start(String jobId) async {
    stop();
    final int mySession = ++_session;
    _lastEventId = 0;
    _queue.clear();

    while (mySession == _session) {
      final bool finished = await _pollOnce(jobId, mySession);
      if (finished || mySession != _session) break;
      await Future.delayed(interval);
    }
  }

  /// Polling বন্ধ করো, queue খালি করো
  void stop() {
    _session++;
    _queue.clear();
  }

  /// true return করলে polling থামবে
  Future<bool> _pollOnce(String jobId, int mySession) async {
    try {
      final url = '${Endpoints.scanJobs}$jobId/?after_event_id=$_lastEventId';
      debugPrint('📡 SCAN POLL → after_event_id=$_lastEventId');

      final response = await _networkCaller.getRequest(url);

      // Polling চলাকালীন stop() হয়ে গেলে পুরোনো message আর দেখাবো না
      if (mySession != _session) return true;

      debugPrint(
          '📡 SCAN POLL ← http: ${response.statusCode}, ok: ${response.isSuccess}');

      // Job হয়তো এখনো তৈরি হয়নি (404) বা network সমস্যা → পরের বার আবার চেষ্টা
      if (!response.isSuccess || response.responseData is! Map) {
        return false;
      }

      final root = response.responseData as Map;

      // 🆕 আসল data "data"-এর ভেতরে থাকে; না থাকলে top-level ধরো
      final Map data = root['data'] is Map ? root['data'] as Map : root;

      // ── সব নতুন event-এর message queue-তে (translated) ──
      final events = data['events'];
      if (events is List) {
        for (final e in events) {
          if (e is Map) {
            final msg = (e['message'] ?? '').toString().trim();
            if (msg.isNotEmpty) {
              final stage = (e['stage'] ?? '').toString().trim().toUpperCase();
              debugPrint('📡 SCAN EVENT #${e['id']}: $msg');

              // ✅ Backend message কে user-এর selected language-এ translate করো
              // stage দিয়ে আগে lookup হবে (reliable), না থাকলে message দিয়ে।
              final translated =
                  BackendMessageTranslator.translate(msg, stage: stage);
              _queue.add(translated);
            }
          }
        }
        _drainQueue(mySession);
      }

      // ── পরের request-এর জন্য last_event_id update ──
      final lastId = data['last_event_id'];
      if (lastId is num) _lastEventId = lastId.toInt();

      final status = (data['status'] ?? '').toString().toUpperCase();
      debugPrint('📡 SCAN STATUS: $status, last_event_id: $_lastEventId');

      return _terminalStatuses.contains(status);
    } catch (e) {
      debugPrint('❌ Scan job poll error: $e');
      return false;
    }
  }

  /// Queue-র message গুলো একটা একটা করে দেখাও (প্রতিটা কমপক্ষে minMessageDuration)
  Future<void> _drainQueue(int mySession) async {
    if (_isDraining) return;
    _isDraining = true;

    try {
      while (_queue.isNotEmpty && mySession == _session) {
        final msg = _queue.removeFirst();
        onMessage(msg);
        await Future.delayed(minMessageDuration);
      }
    } finally {
      _isDraining = false;
    }
  }
}
