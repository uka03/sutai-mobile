import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutai/core/components/general_scaffold.dart';
import 'package:sutai/page/auth/components/login_form.dart';
import 'package:sutai/page/auth/provider/auth_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  static const String path = '/login';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthStateLoading;
    final errorMessage = authState is AuthStateError
        ? authState.message
        : null;

    return GeneralScaffold(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: LoginForm(
            isLoading: isLoading,
            errorMessage: errorMessage,
            onSubmit: (email, password) => ref
                .read(authProvider.notifier)
                .login(email, password),
          ),
        ),
      ),
    );
  }
}
