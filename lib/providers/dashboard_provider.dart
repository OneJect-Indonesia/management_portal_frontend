import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';
import '../core/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService _dashboardService = DashboardService();
  DashboardData? _dashboardData;
  bool _isLoading = true;
  String? _error;

  String? _selectedCategory;

  DashboardData? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCategory => _selectedCategory;

  Future<void> fetchData(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _dashboardData = await _dashboardService.getDashboardData(token);
      
      if (_dashboardData != null && _dashboardData!.categories.isNotEmpty) {
        _selectedCategory = _dashboardData!.categories.keys.first;
      } else if (_dashboardData == null) {
        _error = 'Failed to load dashboard data';
      }
    } on UnauthorizedException {
      rethrow;
    } on NetworkException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
