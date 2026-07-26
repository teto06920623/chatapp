// ignore_for_file: deprecated_member_use

import 'package:chat_app_ui/features/Home/marketplace/cubit/marketplace_cubit.dart';
import 'package:chat_app_ui/features/Home/marketplace/models/product_model.dart';
import 'package:chat_app_ui/features/Home/marketplace/services/paymob_service.dart';
import 'package:chat_app_ui/features/Home/marketplace/services/paymob_webview_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsView extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late ProductModel _currentProduct;
  bool isLoadingDetails = false;
  bool isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;
    _loadFullDetails();
  }

  void _loadFullDetails() async {
    if (_currentProduct.id.isNotEmpty) {
      setState(() {
        isLoadingDetails = true;
      });

      final detailedProduct = await context
          .read<MarketplaceCubit>()
          .fetchProductDetails(_currentProduct.id);

      if (detailedProduct != null && mounted) {
        setState(() {
          _currentProduct = detailedProduct;
        });
      }

      if (mounted) {
        setState(() {
          isLoadingDetails = false;
        });
      }
    }
  }

  void _handlePayment() async {
    setState(() {
      isProcessingPayment = true;
    });

    double price = double.tryParse(
          _currentProduct.price.replaceAll(RegExp(r'[^0-9.]'), ''),
        ) ??
        100.0;

    final paymobService = PaymobService();
    String? paymentToken =
        await paymobService.getPaymentToken(amountEgp: price);

    if (!mounted) return;

    setState(() {
      isProcessingPayment = false;
    });

    if (paymentToken != null) {
      String iframeUrl = paymobService.getIframeUrl(paymentToken);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymobWebViewView(paymentUrl: iframeUrl),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('حدث خطأ أثناء تجهيز عملية الدفع، يرجى المحاولة لاحقاً'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المنتج'),
        centerTitle: true,
      ),
      body: isLoadingDetails
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    color: isDark ? const Color(0xff1E1E1E) : Colors.grey[100],
                    child: isValidUrl(_currentProduct.imageUrl)
                        ? Image.network(
                            _currentProduct.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                    child: Icon(Icons.image, size: 80)),
                          )
                        : const Center(child: Icon(Icons.image, size: 80)),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${_currentProduct.price.replaceAll('\$', '')}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'متوفر في المخزن',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _currentProduct.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 32),
                        const Text(
                          'الوصف وتفاصيل الشحن:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'منتج أصلي متوفر عبر الماركت بليس، يتم الشحن والتوصيل خلال 3 إلى 5 أيام عمل. يغطي الضمان إرجاع المنتج خلال 14 يوم.',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: isProcessingPayment ? null : _handlePayment,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: isProcessingPayment
                ? const CircularProgressIndicator(color: Colors.white)
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payment),
                      SizedBox(width: 8),
                      Text(
                        'شراء الآن وتأكيد الدفع',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
