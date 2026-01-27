import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ptg/features/sign_in/ui/sign_in_screen.dart';
import 'package:ptg/features/splash/initail_screen.dart';
import 'package:ptg/features/tours/ui/tours_screen.dart';

/// Route path constants
class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String tours = '/tours';
  static const String createCity = '/create_city';
  static const String getCities = '/get_cities';
  static const String createTour = '/create_tour';
  static const String getTours = '/get_tours';
  static const String tourDetail = '/tour_detail';
  static const String stopDetail = '/stop_detail';
  static const String addTourStop = '/add_tour_stop';
  static const String root = '/';
  static const String editCity = '/edit_city';
  static const String editTourStop = '/edit_tour_stop';
  static const String tourMap = '/tour-map';
  static const String imageUpload = '/image_upload';
}

/// App router configuration
class AppRouter {
  static GoRouter getRouter(BuildContext context) {
    return GoRouter(
      routerNeglect: true,
      initialLocation: AppRoutes.root,
      routes: [
        GoRoute(
          path: AppRoutes.root,
          builder: (context, state) => const InitialScreen(),
        ),
        GoRoute(
          path: AppRoutes.tours,
          builder: (context, state) => const ToursScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const SignInScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.tours),
                child: const Text('Go to Tours'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
