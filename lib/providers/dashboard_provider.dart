import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import '../models/dashboard_model.dart';
import '../core/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService _dashboardService = DashboardService();
  DashboardData? _dashboardData;
  bool _isLoading = true;
  String? _error;

  String? _expandedCategory;
  final Map<String, GlobalKey<FlipCardState>> _cardKeys = {};

  DashboardData? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get expandedCategory => _expandedCategory;

  GlobalKey<FlipCardState>? getCardKey(String category) => _cardKeys[category];

  Future<void> fetchData(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _dashboardData = await _dashboardService.getDashboardData(token);
      
      if (_dashboardData != null) {
        _cardKeys.clear();
        for (var category in _dashboardData!.categories.keys) {
          _cardKeys[category] = GlobalKey<FlipCardState>();
        }
      } else {
        _error = 'Failed to load dashboard data';
      }
    } on UnauthorizedException {
      // Re-throw so UI can handle logging the user out
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

  void onCardTap(String category) {
    if (_expandedCategory != null && _expandedCategory != category) {
      _cardKeys[_expandedCategory]?.currentState?.toggleCard();
    }

    _expandedCategory = category;
    _cardKeys[category]?.currentState?.toggleCard();
    notifyListeners();
  }

  void onHeaderTap(String category) {
    if (_expandedCategory == category) {
      _cardKeys[category]?.currentState?.toggleCard();
      _expandedCategory = null;
      notifyListeners();
    }
  }
}
