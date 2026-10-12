import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sutai/core/components/general_scaffold.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_text_field.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/page/auth/provider/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  static const String path = '/register';

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Энэ талбарыг бөглөнө үү.' : null;

  String? _validateEmail(String? value) {
    final requiredError = _required(value);
    if (requiredError != null) return requiredError;
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value!.trim())) {
      return 'И-мэйл хаягаа зөв оруулна уу.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final requiredError = _required(value);
    if (requiredError != null) return requiredError;
    if (value!.length < 8) return 'Нууц үг дор хаяж 8 тэмдэгттэй байна.';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final requiredError = _required(value);
    if (requiredError != null) return requiredError;
    if (value != _passwordController.text) return 'Нууц үг таарахгүй байна.';
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authProvider.notifier)
          .register(
            email: _emailController.text.trim(),
            name: _nameController.text.trim(),
            password: _passwordController.text.trim(),
            passwordConfirm: _confirmPasswordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return GeneralScaffold(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(24),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
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
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            GeneralColors.primaryColor,
                            Color(0xFFFFB29D),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  VSpacer(),
                  Center(
                    child: Text(
                      'Шинэ бүртгэл',
                      style: GeneralTextStyle.titleText(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  VSpacer(size: 8),
                  Center(
                    child: Text(
                      'Сутай захад тавтай морил!',
                      style: GeneralTextStyle.bodyText(
                        textColor: GeneralColors.textGrayColor,
                      ),
                    ),
                  ),
                  VSpacer(),
                  AuthTextField(
                    controller: _nameController,
                    hintText: 'Таны нэр',
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: _required,
                  ),
                  VSpacer(),
                  AuthTextField(
                    controller: _emailController,
                    hintText: 'И-мэйл хаяг',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _validateEmail,
                  ),
                  VSpacer(),
                  AuthTextField(
                    controller: _passwordController,
                    hintText: 'Нууц үг',
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    validator: _validatePassword,
                  ),
                  VSpacer(),
                  AuthTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Нууц үг давтах',
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    validator: _validateConfirmPassword,
                  ),
                  VSpacer.lg(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: GeneralColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: authState is! AuthStateLoading
                          ? Text(
                              'Бүртгүүлэх',
                              style: GeneralTextStyle.titleText(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                textColor: Colors.white,
                              ),
                            )
                          : CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                    ),
                  ),
                  VSpacer.lg(),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Бүртгэлтэй юу?',
                          style: GeneralTextStyle.bodyText(
                            textColor: GeneralColors.textGrayColor,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.pop(),
                          style: TextButton.styleFrom(
                            foregroundColor: GeneralColors.primaryColor,
                          ),
                          child: const Text('Нэвтрэх'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
