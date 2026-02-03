import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:ptg/core/utils/routes/routes.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 1));
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      if (mounted) context.go(AppRoutes.tours);
    } else {
      if (mounted) context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
