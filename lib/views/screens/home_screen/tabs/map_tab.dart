import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_emt/data/models/screen_arguments.dart';
import 'package:open_emt/data/models/stop_list_model.dart';
import 'package:open_emt/domain/bloc/stop_info_bloc/stop_info_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:open_emt/domain/repositories/emt_repository.dart';
import 'package:open_emt/main.dart';
import 'package:open_emt/views/screens/detail_screen/detail_screen.dart';

class MapTab extends StatefulWidget {
  const MapTab({Key? key}) : super(key: key);

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: locator.get<EMTRepository>().getStopList(),
      builder: (BuildContext context, AsyncSnapshot<StopListModel> snapshot) {
        if (snapshot.hasData) {
          final Set<Marker> markers = _createMarkers(context, snapshot.data!);
          return GoogleMap(
            myLocationEnabled: true,
            markers: markers,
            initialCameraPosition: const CameraPosition(
              target: LatLng(40.41317, -3.68307),
              zoom: 15.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Set<Marker> _createMarkers(BuildContext context, StopListModel stopList) {
    Set<Marker> markers = <Marker>{};

    for (var i in stopList.data) {
      markers.add(
        Marker(
          markerId: MarkerId('stop-${i.node}'),
          position: LatLng(
            i.geometry.coordinates.last,
            i.geometry.coordinates.first,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          onTap: () {
            context.read<StopInfoBloc>().add(GetStopInfo(stopId: i.node));
            Navigator.pushNamed(context, DetailScreen.route,
                arguments: ScreenArguments(stopId: i.node));
          },
        ),
      );
    }
    return markers;
  }
}
