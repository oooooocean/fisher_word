import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:frontend/services/store.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:frontend/models/net_response.dart';
import 'package:frontend/services/app_configuration.dart';

class Net extends GetConnect {
  Net() : super(timeout: const Duration(seconds: 30), userAgent: 'Sesame-Client') {
    httpClient.addRequestModifier<Object?>((request) async {
      _logRequest(request);
      await _setupHeader(request);
      return request;
    });
  }

  @override
  String get baseUrl => currentEnvironment.host;

  @override
  Decoder<NetResponse> get defaultDecoder => (data) {
        log("---- 响应 ----\n$data");
        try {
          return NetResponse.fromJson(data);
        } catch (error) {
          return NetResponse(NetCode.serverError, null)..message = '服务端未知错误';
        }
      };

  String get _platform {
    if (Platform.isIOS) {
      return 'iOS';
    } else if (Platform.isAndroid) {
      return 'android';
    } else {
      return 'web';
    }
  }

  Future _setupHeader(Request request) async {
    request.headers['Sesame-Platform'] = _platform;
    final token = await StoreToken.getToken();
    if (token != null) request.headers['Authorization'] = token;
  }

  void _logRequest(Request request) async {
    var str = "---- 请求 ----\nmethod: ${request.method}\nurl: ${request.url}\nquery: ${request.url.queryParameters}";
    if (request.method != 'post' || request.headers['content-type'] != 'application/json') {
      log(str);
      return;
    }
    const decoder = Utf8Decoder();
    List<List<int>> bodyBytes = [];
    request.bodyBytes.asBroadcastStream(onListen: (subscribe) {
      subscribe.onData((data) => bodyBytes.add(data));
      subscribe.onDone(() {
        str += '\nbody: ${(bodyBytes.map((e) => decoder.convert(e)).join())}';
        log(str);
      });
    });
  }
}
