import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../models/equipment.dart';
import '../models/cart_item.dart';
import '../services/storage_service.dart';

class AppProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  User? _currentUser;
  List<Equipment> _equipment = [];
  List<CartItem> _cart = [];
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  List<Equipment> get equipment => _equipment;
  List<CartItem> get cart => _cart;
  bool get isLoading => _isLoading;

  Future<void> loadInitialData() async {
    _setLoading(true);
    try {
      _equipment = await _storageService.getEquipment();
      if (_currentUser != null) {
        _cart = await _storageService.getCart(_currentUser!.id);
      }
    } catch (e) {
      print("Error loading data: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final users = await _storageService.getUsers();
      try {
        final user = users.firstWhere(
            (u) => u.email == email && u.password == password);
        _currentUser = user;
        await loadInitialData(); // Load cart for this user
        notifyListeners();
        return true;
      } catch (e) {
        return false;
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    try {
      final users = await _storageService.getUsers();
      if (users.any((u) => u.email == email)) {
        return false; // Email already exists
      }

      final newUser = User(
        id: const Uuid().v4(),
        name: name,
        email: email,
        password: password,
      );
      await _storageService.addUser(newUser);
      // Auto login after register
      _currentUser = newUser;
      await loadInitialData();
      notifyListeners();
      return true;
    } finally {
      _setLoading(false);
    }
  }

  void logout() {
    _currentUser = null;
    _cart = [];
    notifyListeners();
  }

  Future<void> addToCart(Equipment equipment, int quantity, DateTime startDate, DateTime endDate) async {
    if (_currentUser == null) return;
    _setLoading(true);
    try {
      final item = CartItem(
        id: const Uuid().v4(),
        equipmentId: equipment.id,
        quantity: quantity,
        startDate: startDate,
        endDate: endDate,
      );
      await _storageService.addToCart(_currentUser!.id, item);
      await _refreshCart();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateCartItem(String cartItemId, int quantity) async {
     if (_currentUser == null) return;
     _setLoading(true);
     try {
       await _storageService.updateCartItem(_currentUser!.id, cartItemId, quantity);
       await _refreshCart();
     } finally {
       _setLoading(false);
     }
  }

  Future<void> removeCartItem(String cartItemId) async {
    if (_currentUser == null) return;
    _setLoading(true);
    try {
      await _storageService.removeCartItem(_currentUser!.id, cartItemId);
      await _refreshCart();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _refreshCart() async {
    if (_currentUser != null) {
      _cart = await _storageService.getCart(_currentUser!.id);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
