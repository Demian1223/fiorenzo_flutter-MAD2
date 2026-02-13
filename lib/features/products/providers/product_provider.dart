import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mad2/features/products/models/product_model.dart';
import 'package:mad2/features/products/services/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<ProductModel> _items = [];
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoading = false;
  bool _isOffline = false;
  bool _hasMore = true; // Added missing field
  String? _error;

  List<ProductModel> get items => _items;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  String? get error => _error;
  bool get hasMore => _hasMore;

  ProductProvider() {
    _init();
  }

  Future<void> _init() async {
    // Initial check for connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _isOffline = true;
      await _loadFromCache();
    } else {
      await fetchProducts(page: 1);
    }
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
      // The API seems to mislabel some women's items as 'men'.
      // We explicitly exclude anything that looks like a women's item.
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
            return false; // Force hide
          }
        }
      }

      return matchesGender;
    }).toList();

    return filtered;
  }

  Future<void> fetchProducts({int page = 1, bool refresh = false}) async {
    // Prevent duplicate calls
    if (_isLoading) return;
    if (!_hasMore && page != 1 && !refresh) return;

    if (refresh) {
      _items.clear();
      _currentPage = 1;
      _hasMore = true;
      _error = null;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    // Check connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _isOffline = true;
      await _loadFromCache();
      // FALLBACK: If cache is also empty, load dummy data
      if (_items.isEmpty) {
        _loadDummyData();
      }
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isOffline = false;

    try {
      // response is Map<String, dynamic>
      final response = await _service.getProducts(page);

      final List<dynamic> data = response['data'] ?? [];
      final List<ProductModel> newItems = data.map((json) {
        final p = ProductModel.fromJson(json);
        debugPrint(
          "Loaded: ${p.name} | Gender: '${p.gender}' (Raw: '${json['gender']}')",
        );
        return p;
      }).toList();

      if (page == 1) {
        _items = newItems;
      } else {
        _items.addAll(newItems);
      }

      // Pagination logic
      final meta = response['meta'];
      if (meta != null) {
        _currentPage = meta['current_page'];
        int lastPage = meta['last_page'];
        _hasMore = _currentPage < lastPage;
      } else {
        // If no meta, assume hasMore if new items were fetched
        _hasMore = newItems.isNotEmpty;
        if (newItems.isNotEmpty) _currentPage++;
      }

      // Cache this page and all products
      await _cachePage(page, data);
      await _updateAllProductsCache();

      // FALLBACK: If API returns empty list (and it's page 1), load dummy data
      if (_items.isEmpty && page == 1) {
        _loadDummyData();
      }
    } catch (e) {
      _error = 'Failed to load products: ${e.toString()}';
      debugPrint(_error);
      _isOffline = true; // Assume offline/error state
      await _loadFromCache();

      // FALLBACK: Load dummy data
      if (_items.isEmpty) {
        _loadDummyData();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _loadDummyData() {
    _items = [
      ProductModel(
        id: 1,
        name: "Classic Silk Shirt",
        description:
            "A timeless staple for every wardrobe. Made from 100% organic silk.",
        price: "120.00",
        imageUrl:
            "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&q=80&w=800",
        gender: "women",
        brandName: "Fiorenzo",
        categoryName: "Shirts",
        images: [
          "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&q=80&w=800",
        ],
      ),
      ProductModel(
        id: 2,
        name: "Leather Weekend Bag",
        description:
            "Handcrafted Italian leather bag perfect for short getaways.",
        price: "450.00",
        imageUrl:
            "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&q=80&w=800",
        gender: "men",
        brandName: "Fiorenzo",
        categoryName: "Bags",
        images: [
          "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&q=80&w=800",
        ],
      ),
      ProductModel(
        id: 3,
        name: "Evening Gown",
        description: "Elegant black evening gown with a modern silhouette.",
        price: "890.00",
        imageUrl:
            "https://images.unsplash.com/photo-1539008835657-9e8e9680c656?auto=format&fit=crop&q=80&w=800",
        gender: "women",
        brandName: "Luxe",
        categoryName: "Dresses",
        images: [
          "https://images.unsplash.com/photo-1539008835657-9e8e9680c656?auto=format&fit=crop&q=80&w=800",
        ],
      ),
      ProductModel(
        id: 4,
        name: "Oxford Shoes",
        description: "Classic leather Oxford shoes with a polished finish.",
        price: "220.00",
        imageUrl:
            "https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?auto=format&fit=crop&q=80&w=800",
        gender: "men",
        brandName: "Fiorenzo",
        categoryName: "Shoes",
        images: [
          "https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?auto=format&fit=crop&q=80&w=800",
        ],
      ),
    ];
    _hasMore = false;
    _error = null;
  }

  Future<void> loadMore() async {
    if (_hasMore && !_isLoading && !_isOffline) {
      await fetchProducts(page: _currentPage + 1);
    }
  }

  Future<void> refresh() async {
    await fetchProducts(page: 1, refresh: true);
  }

  Future<void> _cachePage(int page, List<dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_products_page_$page', jsonEncode(json));
  }

  Future<void> _updateAllProductsCache() async {
    final prefs = await SharedPreferences.getInstance();
    final allItemsJson = _items.map((e) => e.toJson()).toList();
    await prefs.setString('cached_products_all', jsonEncode(allItemsJson));
  }

  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final allCache = prefs.getString('cached_products_all');

    if (allCache != null) {
      final List<dynamic> decoded = jsonDecode(allCache);
      _items = decoded.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      final page1 = prefs.getString('cached_products_page_1');
      if (page1 != null) {
        final List<dynamic> decoded = jsonDecode(page1);
        _items = decoded.map((json) => ProductModel.fromJson(json)).toList();
      }
    }
  }
}
