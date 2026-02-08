import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg/features/stops/bloc/stop_bloc.dart';

class StopListView extends StatelessWidget {
  const StopListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StopBloc, StopState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.error.isNotEmpty) {
          return Center(child: Text('Error: ${state.error}'));
        } else if (state.stops.isEmpty) {
          return const Center(child: Text('No stops found for this tour.'));
        } else {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.stops.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final stop = state.stops[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stop.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (stop.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(stop.description),
                      ],
                      const SizedBox(height: 8),
                      if (stop.image.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Image.network(stop.image),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
