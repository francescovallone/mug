import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mug/mug.dart';

class Request{

  late String path;
  late Uri uri;
  late String method;
  late List<String> segments;
  late HttpRequest _httpRequest;
  Uint8List? _bytes;
  late Map<String, String> queryParameters;
  ContentType contentType = ContentType('text', 'plain');

  Request.fromHttpRequest(HttpRequest request){
    path = request.requestedUri.path;
    uri = request.requestedUri;
    method = request.method;
    queryParameters = request.requestedUri.queryParameters;
    segments = Uri(path: request.requestedUri.path).pathSegments;
    contentType = request.headers.contentType ?? ContentType('text', 'plain');
    _httpRequest = request;
  }

  Future<String> body() async {
    final data = await bytes();
    if(data.isEmpty){
      return "";
    }
    String stringData = Utf8Decoder().convert(data);
    return stringData;
  }

  Future<dynamic> json() async {
    final data = await body();
    if(data.isEmpty){
      return {};
    }
    try{
      dynamic jsonData = JsonDecoder().convert(data);
      contentType = ContentType('application', 'json');
      return jsonData;
    }catch(e){
      throw BadRequestException(message: "The json body is malformed");
    }
  }

  Future<Uint8List> bytes() async {
    try{
      _bytes ??= await _httpRequest.firstWhere((element) => element.isNotEmpty);
      return _bytes!;
    }catch(e){
      return Uint8List(0);
    }
  }
}