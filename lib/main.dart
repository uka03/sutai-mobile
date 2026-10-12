import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutai/core/provider/theme_provider.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/route/route.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routeProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Сутай зах',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: GeneralColors.primaryBGColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: GeneralColors.primaryColor,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: GeneralColors.textColor,
          backgroundColor: GeneralColors.primaryBGColor,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: GeneralColors.darkPrimaryBGColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: GeneralColors.primaryColor,
          brightness: Brightness.dark,
          surface: GeneralColors.darkPrimaryBGColor,
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: GeneralColors.darkTextColor,
          backgroundColor: GeneralColors.darkPrimaryBGColor,
        ),
      ),
      routerConfig: router,
    );
  }
}
