import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Client palette (single source of truth) ──
  // --bg: #0A0A0A; --surface: #111111; --elevated: #1A1A1A;
  // --gold: #C9952A; --gold-lt: #F0D070; --gold-dk: #9A6A14;
  // --cream: #F5F0E8; --white: #FFFFFF;
  // --t2: #888888; --t3: #444444; --divider: #1C1C1C; border: #222222;
  // --red: #E05540; --orange: #D4883A; --green: #4CAF7D;

  static const Color greyColor = Color(0xFF888888);

  // Brand Colors
  static const Color primary = Color(0xFFC9952A);

  static const Color gold = Color(0xFFC9952A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF888888);
  static const Color textBold = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF888888);
  static const Color textBlack = Color(0xFF000000); // text on gold buttons
  static const Color textBlue = Color(0xFFC9952A);
  static const Color textGrayBlue = Color(0xFF888888);
  static const Color containerBorder = Color(0xFF222222);
  static const Color scaffoldColor = Color(0xFF0A0A0A);
  static const Color mapBorder = Color(0xFF222222);
  static const Color tealColor = Color(0xFFC9952A);
  // Background Colors
  static const Color backgroundLight = Color(0xFF0A0A0A);
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color primaryBackground = Color(0xFF0A0A0A);
  static const Color mainBackground = Color(0xFF0A0A0A);
  static const Color appBarBackground = Color(0xFF0A0A0A);
  // Surface Colors
  static const Color surfaceDark = Color(0xFF111111);
  // Container Colors
  static const Color containerBackground = Color(0xFF1A1A1A);
  static const Color containerBackground1 = Color(0xFF111111);
  static const Color navUnselectedColor = Color(0xFF444444);
  // Utility Colors
  static const Color info = Color(0xFFC9952A);
  static const Color CalenderBg = Color(0xFF1A1A1A);
  static const Color notificationBellBg = Color(0xFF1A1A1A);

  /// textformfield border color
  static const Color textFormFieldBorder = Color(0xFF222222);

  /// Buttons
  static const Color buttonSecondary = Color(0xFF1A1A1A);

  /// Appbar
  static const Color CustomAppBarBg = Color(0xFF0A0A0A);
  static const Color CustomAppBarIcon = Color(0xFF888888);
  static const Color JobListBg = Color(0xFF111111);

  static const Color timesheetHeader = Color(0xFF1A1A1A);
  static const Color HomeGridViewButtonBg = Color(0xFF111111);

  static const Color secondary = Color(0xFF0A0A0A);
  static const Color secondaryBorder = Color(0xFF222222);
  static const Color splashBorder = Color(0xFFC9952A);

  static const Color subscription_card_border = Color(0xFF222222);
  static const Color subscription_card = Color(0xFF111111);

// ------------------------------clause verify---------------------------------

  // ── Brand / Primary ──
  static const Color primaryColor  = Color(0xFFC9952A); // --gold
  static const Color goldLight     = Color(0xFFF0D070); // --gold-lt
  static const Color goldDark      = Color(0xFF9A6A14); // --gold-dk
  static const Color cream         = Color(0xFFF5F0E8); // Blanc crème

  // ── Backgrounds ──
  static const Color background    = Color(0xFF0A0A0A); // --bg
  static const Color surface       = Color(0xFF111111); // --surface
  static const Color surfaceLight  = Color(0xFF1A1A1A); // --elevated

  // ── Borders / Dividers ──
  static const Color cardBorder    = Color(0xFF222222);
  static const Color divider       = Color(0xFF1C1C1C); // --divider

  // ── Text ──
  static const Color textWhite     = Color(0xFFFFFFFF); // --white
  static const Color textMuted     = Color(0xFF888888); // --t2
  static const Color textSubtle    = Color(0xFF444444); // --t3

  // ── Utility / Risk Colors ──
  static const Color success       = Color(0xFF4CAF7D); // --green
  static const Color error         = Color(0xFFE05540); // --red
  static const Color warning       = Color(0xFFD4883A); // --orange
  static const Color white         = Color(0xFFFFFFFF);

  // ── Subscription cards ──
  static const Color currentPlanBg          = Color(0xFF1A1A1A);
  static const Color subscriptionCardBorder = Color(0xFF222222);
  static const Color subscriptionCard       = Color(0xFF111111);



    // ── New (added for page color cleanup) ──
  static const Color black = Color(0xFF000000);       // text/icon/spinner on gold button
  static const Color black38 = Color(0x61000000);     // disabled text on gold button
  static const Color black54 = Color(0x8A000000);     // semi-disabled text on gold button
  static const Color splashOverlay = Color(0x660A0A0A); // bg #0A0A0A @ 40% opacity
}