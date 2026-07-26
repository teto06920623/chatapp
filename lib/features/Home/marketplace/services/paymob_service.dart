// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymobService {
  final Dio _dio = Dio();
// 1. تأكد من وضع API Key الخاص بـ Paymob هنا
  final String apiKey = dotenv.env['PAYMOB_API_KEY'] ?? '';
  final int integrationId =
      int.tryParse(dotenv.env['PAYMOB_INTEGRATION_ID'] ?? '0') ?? 0;
  final String iframeId = dotenv.env['PAYMOB_IFRAME_ID'] ?? '';

  Future<String?> getPaymentToken({required double amountEgp}) async {
    try {
      // الخطوة 1: Auth Token
      final authResponse = await _dio.post(
        'https://accept.paymob.com/api/auth/tokens',
        data: {"api_key": apiKey},
      );
      String authToken = authResponse.data['token'];

      // الخطوة 2: Order Registration
      // تحويل المبلغ إلى قروش (100 جنيه = 10000 قرش)
      int amountCents = (amountEgp * 100).toInt();

      final orderResponse = await _dio.post(
        'https://accept.paymob.com/api/ecommerce/orders',
        data: {
          "auth_token": authToken,
          "delivery_needed": "false",
          "amount_cents": amountCents.toString(),
          "currency": "EGP",
          "items": [],
        },
      );
      String orderId = orderResponse.data['id'].toString();

      // الخطوة 3: Payment Key
      final keyResponse = await _dio.post(
        'https://accept.paymob.com/api/acceptance/payment_keys',
        data: {
          "auth_token": authToken,
          "amount_cents": amountCents.toString(),
          "expiration": 3600,
          "order_id": orderId,
          "billing_data": {
            "first_name": "Taha",
            "last_name": "User",
            "email": "user@example.com",
            "phone_number": "+201000000000",
            "apartment": "NA",
            "floor": "NA",
            "street": "NA",
            "building": "NA",
            "shipping_method": "NA",
            "postal_code": "NA",
            "city": "Cairo",
            "country": "EG",
            "state": "NA"
          },
          "currency": "EGP",
          "integration_id": integrationId,
        },
      );

      return keyResponse.data['token'];
    } catch (e) {
      print("Paymob Error: $e");
      return null;
    }
  }

  String getIframeUrl(String paymentToken) {
    return 'https://accept.paymob.com/api/acceptance/iframes/$iframeId?payment_token=$paymentToken';
  }
}
