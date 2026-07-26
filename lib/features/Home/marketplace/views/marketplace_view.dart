import 'package:chat_app_ui/features/Home/marketplace/cubit/marketplace_cubit.dart';
import 'package:chat_app_ui/features/Home/marketplace/views/product_details_view.dart';
import 'package:chat_app_ui/features/Home/marketplace/widgets/product_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarketplaceView extends StatelessWidget {
  const MarketplaceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MarketplaceCubit()..fetchProducts(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Builder(builder: (context) {
                return TextField(
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      context
                          .read<MarketplaceCubit>()
                          .fetchProducts(keyword: value.trim());
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'البحث عن منتجات في Marketplace...',
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                );
              }),
            ),
            Expanded(
              child: BlocConsumer<MarketplaceCubit, MarketplaceState>(
                listener: (context, state) {
                  if (state is MarketplaceError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is MarketplaceLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MarketplaceLoaded) {
                    if (state.products.isEmpty) {
                      return const Center(child: Text('لا توجد منتجات متاحة'));
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        await context.read<MarketplaceCubit>().fetchProducts();
                      },
                      child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          final product = state.products[index];
                          return ProductCardItem(
                            product: product,
                            onTap: () {
                              final cubit = context.read<MarketplaceCubit>();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: cubit,
                                    child: ProductDetailsView(product: product),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                  return const Center(
                      child: Text('ابحث عن المنتجات أو اسحب للتحديث'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
