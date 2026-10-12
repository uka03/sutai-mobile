import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:sutai/core/components/general_scaffold.dart';
import 'package:sutai/core/model/api_error_message.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_app_bar.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/custom_text_field.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/core/shared/toasts.dart';
import 'package:sutai/page/auth/provider/auth_provider.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  static const path = '/profile/change-password';

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmationController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting || !(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);
    try {
      await ref
          .read(authProvider.notifier)
          .updatePassword(
            currentPassword: _currentPasswordController.text,
            password: _newPasswordController.text,
            passwordConfirmation: _confirmationController.text,
          );
      if (!mounted) return;
      Toast.success(context, description: 'Нууц үг амжилттай солигдлоо.');
      context.pop();
    } on DioException catch (error) {
      if (!mounted) return;
      Toast.error(
        context,
        description: apiErrorMessage(error, 'Нууц үг солиход алдаа гарлаа.'),
      );
    } catch (_) {
      if (!mounted) return;
      Toast.error(context, description: 'Нууц үг солиход алдаа гарлаа.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: CustomAppBar(
        title: Text(
          'Нууц үг солих',
          style: GeneralTextStyle.titleText(fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: GeneralColors.secondaryBGColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: GeneralColors.primaryBGColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        size: 30,
                        color: GeneralColors.primaryColor,
                      ),
                    ),
                    VSpacer(),
                    Text(
                      'Нууц үгээ шинэчлэх',
                      style: GeneralTextStyle.titleText(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    VSpacer.xs(),
                    Text(
                      'Одоогийн нууц үгээ баталгаажуулаад шинэ нууц үгээ тохируулна уу.',
                      textAlign: TextAlign.center,
                      style: GeneralTextStyle.bodyText(
                        fontSize: 13,
                        textColor: GeneralColors.textGrayColor,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              VSpacer.lg(),
              _FieldLabel(label: 'Одоогийн нууц үг'),
              VSpacer.xs(),
              AuthTextField(
                controller: _currentPasswordController,
                hintText: 'Одоогийн нууц үгээ оруулна уу',
                obscureText: true,
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.isEmpty
                    ? 'Одоогийн нууц үгээ оруулна уу.'
                    : null,
              ),
              VSpacer(),
              _FieldLabel(label: 'Шинэ нууц үг'),
              VSpacer.xs(),
              AuthTextField(
                controller: _newPasswordController,
                hintText: 'Дор хаяж 8 тэмдэгт',
                obscureText: true,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Шинэ нууц үгээ оруулна уу.';
                  }
                  if (value.length < 8) {
                    return 'Нууц үг дор хаяж 8 тэмдэгт байна.';
                  }
                  return null;
                },
              ),
              VSpacer(),
              _FieldLabel(label: 'Шинэ нууц үг давтах'),
              VSpacer.xs(),
              AuthTextField(
                controller: _confirmationController,
                hintText: 'Шинэ нууц үгээ дахин оруулна уу',
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Шинэ нууц үгээ давтан оруулна уу.';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Нууц үг таарахгүй байна.';
                  }
                  return null;
                },
              ),
              VSpacer.lg(),
              CustomButton(
                onTap: _submit,
                enabled: !_isSubmitting,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _isSubmitting
                        ? GeneralColors.grayColor
                        : GeneralColors.primaryColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 21,
                            height: 21,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Нууц үг шинэчлэх',
                            style: GeneralTextStyle.titleText(
                              fontSize: 15,
                              textColor: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GeneralTextStyle.bodyText(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        textColor: GeneralColors.textGrayColor,
      ),
    );
  }
}
