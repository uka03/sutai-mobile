import 'package:flutter/material.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const String path = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GeneralColors.primaryBGColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [GeneralColors.primaryColor, Color(0xFFFFB29D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: GeneralColors.primaryColor.withAlpha(55),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                size: 48,
                color: Colors.white,
              ),
            ),
            VSpacer.lg(),
            Text(
              'Сутай зах',
              style: GeneralTextStyle.titleText(
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            VSpacer.sm(),
            Text(
              'Таны өдөр тутмын сонголт',
              style: GeneralTextStyle.bodyText(
                fontSize: 14,
                textColor: GeneralColors.textGrayColor,
              ),
            ),
            VSpacer.xl(),
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: GeneralColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
