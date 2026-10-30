// lib/core/utils/backend_message_translator.dart

import 'package:get/get.dart';

/// Backend থেকে আসা live-status message কে user-এর selected language-এ
/// translate করে।
///
/// কাজের পদ্ধতি (priority অনুযায়ী):
///   1. stage (QUEUED, STARTED, ইত্যাদি) দিয়ে lookup — stage বেশি stable,
///      backend message wording বদলালেও stage থাকে।
///   2. stage না থাকলে বা match না হলে, message দিয়ে lookup।
///   3. দুটোই fail করলে original backend message ফেরত দেয় (fallback)।
///
/// ব্যবহার:
///   final text = BackendMessageTranslator.translate(msg, stage: stage);
class BackendMessageTranslator {
  BackendMessageTranslator._();

  /// Backend stage → translation key
  /// (এই stage গুলো backend response-এর events এর "stage" field থেকে আসে)
  static const Map<String, String> _stageToKey = {
    'QUEUED': 'scanStatusQueued',
    'STARTED': 'scanStatusStarted',
    'EXTRACTING': 'scanStatusExtracting',
    'TEXT_EXTRACTED': 'scanStatusTextExtracted',
    'ANALYZING': 'scanStatusAnalyzing',
    'CONTRACT_CHECK': 'scanStatusContractCheck',
    'FINALIZING_AI': 'scanStatusFinalizingAi',
    'SAVING': 'scanStatusSaving',
    'COMPLETED': 'scanStatusCompleted',
  };

  /// Backend English message → translation key (fallback)
  /// (backend message বদলালেও stage দিয়ে কাজ চলবে, এটা শুধু safety net)
  static const Map<String, String> _messageToKey = {
    'Document uploaded. Waiting for processing.': 'scanStatusQueued',
    'Document processing has started.': 'scanStatusStarted',
    'Reading the uploaded PDF or images.': 'scanStatusExtracting',
    'Document text extracted. Preparing contract analysis.':
        'scanStatusTextExtracted',
    'AI is reviewing the document.': 'scanStatusAnalyzing',
    'AI returned a contract classification. Verifying result.':
        'scanStatusContractCheck',
    'Contract confirmed. Finalizing legal analysis.':
        'scanStatusFinalizingAi',
    'Analysis completed. Securely saving your result.': 'scanStatusSaving',
    'Your contract analysis is ready.': 'scanStatusCompleted',
  };

  /// Backend message কে user-এর selected language-এ translate করে।
  ///
  /// [stage] থাকলে সেটা দিয়ে আগে lookup হবে (বেশি reliable)।
  /// কোনো match না পেলে original [message] ফেরত দেয়।
  static String translate(String message, {String? stage}) {
    final trimmed = message.trim();
    String? key;

    // 1. Stage-based lookup (primary — backend stage stable identifier)
    if (stage != null && stage.isNotEmpty) {
      key = _stageToKey[stage.toUpperCase()];
    }

    // 2. Message-based lookup (fallback)
    if (key == null) {
      key = _messageToKey[trimmed];
    }

    // 3. No match → return original backend message (fallback)
    if (key == null) return trimmed;

    // GetX এর .tr: key JSON-ে না থাকলে key স্ট্রিংটাই ফেরত দেয়।
    // সেক্ষেত্রে original backend message দেখানো ভালো (key না দেখিয়ে)।
    final translated = key.tr;
    return translated == key ? trimmed : translated;
  }

  // ════════════════════════════════════════════════════════════════
  //  not_a_contract message translate
  // ════════════════════════════════════════════════════════════════

  /// `code == 'not_a_contract'` response-এর message কে translate করে।
  ///
  /// Backend ২ ধরনের message পাঠায়:
  ///   1. `scan_deducted: false` → "This document does not look like a
  ///      contract. No scan was used."
  ///   2. `scan_deducted: true` → "This document does not look like a
  ///      contract. Daily free rejection limit reached; one scan was used."
  ///
  /// তাই আমরা `scan_deducted` field দিয়ে সঠিক translation key বের করি।
  /// কোনো কারণে `scan_deducted` না থাকলে, message text দিয়ে fallback match
  /// করা হয়। শেষ পর্যন্ত match না পেলে original message ফেরত দেয়।
  static String translateNotAContract(Map<String, dynamic> data) {
    final scanDeducted = data['scan_deducted'] == true;
    final message = (data['message'] ?? '').toString().trim();

    String key;

    if (scanDeducted) {
      // Daily free rejection limit reached + scan কাটা হয়েছে
      key = 'notAContractScanUsed';
    } else {
      // No scan was used
      key = 'notAContractNoScan';
    }

    // GetX এর .tr: key JSON-ে না থাকলে key স্ট্রিংটাই ফেরত দেয়।
    // সেক্ষেত্রে original backend message দেখানো ভালো (key না দেখিয়ে)।
    final translated = key.tr;
    return translated == key ? message : translated;
  }
}
