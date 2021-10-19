part of 'stop_info_bloc.dart';

@immutable
abstract class StopInfoState extends Equatable {
  const StopInfoState();
}

class StopInfoEmpty extends StopInfoState {
  const StopInfoEmpty();

  @override
  List<Object?> get props => [];
}

class StopInfoLoading extends StopInfoState {
  const StopInfoLoading();

  @override
  List<Object?> get props => [];
}

class StopInfoLoaded extends StopInfoState {
  final StopModel stopInfo;

  const StopInfoLoaded({required this.stopInfo});

  @override
  List<Object?> get props => [stopInfo];
}

class StopInfoError extends StopInfoState {
  final DioError? error;

  const StopInfoError({this.error});

  @override
  List<Object?> get props => [error];
}
