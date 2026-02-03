import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ptg/core/utils/routes/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ToursScreen extends StatefulWidget {
  const ToursScreen({super.key});

  @override
  State<ToursScreen> createState() => _ToursScreenState();
}

class _ToursScreenState extends State<ToursScreen> {
  @override
  void initState() {
    super.initState();
    _setListenerForAuthChanges();
  }

  void _setListenerForAuthChanges() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session == null) {
        if (mounted) context.go(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Tours Screen'),
          ElevatedButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
