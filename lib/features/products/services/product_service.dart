import 'package:dio/dio.dart';
import 'package:mad2/core/api/api_client.dart';

class ProductService {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> getProducts(int page) async {
    final response = await _dio.get(
      '/api/products',
      queryParameters: {'page': page},
    );
    return response.data;
  }
}
