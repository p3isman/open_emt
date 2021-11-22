import 'package:dio/dio.dart';
import 'package:open_emt/data/credentials.dart';
import 'package:open_emt/data/models/stop_list_model.dart';

import 'package:open_emt/data/models/stop_model.dart';
import 'package:open_emt/domain/repositories/i_emt_repository.dart';

class EMTRepository implements IEMTRepository {
  bool _isLoggedIn = false;

  final String _authority = 'https://openapi.emtmadrid.es';
  late final String _accessToken;
  late final Dio _dio;

  EMTRepository() : _dio = Dio();

  Future login() async {
    const path = '/v1/mobilitylabs/user/login';

    final url = _authority + path;

    Response response;

    try {
      response = await _dio.get(
        url,
        options: Options(
          headers: {
            'X-ClientId': Credentials.xClientId,
            'passKey': Credentials.passKey,
          },
        ),
      );
    } on DioError {
      rethrow;
    }

    _accessToken = response.data['data'][0]['accessToken'];
    _isLoggedIn = true;
    return true;
  }

  @override
  Future<StopModel> getStopInfo(String stopId) async {
    // Log in if necessary
    if (!_isLoggedIn) {
      try {
        await login();
      } on DioError {
        rethrow;
      }
    }

    final path = '/v1/transport/busemtmad/stops/$stopId/arrives/';

    final url = _authority + path;

    Response response;

    try {
      response = await _dio.post(
        url,
        options: Options(
          headers: {'accessToken': _accessToken},
        ),
        data: {
          "cultureInfo": "ES",
          "Text_StopRequired_YN": "Y",
          "Text_EstimationsRequired_YN": "Y"
        },
      );
    } on DioError {
      rethrow;
    }

    return StopModel.fromJson(response.data);
  }

  @override
  Future<int> getNumberOfStops() async {
    Response response;

    try {
      response = await _fetchStopList();
    } on DioError {
      rethrow;
    }

    return response.data['data'].length;
  }

  @override
  Future<StopListModel> getStopList() async {
    Response response;

    try {
      response = await _fetchStopList();
    } on DioError {
      rethrow;
    }

    return StopListModel.fromJson(response.data);
  }

  Future _fetchStopList() async {
    if (!_isLoggedIn) {
      try {
        await login();
      } on DioError {
        rethrow;
      }
    }

    const path = '/v1/transport/busemtmad/stops/list/';

    final url = _authority + path;

    Response response;

    try {
      response = await _dio.post(
        url,
        options: Options(
          headers: {'accessToken': _accessToken},
        ),
      );
    } on DioError {
      rethrow;
    }

    return response;
  }

  @override
  List<List<Arrive>> groupArrivesByLine(List<Arrive> arrives) {
    arrives.sort((a, b) => a.line.compareTo(b.line));

    // Check if line has only one arrive value (has no pair)
    // arrives.retainWhere((element) {
    //   for (var i in arrives) {
    //     if (element.line == i.line && element != i) return true;
    //   }
    //   return false;
    // });

    List<List<Arrive>> orderedArrives = [];

    for (int i = 0; i < arrives.length;) {
      List<Arrive> lineArrives = [];
      lineArrives.add(arrives[i++]);
      lineArrives.add(arrives[i++]);
      lineArrives.sort((a, b) => a.estimateArrive.compareTo(b.estimateArrive));
      orderedArrives.add(lineArrives);
    }

    orderedArrives.sort(
        (a, b) => a.first.estimateArrive.compareTo(b.first.estimateArrive));

    return orderedArrives;
  }
}
