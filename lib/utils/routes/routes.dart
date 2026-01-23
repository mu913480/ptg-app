import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg_admin/features/edit_city/ui/edit_city_screen.dart';
import 'package:ptg_admin/features/splash/splash_screen.dart';
import 'package:ptg_admin/features/tour_map/bloc/tour_map_bloc.dart';
import 'package:ptg_admin/features/tour_map/bloc/tour_map_event.dart';
import 'package:ptg_admin/features/tour_map/ui/tour_map_screen.dart';
import '../../features/auth/ui/auth_screen.dart';
import '../../features/dashboard/ui/dashboard_screen.dart';
import '../../features/image_upload/ui/image_upload_screen.dart';
import '../../features/create_city/ui/create_city_screen.dart';
import '../../features/get_cities/ui/get_cities_page.dart';
import '../../features/create_tours/ui/create_tour_screen.dart';
import '../../features/get_tours/ui/get_tours_screen.dart';
import '../../features/tour_detail/ui/tour_detail_screen.dart';
import '../../features/get_tours/models/get_tour_model.dart';
import '../../features/get_cities/models/city_with_details.dart';

import '../../features/tour_detail/models/stop.dart';
import '../../features/add_tour_stop/ui/add_tour_stop_screen.dart';
import '../../features/add_tour_stop/bloc/add_tour_stop_bloc.dart';
import '../../features/add_tour_stop/bloc/add_tour_stop_event.dart';
import '../../features/stop_detail/ui/stop_detail_screen.dart';
import '../../features/stop_detail/bloc/stop_detail_bloc.dart';
import '../../features/stop_detail/bloc/stop_detail_event.dart';
import '../../features/edit_tour_stop/ui/edit_tour_stop_screen.dart';
import '../../features/edit_tour_stop/bloc/edit_tour_stop_bloc.dart';
import '../../features/edit_tour_stop/bloc/edit_tour_stop_event.dart';
import '../../features/add_tour_stop/models/stop_model.dart' as model;

/// Route path constants
class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
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
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: AppRoutes.dashboard,
          name: 'dashboard',
          builder: (context, state) => DashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.createCity,
          name: 'create_city',
          builder: (context, state) => const CreateCityScreen(),
        ),
        GoRoute(
          path: AppRoutes.getCities,
          name: 'get_cities',
          builder: (context, state) => const GetCitiesPage(),
        ),
        GoRoute(
          path: AppRoutes.createTour,
          name: 'create_tour',
          builder: (context, state) => const CreateTourScreen(),
        ),

        GoRoute(
          path: AppRoutes.getTours,
          name: 'get_tours',
          builder: (context, state) => const GetToursScreen(),
        ),
        GoRoute(
          path: AppRoutes.tourDetail,
          name: 'tour_detail',
          builder: (context, state) {
            final tour = state.extra as GetTourModel;
            return TourDetailScreen(tour: tour);
          },
        ),
        GoRoute(
          path: '${AppRoutes.addTourStop}/:tourId/:tourTitle',
          name: 'add_tour_stop',
          builder: (context, state) {
            final tourId = state.pathParameters['tourId']!;
            final tourTitle = state.pathParameters['tourTitle']!;
            context.read<AddTourStopBloc>().add(
              InitializeAddTourStopEvent(tourId: tourId, tourTitle: tourTitle),
            );
            return const AddTourStopScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.stopDetail,
          name: 'stop_detail',
          builder: (context, state) {
            final stop = state.extra as Stop;
            context.read<StopDetailBloc>().add(InitializeStopDetailEvent(stop));
            return StopDetailScreen(stop: stop);
          },
        ),
        GoRoute(
          path: AppRoutes.editCity,
          name: 'edit_city',
          builder: (context, state) {
            final initialData = state.extra as CityWithDetails?;
            return EditCityScreen(initialData: initialData);
          },
        ),
        GoRoute(
          path: AppRoutes.editTourStop,
          name: 'edit_tour_stop',
          builder: (context, state) {
            final stop = state.extra as model.Stop;

            context.read<EditTourStopBloc>().add(
              InitializeEditTourStopEvent(stop),
            );
            return EditTourStopScreen(stop: stop);
          },
        ),
        GoRoute(
          path: '${AppRoutes.tourMap}/:tourId',
          name: AppRoutes.tourMap,
          builder: (context, state) {
            final tourId = state.pathParameters['tourId']!;
            final tourTitle =
                state.uri.queryParameters['tourTitle'] ?? 'Tour Map';
            context.read<TourMapBloc>().add(
              InitializeMapEvent(tourId: tourId, tourTitle: tourTitle),
            );
            return const TourMapScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.imageUpload,
          name: 'image_upload',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>;
            final tourId = args['tourId'] as String;
            final isUpdate = args['isUpdate'] as bool;
            final oldImageUrl = args['oldImageUrl'] as String?;

            return ImageUploadScreen(
              tourId: tourId,
              isUpdate: isUpdate,
              oldImageUrl: oldImageUrl,
            );
          },
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
                onPressed: () => context.go(AppRoutes.dashboard),
                child: const Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
