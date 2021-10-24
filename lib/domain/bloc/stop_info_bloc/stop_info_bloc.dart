import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:open_emt/data/models/stop_model.dart';
import 'package:open_emt/domain/repositories/emt_repository.dart';

part 'stop_info_event.dart';
part 'stop_info_state.dart';

class StopInfoBloc extends Bloc<StopInfoBlocEvent, StopInfoState> {
  final EMTRepository emtRepository;

  StopInfoBloc({required this.emtRepository}) : super(const StopInfoEmpty()) {
    on<GetStopInfo>(_onGetStopInfo);
  }

  Future<void> _onGetStopInfo(
      GetStopInfo event, Emitter<StopInfoState> emit) async {
    emit(const StopInfoLoading());

    StopModel? stopInfo;

    try {
      stopInfo = await emtRepository.getStopInfo(event.stopId);
    } on DioError catch (e) {
      return emit(StopInfoError(error: e));
    }

// When description is a list it means there was an error
    if (stopInfo?.description is List) {
      return emit(const StopInfoError());
    }

    if (stopInfo is StopModel && stopInfo.code == '00') {
      return emit(StopInfoLoaded(stopInfo: stopInfo));
    }

    emit(const StopInfoError());
  }
}
