import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg/features/stops/bloc/stop_bloc.dart';
import 'package:ptg/features/stops/widgets/stop_listview.dart';
import 'package:ptg/features/stops/widgets/stop_mapview.dart';

class StopScreen extends StatefulWidget {
  final String tourId;

  const StopScreen({super.key, required this.tourId});

  @override
  State<StopScreen> createState() => _StopScreenState();
}

class _StopScreenState extends State<StopScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StopBloc>().add(LoadStops(widget.tourId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StopBloc, StopState>(
      listener: (context, state) {
        if (state.error.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Stops'),
            actions: [
              IconButton(
                icon: Icon(
                  context.read<StopBloc>().state.isMapview
                      ? Icons.list
                      : Icons.map,
                ),
                onPressed: () {
                  context.read<StopBloc>().add(ToggleMapView());
                },
              ),
            ],
          ),
          body: state.isMapview ? const StopMapView() : const StopListView(),
        );
      },
    );
  }
}
