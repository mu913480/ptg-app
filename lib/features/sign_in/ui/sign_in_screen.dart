import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ptg/features/sign_in/bloc/login_bloc.dart';
import 'package:ptg/features/sign_in/bloc/login_event.dart';
import 'package:ptg/features/sign_in/bloc/login_state.dart';
import 'package:ptg/utils/routes/routes.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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

  void _onGooglePressed(BuildContext context) {
    context.read<LoginBloc>().add(const LoginGoogleSubmitted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
       
      },
      child: Scaffold(
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
      child: Form(
        key: formkey,
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Login title
          Text(
            'Login ',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 32),

          // Email field
          _buildInputField(
            label: 'Email or username',
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email or username';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          // Password field
          _buildPasswordField(
            context,
            'Password',
            _passwordController,  
            (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Login button
          BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              final isLoading = state is LoginLoading;
              return SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _onLoginPressed,
                  child: isLoading
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
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                ),
              );
            },
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

          // Google sign-in button
          _buildGoogleButton(),
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
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    BuildContext context,
    String label,
    TextEditingController controller,
    String? Function(String?)? validator,
    bool obscureText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.visibility_off,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                context.read<LoginBloc>().add(
                  LoginPasswordToggled(),
                );
                 
                
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        return OutlinedButton(
          onPressed: isLoading ? null : _onGooglePressed,
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
        );
      },
    );
  }
}
