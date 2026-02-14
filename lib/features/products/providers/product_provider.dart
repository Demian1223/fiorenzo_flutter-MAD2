import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mad2/core/database/database_helper.dart';
import 'package:mad2/features/products/models/product_model.dart';
import 'package:mad2/features/products/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<ProductModel> _items = [];
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoading = false;
  bool _isOffline = false;
  bool _hasMore = true;
  String? _error;
  bool _isSyncing = false;

  List<ProductModel> get items => _items;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  String? get error => _error;
  bool get hasMore => _hasMore;
  bool get isSyncing => _isSyncing;

  ProductProvider() {
    _init();
  }

  Future<void> _init() async {
    // Initialize DB
    await _dbHelper.database;

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      _isOffline = true;
      await _loadFromDatabase();
    } else {
      await fetchProducts(page: 1);
    }

    // Listen for connectivity changes to auto-reload
    Connectivity().onConnectivityChanged.listen((result) {
      if (!result.contains(ConnectivityResult.none) && _isOffline) {
        _isOffline = false;
        fetchProducts(page: 1, refresh: true);
      } else if (result.contains(ConnectivityResult.none) && !_isOffline) {
        _isOffline = true;
        notifyListeners();
      }
    });
  }

  Future<void> syncAllProducts() async {
    if (_isSyncing) return;
    _isSyncing = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.getProducts(1);
      final meta = response['meta'];
      int totalPages = 1;
      if (meta != null) {
        totalPages = meta['last_page'];
      }

      final List<dynamic> data = response['data'] ?? [];
      final List<ProductModel> page1Products = data
          .map((json) => ProductModel.fromJson(json))
          .toList();
      await _dbHelper.insertProducts(page1Products);

      for (int i = 2; i <= totalPages; i++) {
        final pageResponse = await _service.getProducts(i);
        final List<dynamic> pageData = pageResponse['data'] ?? [];
        final List<ProductModel> pageProducts = pageData
            .map((json) => ProductModel.fromJson(json))
            .toList();
        await _dbHelper.insertProducts(pageProducts);
        debugPrint('Synced page $i / $totalPages');
      }

      if (_items.isEmpty) {
        await _loadFromDatabase();
      }
    } catch (e) {
      _error = 'Sync failed: ${e.toString()}';
      debugPrint(_error);
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> fetchProducts({int page = 1, bool refresh = false}) async {
    if (_isLoading) return;
    if (!_hasMore && page != 1 && !refresh) return;

    if (refresh) {
      _items.clear();
      _currentPage = 1;
      _hasMore = true;
      _error = null;
    }

    _isLoading = true;
    notifyListeners();

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      _isOffline = true;
      await _loadFromDatabase();
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isOffline = false;

    try {
      final response = await _service.getProducts(page);
      final List<dynamic> data = response['data'] ?? [];
      final List<ProductModel> newItems = data
          .map((json) => ProductModel.fromJson(json))
          .toList();

      if (page == 1) {
        _items = newItems;
      } else {
        _items.addAll(newItems);
      }

      final meta = response['meta'];
      if (meta != null) {
        _currentPage = meta['current_page'];
        int lastPage = meta['last_page'];
        _hasMore = _currentPage < lastPage;
      } else {
        _hasMore = newItems.isNotEmpty;
        if (newItems.isNotEmpty) _currentPage++;
      }

      await _dbHelper.insertProducts(newItems);
    } catch (e) {
      _error = 'Failed to load products: ${e.toString()}';
      debugPrint(_error);
      _isOffline = true;
      await _loadFromDatabase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFromDatabase() async {
    final products = await _dbHelper.getAllProducts();
    _items = products;
    _hasMore = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_hasMore && !_isLoading && !_isOffline) {
      await fetchProducts(page: _currentPage + 1);
    }
  }

  Future<void> refresh() async {
    await fetchProducts(page: 1, refresh: true);
  }

  // Filter helper -- AGGRESSIVE FILTERING
  List<ProductModel> getByGender(String? gender) {
    if (gender == null) return _items;
    final normalizedGender = gender.trim().toLowerCase();

    final filtered = _items.where((p) {
      final productGender = p.gender.trim().toLowerCase();
      // 1. Basic Gender Match
      bool matchesGender =
          productGender == normalizedGender ||
          productGender == '${normalizedGender}s' ||
          '${productGender}s' == normalizedGender;

      // 2. AGGRESSIVE NEGATIVE FILTER FOR MEN
      if (normalizedGender == 'men' || normalizedGender == 'mens') {
        final lowerName = p.name.toLowerCase();
        final lowerCat = p.categoryName.toLowerCase();
        final lowerDesc = (p.description ?? '').toLowerCase();

        final forbidden = [
          'women',
          'girl',
          'lady',
          'dress',
          'skirt',
          'blouse',
          'heel',
          'purse',
          'handbag',
          'bag',
          'tote',
          'clutch',
        ];

        for (final word in forbidden) {
          if (lowerName.contains(word) ||
              lowerCat.contains(word) ||
              lowerDesc.contains(word)) {
            return false;
          }
        }
      }
      return matchesGender;
    }).toList();

    return filtered;
  }
}
