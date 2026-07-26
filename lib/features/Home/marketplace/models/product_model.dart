class ProductModel {
  final String id;
  final String title;
  final String imageUrl;
  final String price;
  final String productUrl;

  ProductModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.productUrl,
  });

  // 1. لقراءة بيانات القائمة من textsearch.php
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['itemId']?.toString() ??
          json['productId']?.toString() ??
          json['id']?.toString() ??
          '',
      title: json['title'] ?? json['subject'] ?? 'منتج بدون عنوان',
      imageUrl: json['itemMainPic'] ??
          json['imageUrl'] ??
          json['image'] ??
          'https://via.placeholder.com/200',
      price: json['targetSalePrice']?.toString() ??
          json['salePriceFormat']?.toString() ??
          json['price']?.toString() ??
          '10.00',
      productUrl: json['productUrl'] ?? 'https://www.aliexpress.com',
    );
  }

  // 2. لقراءة بيانات التفاصيل المعقدة من getproduct.php
  factory ProductModel.fromDetailJson(Map<String, dynamic> json) {
    final productInfo = json['productInfoComponent'] ?? {};
    final priceComponent = json['priceComponent'] ?? {};
    final skuList = priceComponent['skuPriceList'] as List?;

    // استخراج أول صورة من القائمة
    String img = '';
    if (productInfo['imageList'] != null &&
        (productInfo['imageList'] as List).isNotEmpty) {
      img = productInfo['imageList'][0].toString();
    }

    // استخراج السعر من أول SKU متوفر
    String fetchedPrice = '10.00';
    if (skuList != null && skuList.isNotEmpty) {
      final firstSku = skuList[0]['skuVal'];
      if (firstSku != null && firstSku['skuAmount'] != null) {
        fetchedPrice = firstSku['skuAmount']['formatedAmount']?.toString() ??
            firstSku['skuAmount']['value']?.toString() ??
            '10.00';
      }
    }

    return ProductModel(
      id: productInfo['productId']?.toString() ?? '',
      title: productInfo['subject'] ?? 'منتج بدون عنوان',
      imageUrl: img.isNotEmpty ? img : 'https://via.placeholder.com/200',
      price: fetchedPrice,
      productUrl: 'https://www.aliexpress.com',
    );
  }
}
