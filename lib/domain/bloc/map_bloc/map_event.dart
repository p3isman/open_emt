part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
}

class InitializeMap extends MapEvent {
  const InitializeMap();

  @override
  List<Object?> get props => [];
}

class CenterMap extends MapEvent {
  const CenterMap();

  @override
  List<Object?> get props => [];
}
