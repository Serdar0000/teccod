import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../exceptions/api_exception.dart';
import '../models/order.dart';

class OrderRepository {
  final String baseUrl;
  final http.Client _client;

  OrderRepository({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<Order> createOrder(int userId, int serviceId) async {
    final uri = Uri.parse('$baseUrl/api/orders');
    final body = jsonEncode({'user_id': userId, 'service_id': serviceId});

    try {
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode >= 400) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final message = json['message'] as String? ?? response.body;
        throw ApiException(message);
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Order.fromJson(json);
    } on SocketException {
      throw ApiException('Нет подключения к сети');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
