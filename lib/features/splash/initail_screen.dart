import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ptg/features/sign_in/bloc/login_bloc.dart';
import 'package:ptg/features/sign_in/bloc/login_state.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    // here I want to check if a user is logged in or not if not logged in than go to login screen else go to home screen
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {},
      child: Scaffold(
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
      ),
    );
  }
}
