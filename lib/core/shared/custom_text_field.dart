import 'package:flutter/material.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/text_styles.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.controller,
    this.validator,
    this.hintText,
    this.keyboardType,
    this.readonly = false,
    this.withIcon = true,
    this.maxLines = 1,
    this.onTap,
    this.onChange,
  });

  final TextEditingController controller;
  final String? Function(String? value)? validator, onChange;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool readonly;
  final bool withIcon;
  final int? maxLines;
  final VoidCallback? onTap;

  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: GeneralColors.borderColor),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readonly,
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType ?? TextInputType.emailAddress,
      validator: (value) {
        if (validator != null) {
          return validator!(value);
        }
        return null;
      },
      onChanged: (value) {
        if (onChange != null) {
          onChange!(value);
        }
      },

      style: GeneralTextStyle.bodyText(
        fontSize: 16,
        textColor: GeneralColors.primaryColor,
      ),
      decoration: InputDecoration(
        hintText: hintText ?? "Хайх",
        hintStyle: GeneralTextStyle.bodyText(
          fontSize: 14,
          textColor: GeneralColors.grayColor,
        ),

        prefixIcon: withIcon
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Image.asset(
                  "assets/icons/ic_search.png",
                  height: 30,
                  color: GeneralColors.grayColor,
                ),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 10,
          minHeight: 10,
        ),

        filled: true,
        fillColor: GeneralColors.inputColor,
        border: border,
        errorBorder: border,
        enabledBorder: border,
        focusedBorder: border,
        focusedErrorBorder: border,
        disabledBorder: border,
      ),
    );
  }
}

class AuthTextField extends StatefulWidget {
  AuthTextField({
    super.key,
    required this.controller,
    this.validator,
    this.hintText,
    this.keyboardType,
    this.maxLength,
    this.extend = false,
    this.textInputAction,
    this.onChanged,
    this.onClear,
    this.focusText,
    this.obscureText = false,
  });
  final TextEditingController controller;
  final String? Function(String? value)? validator;
  final Function(String? value)? onChanged;
  final Function()? onClear;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool extend;
  final TextInputAction? textInputAction;
  final Color? focusText;
  final bool obscureText;

  final ValueNotifier<bool> isTyping = ValueNotifier(false);
  final border = UnderlineInputBorder(
    borderSide: BorderSide(color: GeneralColors.borderColor),
  );
  final focusedBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: GeneralColors.primaryColor),
  );

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        widget.isTyping.value = value;
      },
      child: ValueListenableBuilder(
        valueListenable: widget.isTyping,
        builder: (context, value, _) {
          return TextFormField(
            controller: widget.controller,
            maxLength: widget.maxLength,
            maxLines: widget.extend ? null : 1,
            textInputAction: widget.textInputAction,
            keyboardType: widget.keyboardType ?? TextInputType.emailAddress,
            obscureText: widget.obscureText && _obscureText,
            validator: (input) {
              if (widget.validator != null) {
                return widget.validator!(input);
              }
              return null;
            },
            onChanged: (input) {
              if (widget.onChanged != null) {
                widget.onChanged!(input);
              }
              if (input.isNotEmpty) {
                if (!widget.isTyping.value) {
                  widget.isTyping.value = true;
                }
              } else {
                if (widget.isTyping.value) {
                  widget.isTyping.value = false;
                }
              }
            },
            style: GeneralTextStyle.bodyText(
              fontSize: 16,
              textColor: value
                  ? widget.focusText ?? GeneralColors.primaryColor
                  : null,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText ?? "И-мэйл хаяг",
              suffixIcon: _buildSuffixIcon(value),
              border: widget.border,
              errorBorder: widget.border,
              enabledBorder: widget.border,
              focusedBorder: widget.focusedBorder,
              focusedErrorBorder: widget.focusedBorder,
              disabledBorder: widget.border,
            ),
          );
        },
      ),
    );
  }

  Widget? _buildSuffixIcon(bool hasText) {
    if (widget.obscureText) {
      return IconButton(
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        splashRadius: 18,
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: GeneralColors.grayColor,
        ),
      );
    }

    if (hasText) {
      return CustomButton(
        onTap: () {
          if (widget.onClear != null) {
            widget.onClear!();
          }
          widget.controller.clear();
        },
        child: const Icon(Icons.close),
      );
    }

    return null;
  }
}
