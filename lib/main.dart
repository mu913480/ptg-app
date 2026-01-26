import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg/config/app_config.dart';
import 'package:ptg/config/theme.dart';
import 'package:ptg/features/sign_in/bloc/login_bloc.dart';
import 'package:ptg/network/auth_service.dart';
import 'package:ptg/utils/routes/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await AppConfig.load();

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => LoginBloc())],
      child: MaterialApp.router(
        routerConfig: AppRouter.getRouter(context),

        title: 'Pakistan Tourism Guide',
        theme: ThemeData(colorScheme: MaterialTheme.lightScheme()),
        // darkTheme: ThemeData(colorScheme: MaterialTheme.darkScheme()),
        themeMode: ThemeMode.system,
      ),
    );
  }
}
