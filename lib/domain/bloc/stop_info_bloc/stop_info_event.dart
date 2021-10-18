part of 'stop_info_bloc.dart';

@immutable
abstract class StopInfoBlocEvent extends Equatable {
  const StopInfoBlocEvent();
}

class GetStopInfo extends StopInfoBlocEvent {
  final String stopId;

  const GetStopInfo({required this.stopId});

  @override
  List<Object?> get props => [stopId];
}
