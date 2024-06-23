import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/utils/extension.dart';
import 'package:badges/badges.dart' as badge;
import 'package:shopping_cart/utils/product_shimmer.dart';
import 'package:shopping_cart/utils/shimmer_effect.dart';
import '../api/api.dart';
import '../cart/cart_provider.dart';
import '../model/product_model.dart';
import '../utils/images.dart';
import 'cart_details.dart';
import 'details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApiController>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Products'),
        centerTitle: true,
        actions: [
          Row(
            children: [
              Consumer<CartProvider>(
                builder: (context, value, child) {
                  return badge.Badge(
                    position: badge.BadgePosition.bottomEnd(bottom: 1, end: 1),
                    badgeContent: Text(
                      value.cartCount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CartDetails()));
                      },
                      icon: const Icon(
                        Icons.local_mall,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: context.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextFormField(
              controller: provider.searchController,
              onChanged: (val) {
                provider.onSearch();
              },
              decoration: InputDecoration(
                hintText: 'Search with name',
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200)),
              ),
            ),
          ),
          SizedBox(
            height: context.height * 0.02,
          ),
          Expanded(
            child: FutureBuilder<List<ProductModel>>(
              future: provider.getProduct(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const TProductShimmer();
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(
                      child: Text('Error occurred or no data available'));
                }
                else {
                  return provider.searchController.text.isNotEmpty &&
                          provider.filterItem.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'No results found',
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(15),
                          shrinkWrap: true,
                          itemCount: provider.searchController.text.isNotEmpty
                              ? provider.filterItem.length
                              : provider.productList.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            mainAxisExtent: context.height * 0.31,
                          ),
                          itemBuilder: (context, index) {
                            final data = provider.productList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailsScreen(
                                              productModel: data,
                                            )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        height: context.height * 0.15,
                                        width: double.infinity,
                                        imageUrl: data.image.toString(),
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                        placeholder: (context, url) =>
                                            TShimmerEffect(width: context.width, height: context.height*0.15)
                                      ),
                                    ),
                                    SizedBox(
                                      height: context.height * 0.02,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        provider.searchController.text
                                                .isNotEmpty
                                            ? provider.filterItem[index].title
                                                .toString()
                                            : data.title.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('\$${data.price.toString()}'),
                                          Consumer<CartProvider>(
                                            builder: (context, cart, child) {
                                              return InkWell(
                                                onTap: () {
                                                  cart.addToCart(data, 1);
                                                },
                                                child: Container(
                                                  height: context.height * 0.04,
                                                  width: context.width * 0.04,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.blue,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: cart
                                                          .isLoading(data.id!)
                                                      ? Transform.scale(
                                                          scale: 1.10,
                                                          child: Lottie.asset(
                                                              AppImage.lottie),
                                                        )
                                                      : const Center(
                                                          child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        )),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
