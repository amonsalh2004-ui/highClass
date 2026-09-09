import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const HiClassApp());
}

class HiClassApp extends StatelessWidget {
  const HiClassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'هاي كلاس - إدارة المشاريع',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        // Force RTL layout app-wide since the whole UI is Arabic.
        return Directionality(
          textDirection: TextDirection.rtl,
          // The screens were designed for a phone-width layout. On a wide
          // browser window that would otherwise stretch every Row/Expanded
          // edge-to-edge and break the spacing. Cap the content at a
          // phone-like width and center it on larger (web/desktop) screens.
          child: Container(
            color: AppColors.maroonDark,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          ),
        );
      },
      home: const LoginScreen(),
    );
  }



}
