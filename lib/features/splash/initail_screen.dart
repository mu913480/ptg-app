import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Initial Screen'),
            ElevatedButton(
              onPressed: () {
                context.go('/login');
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
