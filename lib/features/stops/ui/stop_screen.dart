import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg/features/stops/bloc/stop_bloc.dart';
import 'package:ptg/features/stops/widgets/stop_listview.dart';
import 'package:ptg/features/stops/widgets/stop_mapview.dart';

class StopScreen extends StatelessWidget {
  final String tourId;

  const StopScreen({super.key, required this.tourId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StopBloc()..add(LoadStops(tourId)),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Stops'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Overview'),
                Tab(text: 'Stops'),
              ],
            ),
          ),
          body: TabBarView(children: [StopMapView(), StopListView()]),
        ),
      ),
    );
  }
}
