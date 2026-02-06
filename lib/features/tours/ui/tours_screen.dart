import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ptg/core/utils/routes/routes.dart';
import 'package:ptg/features/tours/bloc/tours_bloc.dart';
import 'package:ptg/features/tours/models/tour_model.dart';
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
    context.read<ToursBloc>().add(LoadTours());
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
      appBar: AppBar(
        title: const Text('Tours'),
        actions: [
          IconButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocBuilder<ToursBloc, ToursState>(
        builder: (context, state) {
          if (state is ToursLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ToursError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ToursLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.tours.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return JourneyCard(tour: state.tours[index]);
              },
            );
          }
          return const Center(child: Text('No tours found.'));
        },
      ),
    );
  }
}

class JourneyCard extends StatelessWidget {
  final Tour tour;

  const JourneyCard({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.primaries[1].withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section (Placeholder for now)
          Container(
            height: 180,

            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: CachedNetworkImage(
              imageUrl: tour.imageUrl,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${tour.distance} km',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.people, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${tour.stops} Stops',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
