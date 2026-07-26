// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:chat_app_ui/features/Home/marketplace/models/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

part 'marketplace_state.dart';

class MarketplaceCubit extends Cubit<MarketplaceState> {
  MarketplaceCubit() : super(MarketplaceInitial()) {
    _initDio();
  }

  late final Dio _dio;

  final String _rapidApiKey = dotenv.env['RAPIDAPI_KEY'] ?? '';
  final String _rapidApiHost = dotenv.env['RAPIDAPI_HOST'] ?? '';

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://$_rapidApiHost',
        headers: {
          'x-rapidapi-key': _rapidApiKey,
          'x-rapidapi-host': _rapidApiHost,
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  // 20 منتج وهمي ببيانات وصور وروابط حقيقية من Unsplash
  final List<ProductModel> _mockProducts = [
    ProductModel(
      id: 'mock_101',
      title: 'POCO X3 Pro 256GB Dual SIM Phantom Black 8GB RAM',
      imageUrl:
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=600',
      price: '249.99',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_102',
      title: 'Apple iPhone 15 Pro Max 256GB Natural Titanium',
      imageUrl:
          'https://images.unsplash.com/photo-1695048133142-1a20484d2569?q=80&w=600',
      price: '1199.00',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_103',
      title: 'Samsung Galaxy S24 Ultra 512GB Titanium Gray',
      imageUrl:
          'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?q=80&w=600',
      price: '1299.50',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_104',
      title: 'Sony WH-1000XM5 Wireless Noise Canceling Headphones',
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=600',
      price: '348.00',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_105',
      title: 'Apple Watch Series 9 GPS 45 Midnight Aluminum Case',
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=600',
      price: '399.00',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_106',
      title: 'MacBook Pro 16 M3 Max 36GB RAM 1TB SSD Space Black',
      imageUrl:
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=600',
      price: '3499.00',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_107',
      title: 'Anker Magnetic Wireless Power Bank 10000mAh Portable Charger',
      imageUrl:
          'https://images.unsplash.com/photo-1609592424009-1a91f58b1919?q=80&w=600',
      price: '45.99',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_108',
      title: 'Logitech MX Master 3S Wireless Performance Mouse',
      imageUrl:
          'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?q=80&w=600',
      price: '99.99',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_109',
      title: 'Xiaomi Redmi Note 13 Pro+ 5G Midnight Black 12GB RAM',
      imageUrl:
          'https://images.unsplash.com/photo-1598327105666-5b89351aff97?q=80&w=600',
      price: '389.00',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_110',
      title: 'JBL Flip 6 Portable Waterproof Bluetooth Speaker',
      imageUrl:
          'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?q=80&w=600',
      price: '119.95',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_111',
      title: 'DJI Mini 4 Pro Drone with RC 2 Controller 4K HDR Camera',
      imageUrl:
          'https://images.unsplash.com/photo-1527977966376-1c8408f9f108?q=80&w=600',
      price: '759.00',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_112',
      title: 'PlayStation 5 Digital Edition Console DualSense Controller',
      imageUrl:
          'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?q=80&w=600',
      price: '449.99',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_113',
      title: 'AirPods Pro 2nd Gen USB-C MagSafe Charging Case',
      imageUrl:
          'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?q=80&w=600',
      price: '239.00',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_114',
      title: 'Nintendo Switch OLED Model Mario Red Edition',
      imageUrl:
          'https://images.unsplash.com/photo-1578303512597-81e6cc155b3e?q=80&w=600',
      price: '349.00',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_115',
      title: 'ASUS ROG Ally 7" 120Hz FHD Gaming Handheld AMD Z1 Extreme',
      imageUrl:
          'https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=600',
      price: '699.99',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_116',
      title: 'UGREEN 100W GaN Fast Charger 4-Port USB C Charging Station',
      imageUrl:
          'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?q=80&w=600',
      price: '54.99',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_117',
      title: 'Canon EOS R6 Mark II Mirrorless Camera Body',
      imageUrl:
          'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=600',
      price: '2499.00',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_118',
      title: 'Realme GT 5 Pro 5G Snapdragon 8 Gen 3 16GB RAM 512GB',
      imageUrl:
          'https://images.unsplash.com/photo-1565849904461-04a58ad377e0?q=80&w=600',
      price: '529.00',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_119',
      title: 'Baseus Car Phone Holder Mount 15W Wireless Charger Stand',
      imageUrl:
          'https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?q=80&w=600',
      price: '28.50',
      productUrl: 'https://www.aliexpress.com',
    ),
    ProductModel(
      id: 'mock_120',
      title: 'OnePlus 12 5G Silky Black 16GB RAM 512GB Storage',
      imageUrl:
          'https://images.unsplash.com/photo-1580910051074-3eb694886505?q=80&w=600',
      price: '799.00',
      productUrl: 'https://www.aliexpress.com',
    ),
  ];

  // 1. جلب قائمة المنتجات
  Future<void> fetchProducts({String keyword = 'phone'}) async {
    emit(MarketplaceLoading());
    try {
      final response = await _dio.get(
        '/textsearch.php',
        queryParameters: {
          'keyWord': keyword,
          'pageSize': '20',
          'pageIndex': '1',
          'country': 'FR',
          'currency': 'USD',
          'lang': 'en',
          'filter': 'orders',
          'sortBy': 'asc',
        },
      );

      if (response.statusCode == 200) {
        dynamic rawData = response.data;
        if (rawData is String) {
          rawData = jsonDecode(rawData);
        }

        final Map<String, dynamic> responseMap =
            rawData as Map<String, dynamic>;
        final Map<String, dynamic> dataSection = responseMap['data'] ?? {};
        final List items = dataSection['itemList'] ??
            dataSection['products'] ??
            dataSection['resultList'] ??
            [];

        if (items.isNotEmpty) {
          final products = items.map((e) {
            return ProductModel.fromJson(e as Map<String, dynamic>);
          }).toList();

          emit(MarketplaceLoaded(products: products));
          return;
        }
      }

      // في حالة استجابة فارغة أو كود غير 200، نتحول للبيانات البديلة
      emit(MarketplaceLoaded(products: _mockProducts));
    } catch (e) {
      print("API limit/error reached, falling back to Mock Data. Error: $e");
      // Fallback: إرجاع الـ Mock Data عند انتهاء الكوتا أو حدوث أي خطأ
      emit(MarketplaceLoaded(products: _mockProducts));
    }
  }

  // 2. جلب تفاصيل منتج معين
  Future<ProductModel?> fetchProductDetails(String productId) async {
    // لو المنتج من القائمة الوهمية (Mock) ارجعه مباشرة
    if (productId.startsWith('mock_')) {
      return _mockProducts.firstWhere(
        (p) => p.id == productId,
        orElse: () => _mockProducts.first,
      );
    }

    try {
      final response = await _dio.get(
        '/getproduct.php',
        queryParameters: {
          'productId': productId,
          'currency': 'USD',
          'country': 'FR',
          'lang': 'en_US',
          'welcomedeal': 'false',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null) {
          return ProductModel.fromDetailJson(data as Map<String, dynamic>);
        }
      }
    } catch (e) {
      print('Error fetching product details: $e');
    }

    // إرجاع المنتج الأصلي كبديل
    return null;
  }
}
