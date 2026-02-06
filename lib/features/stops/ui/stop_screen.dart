import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg/features/stops/bloc/stop_bloc.dart';

class StopScreen extends StatelessWidget {
  final String tourId;

  const StopScreen({super.key, required this.tourId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StopBloc()..add(LoadStops(tourId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Stops')),
        body: BlocBuilder<StopBloc, StopState>(
          builder: (context, state) {
            if (state is StopLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StopError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is StopLoaded) {
              if (state.stops.isEmpty) {
                return const Center(
                  child: Text('No stops found for this tour.'),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.stops.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
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
                          Row(
                            children: [
                              if (stop.isHotelAvailable)
                                const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.hotel, size: 20),
                                ),
                              if (stop.has4g)
                                const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.wifi, size: 20),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
