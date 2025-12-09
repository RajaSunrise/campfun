import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';
import '../models/equipment.dart';
import '../models/cart_item.dart';

class StorageService {
  static const String _fileName = 'campfun_data.json';

  // In-memory fallback if file storage fails
  Map<String, dynamic>? _memoryCache;

  Future<File?> _getFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return File('${directory.path}/$_fileName');
    } catch (e) {
      // Catch everything, including MissingPluginException
      print("StorageService: Native file system unavailable ($e). Using in-memory storage.");
      return null;
    }
  }

  Future<void> _initFile(File? file) async {
    // Initial Seed Data
    final initialData = {
      'users': [],
      'equipment': [
         {
          "id": "1",
          "name": "Tenda Dome Kapasitas 4",
          "description": "Tenda dome ini adalah pilihan ideal untuk petualangan berkemah Anda. Dengan kapasitas hingga 4 orang.",
          "pricePerDay": 50000.0,
          "category": "Tenda",
          "imageUrl": "https://lh3.googleusercontent.com/aida-public/AB6AXuDbYLUHYRUORmWZ8iNEJqlOoAsRmdN6NjEOCqBuEUXp_Papi7VLHNcR9Bo9JwZFxgyfu1UQbCT8i-bHg6qsXW9uyr1uBxTWKcnzirtm30kd_oX0D6a_oXJgw8kyRcM90zTwS7X1jWtIoxcnK81MLr0A9_hfywgVqRXcj1FyINUsx0yrBw2b0300UoZqKpQqzvZblK7ztdm8gb_HaxXMAPp6qXF0bojzIzsKwVTmy-ewr7v9GIuMnDRsZXMtZfXDfKDP7Vxz3uB0Rz0",
          "available": true
        },
        {
          "id": "2",
          "name": "Carrier 60L Eiger",
          "description": "Tas carrier Eiger berwarna merah dengan kapasitas 60L.",
          "pricePerDay": 45000.0,
          "category": "Tas Carrier",
          "imageUrl": "https://lh3.googleusercontent.com/aida-public/AB6AXuBckgLdoWDljVVy1fWNJEPg0ea0yaywouO5jHYkA0f16DY8Izw_oc21FB47ZyItwSPoCEfNLPFYd5NQhqSztr4xIyZdu4G7r0cHCpsouHMhIe4aSRHzU7YmVNzF-lpY6EPLctDD54GVTwRkn8qwcYniDDeD3TlqUjjiw1KmHMsQqUMV1hsHYX-bHsJSdHhxfx6YxrQqT9FWNWRDiKCum8saMoEtkNvGZFoMqEQ34D2x4rdVLfxXsQ__EXdqrRn0bmcY5MAnUdrauc0",
          "available": true
        },
        {
          "id": "3",
          "name": "Kompor Portable",
          "description": "Kompor gas portable kecil untuk memasak di luar ruangan.",
          "pricePerDay": 20000.0,
          "category": "Alat Masak",
          "imageUrl": "https://lh3.googleusercontent.com/aida-public/AB6AXuAyz0LTqWBQKqIOWBAq8GPD6PGAZnxKYAfYAF0LHxNi74D7cG6cBRBzzqCM-PPpCa_mL6tGdDxRvkOYp0gDvCKEZYfjJ4wEZcKafWrYXqcoqgFzQ3fR1PXrauh5MID4tbR1iVp8ieqA6Xj9fVX71E4y3mAmU58tWUH8oLAtnDEbEejQJvAnKYbyNiJJ4nOiQQhuFvMekleGhav1XYUgT4mObBqIBGK4z85LDt75Of6Jv7Qu_4rRVirOiC796oTxVNQeQ_ueX0gm6tM",
          "available": true
        },
        {
          "id": "4",
          "name": "Sleeping Bag Nyaman",
          "description": "Sleeping bag berwarna hijau tergulung rapi.",
          "pricePerDay": 25000.0,
          "category": "Lainnya",
          "imageUrl": "https://lh3.googleusercontent.com/aida-public/AB6AXuC3asZ_j4n3dexf7hUOL3kq3jBPkb8SLVnf-_vro1MyP85sETlcUSgBxmqQBM6gaa_eDIL_tUl_pHqlLAY43NNrj2vNk-Qj_k34rfM4IbO6wxqPC_15v-ojVhJVI78tk-Sf0UurjpC1MWEVbM5WBLl93wm08vR5NAATsPVGheppy5czYsaZg7RNGWvDUFpIbXJCf8AvGM5OiRt70StUiEiKK2K1FDJVpnqJi9y3FsAHtQSkEX5en7sngRw8jPjhQmBAICo7Zzg18tQ",
          "available": true
        },
         {
          "id": "5",
          "name": "Sepatu Hiking Pria",
          "description": "Sepasang sepatu hiking coklat yang kokoh.",
          "pricePerDay": 40000.0,
          "category": "Lainnya",
          "imageUrl": "https://lh3.googleusercontent.com/aida-public/AB6AXuDqPz6aRejINQNogSNGp_YVBnHvv2cV1nbpmFN9sB8hi5rTKDlCQg307JWjQNxLWFqteAQcv-uM4L13ven9reFOn-7Ss9bPPiJE-SkTsD1D9D7gXdVTHUeEDl5QCra3tzJd9KMtao5BiiI3f0qNStrVz1DUhzvm8P2Qq3H5vBYJ3XsThBZsnOGmq14N0J0CXrDKoa0vKIZIUdE-ow3v3HSFbasxyghKHG5Iy16BmLEreYK4ET2Wdc4rvM9bijlRFBVOQaUJ6rt21MA",
          "available": true
        },
        {
          "id": "6",
          "name": "Carrier 80L Consina",
          "description": "Tas carrier besar berwarna biru tua, kapasitas 80L.",
          "pricePerDay": 55000.0,
          "category": "Tas Carrier",
          "imageUrl": "https://lh3.googleusercontent.com/aida-public/AB6AXuBTVeV8dE2Wzu2a6CCpHW69_B9LHEAtB5YhQGxDo0_YpbJfr-NSdpSGOUgDyRfmP7BTBU19erjmsitgblKUntkUH2QsFXZa7lTLUMh5PT3e7Kc6DUcZ49NyPEjSo41MyxnDoKhlGq8el6Vh8QgathhW_3ugW1ojOrR_bcZbxCT5lPJ2wyctB34mQbGxby1gDevtRObLaH5TZIu0whw5qjw_UzdE-DTWpr2ev1-DAipTZkiiFiWpvzGE1GWzVK4aVj-9W0YoEhcPHDg",
          "available": true
        }
      ],
      'carts': {} // userId -> List<CartItem>
    };

    if (file != null) {
       try {
        if (!await file.exists()) {
          await file.writeAsString(jsonEncode(initialData));
        }
      } catch (e) {
         // Fallback if file write fails despite file object existing
         _memoryCache ??= initialData;
      }
    } else {
       // Initialize in-memory cache if file system unavailable
       _memoryCache ??= initialData;
    }
  }

  Future<Map<String, dynamic>> _readData() async {
    final file = await _getFile();
    await _initFile(file);

    if (file != null) {
       try {
        if (await file.exists()) {
          final content = await file.readAsString();
          return jsonDecode(content);
        } else {
           // Should be handled by _initFile but just in case
           return _memoryCache ?? {};
        }
       } catch (e) {
         print("StorageService: Error reading file ($e). Using in-memory storage.");
         return _memoryCache!;
       }
    } else {
      return _memoryCache!;
    }
  }

  Future<void> _writeData(Map<String, dynamic> data) async {
    // Update memory cache immediately
    _memoryCache = data;

    final file = await _getFile();
    if (file != null) {
       try {
         await file.writeAsString(jsonEncode(data));
       } catch (e) {
         print("StorageService: Error writing file ($e). Data only in memory.");
       }
    }
  }

  // User CRUD
  Future<List<User>> getUsers() async {
    final data = await _readData();
    final usersList = (data['users'] as List?) ?? [];
    return usersList.map((e) => User.fromJson(e)).toList();
  }

  Future<void> addUser(User user) async {
    final data = await _readData();
    final usersList = (data['users'] as List?) ?? [];
    usersList.add(user.toJson());
    data['users'] = usersList;
    await _writeData(data);
  }

  // Equipment Read
  Future<List<Equipment>> getEquipment() async {
    final data = await _readData();
    final list = (data['equipment'] as List?) ?? [];
    return list.map((e) => Equipment.fromJson(e)).toList();
  }

  // Cart CRUD
  Future<List<CartItem>> getCart(String userId) async {
    final data = await _readData();
    final carts = (data['carts'] as Map<String, dynamic>?) ?? {};
    if (carts.containsKey(userId)) {
      final list = (carts[userId] as List?) ?? [];
      return list.map((e) => CartItem.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> addToCart(String userId, CartItem item) async {
    final data = await _readData();
    final carts = (data['carts'] as Map<String, dynamic>?) ?? {};
    List<dynamic> userCart = carts[userId] != null ? (carts[userId] as List) : [];

    // Check if item already exists
    int existingIndex = userCart.indexWhere((e) => e['equipmentId'] == item.equipmentId);
    if (existingIndex != -1) {
       // Update quantity
       var existingItem = CartItem.fromJson(userCart[existingIndex]);
       var newItem = CartItem(
         id: existingItem.id,
         equipmentId: existingItem.equipmentId,
         quantity: existingItem.quantity + item.quantity,
         startDate: item.startDate,
         endDate: item.endDate
       );
       userCart[existingIndex] = newItem.toJson();
    } else {
      userCart.add(item.toJson());
    }

    carts[userId] = userCart;
    data['carts'] = carts;
    await _writeData(data);
  }

  Future<void> updateCartItem(String userId, String cartItemId, int newQuantity) async {
     final data = await _readData();
    final carts = (data['carts'] as Map<String, dynamic>?) ?? {};
    if (carts.containsKey(userId)) {
      List<dynamic> userCart = carts[userId] as List;
      int index = userCart.indexWhere((e) => e['id'] == cartItemId);
      if (index != -1) {
        if (newQuantity <= 0) {
          userCart.removeAt(index);
        } else {
          var item = userCart[index];
          item['quantity'] = newQuantity;
          userCart[index] = item;
        }
        carts[userId] = userCart;
        data['carts'] = carts;
        await _writeData(data);
      }
    }
  }

  Future<void> removeCartItem(String userId, String cartItemId) async {
    final data = await _readData();
    final carts = (data['carts'] as Map<String, dynamic>?) ?? {};
    if (carts.containsKey(userId)) {
      List<dynamic> userCart = carts[userId] as List;
      userCart.removeWhere((e) => e['id'] == cartItemId);
      carts[userId] = userCart;
      data['carts'] = carts;
      await _writeData(data);
    }
  }
}
