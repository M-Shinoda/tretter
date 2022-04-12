import 'package:dio/dio.dart';

final dio =
    Dio(BaseOptions(baseUrl: 'https://api.trello.com/1/', queryParameters: {
  'key': '0c5038bf942adce702fcf3d640fe9f9e',
  'token': '7c059ae9c2ed38feefb87b88c0a86488ff14b6651a2bb849333002c5c3bbbe00'
}));
