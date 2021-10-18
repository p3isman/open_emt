import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:open_emt/data/models/stop_model.dart';
import 'package:open_emt/domain/repositories/emt_repository.dart';

part 'stop_info_event.dart';
part 'stop_info_state.dart';

class StopInfoBloc extends Bloc<StopInfoBlocEvent, StopInfoState> {
  final EMTRepository emtRepository;

  StopInfoBloc({required this.emtRepository}) : super(const StopInfoEmpty()) {
    on<StopInfoBlocEvent>((event, emit) {
      if (event is GetStopInfo) {
        _mapGetStopInfoToState(event, emit);
      }
    });
  }

  void _mapGetStopInfoToState(
      GetStopInfo event, Emitter<StopInfoState> emit) async {
    emit(const StopInfoLoading());
    final stopInfo = await emtRepository.getStopInfo(event.stopId);
    emit(StopInfoLoaded(stopInfo: stopInfo));
  }
}
