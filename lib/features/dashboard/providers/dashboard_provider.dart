import 'package:flutter/material.dart';
import '../../../core/utils/result.dart';
import '../models/dashboard_model.dart';
import '../repositories/dashboard_repository.dart';

class DashboardProvider extends ChangeNotifier {
  final IDashboardRepository _dashboardRepository;
  DashboardData? _dashboardData;
  bool _isLoading = true;
  String? _error;

  String? _selectedCategory;

  DashboardProvider(this._dashboardRepository);

  DashboardData? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCategory => _selectedCategory;

  Future<void> fetchData(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _dashboardRepository.getDashboardData(token);

      if (result.isSuccess && result.data != null) {
        final dashboardModel = result.data!;
        _dashboardData = dashboardModel.data;

        if (_dashboardData != null && _dashboardData!.categories.isNotEmpty) {
          _selectedCategory = _dashboardData!.categories.keys.first;
        } else if (_dashboardData == null) {
          _error = 'Failed to load dashboard data';
        }
      } else {
        _error = result.error ?? 'Failed to load dashboard data';
      }
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

  Future<Result<String>> getSsoTicket(String token) async {
    return await _dashboardRepository.getSsoTicket(token);
  }
}
