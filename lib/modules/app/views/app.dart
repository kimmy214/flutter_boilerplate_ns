import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/common/dio/widget/http_error_boundary.dart';
import 'package:flutter_boilerplate/l10n/l10n.dart';
import 'package:flutter_boilerplate/modules/app/cubit/app_cubit.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';
import 'package:flutter_boilerplate/theme/theme.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:trending_repository/trending_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.trendingRepository,
  });

  final TrendingRepository trendingRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: trendingRepository,
      child: BlocProvider(
        create: (_) => AppCubit(),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return MaterialAppView();
    if (Platform.isMacOS) return MacosAppView();
    if (Platform.isWindows) return WindowsAppView();
    return MaterialAppView();
  }
}

class MaterialAppView extends StatelessWidget {
  MaterialAppView({super.key});

  final httpErrorBoundary = HttpErrorBoundary.init();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (BuildContext context, AppState state) => MaterialApp(
        theme: FlutterBoilerplateTheme.light,
        darkTheme: FlutterBoilerplateTheme.dark,
        themeMode: state.themeMode,
        locale: state.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
        builder: (BuildContext context, Widget? child) {
          final newChild = httpErrorBoundary(context, child);
          return newChild;
        },
      ),
    );
  }
}

class MacosAppView extends StatelessWidget {
  MacosAppView({super.key});

  final httpErrorBoundary = HttpErrorBoundary.init();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (BuildContext context, AppState state) => MacosApp(
        theme: MacosThemeData.light(),
        darkTheme: MacosThemeData.dark(),
        themeMode: state.themeMode,
        locale: state.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
        builder: (BuildContext context, Widget? child) {
          final newChild = httpErrorBoundary(context, child);
          return newChild;
        },
      ),
    );
  }
}

class WindowsAppView extends StatelessWidget {
  WindowsAppView({super.key});

  final httpErrorBoundary = HttpErrorBoundary.init();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (BuildContext context, AppState state) => FluentApp(
        themeMode: state.themeMode,
        locale: state.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
        builder: (BuildContext context, Widget? child) {
          final newChild = httpErrorBoundary(context, child);
          return newChild;
        },
      ),
    );
  }
}
