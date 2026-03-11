import 'package:flutter/foundation.dart';

import '../../data/exceptions/api_exception.dart';
import '../../data/models/order.dart';
import '../../data/repositories/order_repository.dart';

enum OrderState { initial, loading, success, error }

class OrderController extends ChangeNotifier {
  final OrderRepository _repository;

  OrderController(this._repository);

  OrderState _state = OrderState.initial;
  Order? _order;
  String? _errorMessage;

  OrderState get state => _state;
  Order? get order => _order;
  String? get errorMessage => _errorMessage;

  Future<void> submitOrder(int userId, int serviceId) async {
    _state = OrderState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _order = await _repository.createOrder(userId, serviceId);
      _state = OrderState.success;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _state = OrderState.error;
    } catch (e) {
      _errorMessage = e.toString();
      _state = OrderState.error;
    }

    notifyListeners();
  }
}
