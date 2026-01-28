import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg/core/config/app_config.dart';
import 'package:ptg/core/config/theme.dart';
import 'package:ptg/core/config/util.dart';
import 'package:ptg/features/sign_in/bloc/login_bloc.dart';

import 'package:ptg/core/utils/routes/routes.dart';
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
    TextTheme textTheme = createTextTheme(context, "Oswald", "Oswald");
    MaterialTheme materialTheme = MaterialTheme(textTheme);
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => LoginBloc())],
      child: MaterialApp.router(
        routerConfig: AppRouter.getRouter(context),

        title: 'Pakistan Tourism Guide',
        theme: materialTheme.light(),

        // darkTheme: materialTheme.dark(),
        themeMode: ThemeMode.system,
      ),
    );
  }
}
