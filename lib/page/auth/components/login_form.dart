import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/custom_text_field.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    this.errorMessage,
  });

  final bool isLoading;
  final String? errorMessage;
  final void Function(String email, String password) onSubmit;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (widget.isLoading || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    widget.onSubmit(_emailController.text.trim(), _passwordController.text);
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'И-мэйл хаягаа оруулна уу.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'И-мэйл хаягаа зөв оруулна уу.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 24,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [GeneralColors.primaryColor, Color(0xFFFFB29D)],
                  ),
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ),
            VSpacer(),
            Center(
              child: Text(
                'Тавтай морил!',
                style: GeneralTextStyle.titleText(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            VSpacer(),
            AuthTextField(
              hintText: 'И-мэйл хаяг',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: _validateEmail,
            ),
            VSpacer(),
            AuthTextField(
              hintText: 'Нууц үг',
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              obscureText: true,
              validator: (value) => value == null || value.isEmpty
                  ? 'Нууц үгээ оруулна уу.'
                  : null,
            ),
            if (widget.errorMessage != null) ...[
              VSpacer.sm(),
              Text(
                widget.errorMessage!,
                style: GeneralTextStyle.bodyText(
                  textColor: GeneralColors.errorColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            VSpacer.lg(),
            CustomButton(
              onTap: _submit,
              enabled: !widget.isLoading,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: widget.isLoading
                      ? GeneralColors.grayColor
                      : GeneralColors.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 21,
                          height: 21,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Нэвтрэх',
                          style: GeneralTextStyle.titleText(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            textColor: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            VSpacer.lg(),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Бүртгэл байхгүй юу?',
                  style: GeneralTextStyle.bodyText(
                    textColor: GeneralColors.textGrayColor,
                  ),
                ),
                TextButton(
                  onPressed: widget.isLoading
                      ? null
                      : () => context.push('/register'),
                  style: TextButton.styleFrom(
                    foregroundColor: GeneralColors.primaryColor,
                  ),
                  child: const Text('Бүртгүүлэх'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
