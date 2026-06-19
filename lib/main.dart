import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/constants/app_strings.dart';
import 'app/theme/app_theme.dart';
import 'app/router/app_router.dart';
import 'package:go_router/go_router.dart';

import 'core/app_config.dart';
import 'core/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  await AppConfig.loadDotEnvForDebug();

  if (!AppConfig.hasSupabaseConfig) {
    runApp(const ConfigErrorApp());
    return;
  }

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    publishableKey: AppConfig.supabaseAnonKey,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: CoffeeBudgetApp()));
}

class ConfigErrorApp extends StatelessWidget {
  const ConfigErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Konfigurasi Supabase belum tersedia. Jalankan aplikasi dengan --dart-define SUPABASE_URL dan SUPABASE_ANON_KEY, atau sediakan .env saat debug.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class CoffeeBudgetApp extends ConsumerStatefulWidget {
  const CoffeeBudgetApp({super.key});

  @override
  ConsumerState<CoffeeBudgetApp> createState() => _CoffeeBudgetAppState();
}

class _CoffeeBudgetAppState extends ConsumerState<CoffeeBudgetApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter();
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _router,
    );
  }
}
