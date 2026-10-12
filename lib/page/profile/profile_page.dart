import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:sutai/core/model/api_error_message.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/custom_text_field.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/core/shared/toasts.dart';
import 'package:sutai/page/auth/provider/auth_provider.dart';
import 'package:sutai/page/profile/change_password_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late String _savedName;
  late String _savedEmail;
  bool _isSaving = false;

  bool get _hasChanges =>
      _nameController.text.trim() != _savedName ||
      _emailController.text.trim() != _savedEmail;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authProvider);
    final user = authState is AuthStateAuthenticated ? authState.user : null;
    _savedName = user?.name?.trim() ?? '';
    _savedEmail = user?.email?.trim() ?? '';
    _nameController = TextEditingController(text: _savedName);
    _emailController = TextEditingController(text: _savedEmail);
    _nameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() => setState(() {});

  @override
  void dispose() {
    _nameController.removeListener(_onFieldChanged);
    _emailController.removeListener(_onFieldChanged);
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_isSaving || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    try {
      await ref
          .read(authProvider.notifier)
          .updateProfile(
            name: _nameController.text,
            email: _emailController.text,
          );
      if (!mounted) return;
      _savedName = _nameController.text.trim();
      _savedEmail = _emailController.text.trim();
      Toast.success(context, description: 'Профайлын мэдээлэл шинэчлэгдлээ.');
    } on DioException catch (error) {
      if (!mounted) return;
      Toast.error(
        context,
        description: apiErrorMessage(
          error,
          'Мэдээлэл хадгалахад алдаа гарлаа.',
        ),
      );
    } catch (_) {
      if (!mounted) return;
      Toast.error(context, description: 'Мэдээлэл хадгалахад алдаа гарлаа.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState is AuthStateAuthenticated ? authState.user : null;
    final name = user?.name?.trim().isNotEmpty == true
        ? user!.name!.trim()
        : 'Хэрэглэгч';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Миний профайл',
              style: GeneralTextStyle.titleText(
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            VSpacer.lg(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: GeneralColors.primaryBGColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: GeneralColors.secondaryBGColor,
                    child: Text(
                      name.substring(0, 1).toUpperCase(),
                      style: GeneralTextStyle.titleText(
                        fontSize: 30,
                        textColor: GeneralColors.primaryColor,
                      ),
                    ),
                  ),
                  VSpacer(),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: GeneralTextStyle.titleText(fontSize: 20),
                  ),
                  if (user?.email != null) ...[
                    VSpacer.xs(),
                    Text(
                      user!.email!,
                      textAlign: TextAlign.center,
                      style: GeneralTextStyle.bodyText(
                        fontSize: 14,
                        textColor: GeneralColors.textGrayColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            VSpacer.lg(),
            Text(
              'Бүртгэлийн мэдээлэл',
              style: GeneralTextStyle.titleText(fontSize: 17),
            ),
            VSpacer.sm(),
            CustomTextField(
              controller: _nameController,
              hintText: 'Нэр',
              withIcon: false,
              keyboardType: TextInputType.name,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Нэрээ оруулна уу.'
                  : null,
            ),
            VSpacer.sm(),
            CustomTextField(
              controller: _emailController,
              hintText: 'И-мэйл хаяг',
              withIcon: false,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) return 'И-мэйл хаягаа оруулна уу.';
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                  return 'И-мэйл хаягаа зөв оруулна уу.';
                }
                return null;
              },
            ),
            VSpacer(),
            CustomButton(
              onTap: _saveProfile,
              enabled: _hasChanges && !_isSaving,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: _hasChanges && !_isSaving
                      ? GeneralColors.primaryColor
                      : GeneralColors.grayColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Өөрчлөлт хадгалах',
                          style: GeneralTextStyle.titleText(
                            fontSize: 15,
                            textColor: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            VSpacer.lg(),
            CustomButton(
              onTap: () => context.push(ChangePasswordPage.path),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: GeneralColors.primaryBGColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: GeneralColors.borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: GeneralColors.secondaryBGColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        color: GeneralColors.primaryColor,
                      ),
                    ),
                    HSpacer(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Нууц үг солих',
                            style: GeneralTextStyle.titleText(fontSize: 15),
                          ),
                          VSpacer.xs(),
                          Text(
                            'Нууц үгээ шинэчлэх',
                            style: GeneralTextStyle.bodyText(
                              fontSize: 12,
                              textColor: GeneralColors.textGrayColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: GeneralColors.textGrayColor,
                    ),
                  ],
                ),
              ),
            ),
            VSpacer.lg(),
            CustomButton(
              onTap: () => ref.read(authProvider.notifier).logout(),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: GeneralColors.borderColor),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.logout_rounded,
                      color: GeneralColors.errorColor,
                    ),
                    HSpacer.sm(),
                    Text(
                      'Системээс гарах',
                      style: GeneralTextStyle.titleText(
                        fontSize: 15,
                        textColor: GeneralColors.errorColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
