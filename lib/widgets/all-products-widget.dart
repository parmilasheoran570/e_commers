import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../models/product-model.dart';
import '../screens/user-panel/product-deatils-screen.dart';
import '../utils/app-constant.dart';

class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(

      future: FirebaseFirestore.instance
          .collection('products')
          .where('isSale', isEqualTo: true)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: Get.height / 5,
            child: const Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No products found!"),
          );
        }

        if (snapshot.data != null) {
          return SizedBox(
            height: Get.height / 5,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                ProductModel productModel = ProductModel(
                  productId: productData['productId'],
                  categoryId: productData['categoryId'],
                  productName: productData['productName'],
                  categoryName: productData['categoryName'],
                  salePrice: productData['salePrice'],
                  fullPrice: productData['fullPrice'],
                  productImages: productData['productImages'] is String
                      ? [productData['productImages']]
                      : productData['productImages'],
                  deliveryTime: productData['deliveryTime'],
                  isSale: productData['isSale'],
                  productDescription: productData['productDescription'],
                  createdAt: productData['createdAt'],
                  updatedAt: productData['updatedAt'],
                );

                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() =>
                          ProductDetailsScreen(productModel: productModel)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FillImageCard(
                          borderRadius: 20.0,
                          width: Get.width / 3.5,
                          heightImage: Get.height / 12,
                          imageProvider: CachedNetworkImageProvider(
                            productModel.productImages[0],
                          ),
                          title: Center(
                            child: Text(
                              productModel.productName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 10.0),
                            ),
                          ),
                          footer: Row(
                            children: [
                              Text(
                                "Rs ${productModel.salePrice}",
                                style: const TextStyle(fontSize: 10.0),
                              ),
                              const SizedBox(
                                width: 2.0,
                              ),
                              Text(
                                "${productModel.fullPrice}",
                                style: const TextStyle(
                                  fontSize: 10.0,
                                  color: AppConstant.appScendoryColor,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }

        return Container();
      },
    );
  }
}
