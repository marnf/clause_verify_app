import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ------------------------------------------------------------------
// AppForMatters ক্লাস
// ------------------------------------------------------------------
// এই ক্লাসটি অ্যাপ্লিকেশন জুড়ে তারিখ, সময়, মুদ্রা এবং ফোন নম্বর 
// ফরম্যাট করার জন্য বিভিন্ন ইউটিলিটি প্রদান করে।
// ------------------------------------------------------------------
class AppForMatters {
  // ------------------------------------------------------------------
  // formatDate মেথড - DateTime কে 'dd-MMM-yyyy' স্ট্রিংয়ে ফরম্যাট করে
  // ------------------------------------------------------------------
  // প্যারামিটার:
  // - date: ফরম্যাট করার DateTime অবজেক্ট (nullable)
  // রিটার্ন: ফরম্যাট করা তারিখ স্ট্রিং (যেমন: '28-Jun-2024')
  // ------------------------------------------------------------------
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy')
        .format(date); // তারিখের ফরম্যাট প্রয়োজন অনুযায়ী কাস্টমাইজ করুন
  }



  

  // ------------------------------------------------------------------
  // formatCurrency মেথড - পরিমাণকে US মুদ্রা ফরম্যাটে রূপান্তর করে
  // ------------------------------------------------------------------
  // প্যারামিটার:
  // - amount: মুদ্রা হিসেবে ফরম্যাট করার ডাবল মান
  // রিটার্ন: ফরম্যাট করা মুদ্রা স্ট্রিং (যেমন: '$1,234.56')
  // ------------------------------------------------------------------
  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$')
        .format(amount); // মুদ্রার লোকেল এবং সিম্বল প্রয়োজন অনুযায়ী কাস্টমাইজ করুন
  }

  // ------------------------------------------------------------------
  // formatDateTime মেথড - তারিখ এবং সময় স্ট্রিংকে পাঠযোগ্য ফরম্যাটে একত্রিত করে
  // ------------------------------------------------------------------
  // প্যারামিটার:
  // - date: 'yyyy-MM-dd' ফরম্যাটে তারিখ স্ট্রিং (nullable)
  // - time: 'HH:mm' ফরম্যাটে সময় স্ট্রিং (nullable)
  // রিটার্ন: ফরম্যাট করা তারিখ-সময় স্ট্রিং (যেমন: 'June 28, 2025  10:25 PM')
  // ------------------------------------------------------------------
  String formatDateTime(String? date, String? time) {
    if (date == null || time == null) return '';

    try {
      final combined = DateFormat("yyyy-MM-dd HH:mm").parse("$date $time");
      return DateFormat(
        "MMMM d, y  h:mm a",
      ).format(combined); // উদাহরণ: June 28, 2025  10:25 PM
    } catch (e) {
      return "$date $time"; // ফলব্যাক
    }
  }

  // ------------------------------------------------------------------
  // তারিখ পিকার সেকশন
  // ------------------------------------------------------------------
  // তারিখ ইনপুট ফিল্ডের জন্য কন্ট্রোলার
  final dateController = TextEditingController();

  // ------------------------------------------------------------------
  // pickDate মেথড - তারিখ পিকার ডায়ালগ দেখায় এবং কন্ট্রোলার টেক্সট সেট করে
  // ------------------------------------------------------------------
  // প্যারামিটার:
  // - context: ডায়ালগ দেখানোর জন্য BuildContext
  // রিটার্ন: Future<void>
  // ------------------------------------------------------------------
  Future<void> pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  // ------------------------------------------------------------------
  // সময় পিকার সেকশন
  // ------------------------------------------------------------------
  // সময় ইনপুট ফিল্ডের জন্য কন্ট্রোলার
  final timeController = TextEditingController();

  // ------------------------------------------------------------------
  // pickTime মেথড - সময় পিকার ডায়ালগ দেখায় এবং কন্ট্রোলার টেক্সট সেট করে
  // ------------------------------------------------------------------
  // প্যারামিটার:
  // - context: ডায়ালগ দেখানোর জন্য BuildContext
  // রিটার্ন: Future<void>
  // ------------------------------------------------------------------
  Future<void> pickTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final dt = DateTime(
          now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      timeController.text = DateFormat('h:mm a').format(dt); // 5:45 PM ফরম্যাট
    }
  }

  // ------------------------------------------------------------------
  // formatPhoneNumber মেথড - ফোন নম্বরকে US স্ট্যান্ডার্ড ফরম্যাটে রূপান্তর করে
  // ------------------------------------------------------------------
  // প্যারামিটার:
  // - phoneNumber: কাঁচা ফোন নম্বর স্ট্রিং (10 বা 11 ডিজিটের প্রত্যাশিত)
  // রিটার্ন: ফরম্যাট করা ফোন নম্বর স্ট্রিং (যেমন: '(123) 456-7890')
  // ------------------------------------------------------------------
  static String formatPhoneNumber(String phoneNumber) {
    // 10-ডিজিটের US ফোন নম্বর ফরম্যাট ধরে নিচ্ছি: (123) 456-7890
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    } else if (phoneNumber.length == 11) {
      return '(${phoneNumber.substring(0, 4)}) ${phoneNumber.substring(4, 7)}-${phoneNumber.substring(7)}';
    }
    // বিভিন্ন ফরম্যাটের জন্য আরও কাস্টম ফোন নম্বর ফরম্যাটিং লজিক যোগ করুন যদি প্রয়োজন হয়।
    return phoneNumber;
  }
}
// ------------------------------------------------------------------
// AppForMatters ক্লাসের শেষ
// ------------------------------------------------------------------