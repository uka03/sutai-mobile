import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.child,
    required this.onTap,
    this.splashColor,
    this.highlightColor,
    this.borderRadius,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback onTap;
  final Color? splashColor, highlightColor;
  final BorderRadius? borderRadius;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius,
      splashColor: splashColor ?? Colors.transparent,
      highlightColor: highlightColor ?? Colors.transparent,
      onTap: enabled ? onTap : null,
      child: child,
    );
  }
}
