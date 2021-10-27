part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();
}

class MapLoading extends MapState {
  const MapLoading();

  @override
  List<Object?> get props => [];
}

class MapLoaded extends MapState {
  final StopListModel stopList;
  final MapController mapController;
  final List<Marker> markers;

  const MapLoaded({
    required this.stopList,
    required this.mapController,
    required this.markers,
  });

  @override
  List<Object?> get props => [stopList, mapController, markers];
}
