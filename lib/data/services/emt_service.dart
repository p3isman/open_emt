import 'package:dio/dio.dart';
import 'package:open_emt/data/credentials.dart';
import 'package:open_emt/data/models/stop_list_model.dart';

import 'package:open_emt/data/models/stop_model.dart';

class EMTService {
  final String _authority = 'https://openapi.emtmadrid.es';
  late final String _accessToken;
  late final Dio _dio;

  EMTService() : _dio = Dio();

  Future login() async {
    const path = '/v1/mobilitylabs/user/login';

    final url = _authority + path;

    Response response;

    try {
      response = await _dio.get(
        url,
        options: Options(
          headers: {
            'email': Credentials.email,
            'password': Credentials.password,
          },
        ),
      );
    } on DioError {
      rethrow;
    }

    _accessToken = response.data['data'][0]['accessToken'];
    return true;
  }

  Future<StopModel> getStopInfo(String stopId) async {
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

  Future<int> getNumberOfStops() async {
    Response response;

    try {
      response = await _fetchStopList();
    } on DioError {
      rethrow;
    }

    return response.data['data'].length;
  }

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
}
