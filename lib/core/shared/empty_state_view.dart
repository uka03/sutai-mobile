import 'package:flutter/material.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconSize = compact ? 54.0 : 72.0;
    final padding = compact ? 18.0 : 26.0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: GeneralColors.secondaryBGColor,
                  borderRadius: BorderRadius.circular(compact ? 18 : 24),
                ),
                child: Icon(
                  icon,
                  size: compact ? 27 : 34,
                  color: GeneralColors.primaryColor,
                ),
              ),
              VSpacer(size: compact ? 14 : 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GeneralTextStyle.titleText(
                  fontSize: compact ? 16 : 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              VSpacer.xs(),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GeneralTextStyle.bodyText(
                  fontSize: compact ? 12 : 14,
                  textColor: GeneralColors.textGrayColor,
                  height: 1.45,
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                VSpacer.lg(),
                CustomButton(
                  onTap: onAction!,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: GeneralColors.primaryColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      actionLabel!,
                      style: GeneralTextStyle.titleText(
                        fontSize: 14,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
