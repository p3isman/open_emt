import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_emt/data/models/screen_arguments.dart';
import 'package:open_emt/data/models/stop_list_model.dart';
import 'package:open_emt/domain/bloc/stop_info_bloc/stop_info_bloc.dart';
import 'package:open_emt/domain/repositories/emt_repository.dart';
import 'package:open_emt/domain/repositories/location_repository.dart';
import 'package:open_emt/views/screens/detail_screen.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationRepository locationRepository;
  final EMTRepository emtRepository;
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  StopListModel? _stopList;

  MapBloc({required this.locationRepository, required this.emtRepository})
      : super(const MapLoading()) {
    on<InitializeMap>(_onInitializeMap);
    on<CenterMap>(_onCenterMap);
  }

  void _onInitializeMap(InitializeMap event, Emitter<MapState> emit) async {
    _stopList = await emtRepository.getStopList();
    for (var i in _stopList!.data) {
      _markers.add(
        Marker(
          point: LatLng(
            i.geometry.coordinates.last,
            i.geometry.coordinates.first,
          ),
          builder: (ctx) => GestureDetector(
            onTap: () {
              ctx.read<StopInfoBloc>().add(GetStopInfo(stopId: i.node));
              Navigator.pushNamed(ctx, DetailScreen.route,
                  arguments: ScreenArguments(stopId: i.node));
            },
            child: const Card(
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.bus,
                  size: 18.0,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );
      emit(MapLoaded(
        stopList: _stopList!,
        mapController: _mapController,
        markers: _markers,
      ));
    }
  }

  void _onCenterMap(CenterMap event, Emitter<MapState> emit) async {
    emit(const MapLoading());
    final Position location = await locationRepository.getCurrentPosition();
    _mapController.move(LatLng(location.latitude, location.longitude), 15);
    emit(MapLoaded(
      stopList: _stopList!,
      mapController: _mapController,
      markers: _markers,
    ));
  }
}
