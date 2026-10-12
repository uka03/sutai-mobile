import 'package:flutter/material.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';

class OrderCancelDialog extends StatelessWidget {
  const OrderCancelDialog({super.key});

  static Future<bool?> show(BuildContext context) => showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => const OrderCancelDialog(),
  );

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    insetPadding: const EdgeInsets.symmetric(horizontal: 24),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      decoration: BoxDecoration(
        color: GeneralColors.primaryBGColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: GeneralColors.errorColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.remove_shopping_cart_outlined,
              color: GeneralColors.errorColor,
              size: 29,
            ),
          ),
          VSpacer(),
          Text(
            'Захиалга цуцлах уу?',
            textAlign: TextAlign.center,
            style: GeneralTextStyle.titleText(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          VSpacer.xs(),
          Text(
            'Захиалгыг цуцалбал буцаах боломжгүй.',
            textAlign: TextAlign.center,
            style: GeneralTextStyle.bodyText(
              fontSize: 14,
              textColor: GeneralColors.textGrayColor,
            ),
          ),
          VSpacer.lg(),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onTap: () => Navigator.of(context).pop(false),
                  borderRadius: BorderRadius.circular(13),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: GeneralColors.secondaryBGColor,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text(
                      'Буцах',
                      style: GeneralTextStyle.titleText(fontSize: 14),
                    ),
                  ),
                ),
              ),
              HSpacer.sm(),
              Expanded(
                child: CustomButton(
                  onTap: () => Navigator.of(context).pop(true),
                  borderRadius: BorderRadius.circular(13),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: GeneralColors.errorColor,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text(
                      'Цуцлах',
                      style: GeneralTextStyle.titleText(
                        fontSize: 14,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
