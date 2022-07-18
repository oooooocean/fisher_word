import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:frontend/models/net_response.dart';
import 'package:frontend/net/net.dart';

mixin NetMixin {
  final net = Net();

  bool get shouldRequest => true;

  Future? request<T>({required ValueGetter<Future<T>> api, ValueSetter<T>? success, ValueSetter<Error>? fail}) async {
    if (!shouldRequest) {
      EasyLoading.showToast('请完善信息后重试');
      return;
    }

    EasyLoading.show();
    return api().then((value) {
      EasyLoading.dismiss();
      if (success != null) success(value);
    }).catchError((error) {
      EasyLoading.dismiss();
      EasyLoading.showToast(error.toString());
      if (fail != null) fail(error);
      if (!const bool.fromEnvironment("dart.vm.product")) throw error;
    });
  }

  Future<T> get<T>(String uri, Decoder<T> decoder, {Map<String, dynamic>? query}) async {
    final res = (await net.get<NetResponse>(uri, query: query, decoder: net.defaultDecoder)).body;
    return _parse(res, decoder);
  }

  Future<T> post<T>(String uri, Map<String, dynamic> body, Decoder<T> decoder) async {
    final res =
        (await net.post<NetResponse>(uri, body, contentType: 'application/json', decoder: net.defaultDecoder)).body;
    return _parse(res, decoder);
  }

  Future<T> patch<T>(String uri, Map<String, dynamic> body, Decoder<T> decoder) async {
    final res =
        (await net.patch<NetResponse>(uri, body, contentType: 'application/json', decoder: net.defaultDecoder)).body;
    return _parse(res, decoder);
  }

  Future<T> delete<T>(String uri, Map<String, dynamic>? query, Decoder<T> decoder) async {
    final res = (await net.delete<NetResponse>(uri, query: query, decoder: net.defaultDecoder)).body;
    return _parse(res, decoder);
  }

  Future<T> _parse<T>(NetResponse? res, Decoder<T> decoder) async {
    if (res == null) throw NetError()..message = '服务端返回无法解析';
    if (res.code != NetCode.success) {
      if (res.code == NetCode.loginOverdue) {
      }
      throw res;
    }
    return decoder(res.data);
  }
}
