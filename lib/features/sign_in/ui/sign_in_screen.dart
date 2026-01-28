import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg/features/sign_in/bloc/login_bloc.dart';
import 'package:ptg/features/sign_in/bloc/login_event.dart';
import 'package:ptg/features/sign_in/bloc/login_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  void _onLoginPressed(BuildContext context) {
    if (formkey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      context.read<LoginBloc>().add(
        LoginEmailSubmitted(email: email, password: password),
      );
    }
  }

  void togglePasswordVisibility(BuildContext context) {
    context.read<LoginBloc>().add(LoginPasswordToggled());
  }

  void _onGooglePressed(BuildContext context) {
    context.read<LoginBloc>().add(const LoginGoogleSubmitted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildLoginForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Form(
            key: formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Login title
                Text(
                  'Login ',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),

                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: state.isPasswordHidden
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      onPressed: () {
                        togglePasswordVisibility(context);
                      },
                    ),
                  ),
                  obscureText: state.isPasswordHidden,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Login button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () => _onLoginPressed(context),
                    child: state.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            'Login',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Forgot password
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password
                    },
                    child: Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Divider with "Or continue with"
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or continue with',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                OutlinedButton(
                  onPressed: state.isLoading
                      ? null
                      : () => _onGooglePressed(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFF747775)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google logo
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Image.network(
                          'https://www.google.com/favicon.ico',
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.g_mobiledata, size: 18);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Sign in with Google',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Create account link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to create account
                      },
                      child: Text(
                        'create account',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
