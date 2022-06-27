// ignore_for_file: unnecessary_cast, unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tugas_akhir/models/product_model.dart';
import 'package:flutter_tugas_akhir/models/toko_model.dart';
import 'package:flutter_tugas_akhir/models/user_model.dart';
import 'package:flutter_tugas_akhir/page/detail_store_page.dart';
import 'package:flutter_tugas_akhir/provider/auth_provider.dart';
import 'package:flutter_tugas_akhir/provider/cart_provider.dart';
import 'package:flutter_tugas_akhir/provider/page_provider.dart';
import 'package:flutter_tugas_akhir/provider/product_provider.dart';
import 'package:flutter_tugas_akhir/provider/wishlist_provider.dart';
import 'package:flutter_tugas_akhir/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailProductPage extends StatefulWidget {
  final ProductModel product;

  const DetailProductPage({Key? key, required this.product}) : super(key: key);

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  bool isWishlist = false;
  bool isLoading = true;
  dynamic quantity = 1;
  final currencyFormatter = NumberFormat.currency(locale: 'ID');

  fetchProduct() async {
    ProductProvider productProvider = Provider.of(context, listen: false);
    await productProvider.getProductId(id: widget.product.id!.toInt());
    setState(() {
      isLoading = false;
    });
  }

  fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('token');
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    await authProvider.getProfile();
  }

  @override
  void initState() {
    super.initState();
    fetchProduct();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    WishlistProvider wishlistProvider = Provider.of<WishlistProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    PageProvider pageProvider = Provider.of<PageProvider>(context);
    ProductModel? product = productProvider.getProduct;
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel? user = authProvider.user;

    Widget detailImage() {
      return SizedBox(
        height: MediaQuery.of(context).orientation == Orientation.landscape
            ? MediaQuery.of(context).size.height * 0.6
            : 338,
        child: product?.image == null || product!.image!.isEmpty
            ? Image.asset(
                'assets/images/not_product.jpeg',
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                fit: BoxFit.cover,
                width: double.infinity,
                imageUrl: widget.product.image.toString(),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Image(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/not_product.jpeg',
                  ),
                ),
              ),
      );
    }

    Widget header() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 17),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Get.offNamedUntil('/main-page', (route) => false,
                    arguments: pageProvider.currentIndex == 0);
              },
              child: CircleAvatar(
                backgroundColor: greyColor.withOpacity(0.4),
                child: Icon(
                  Icons.chevron_left,
                  color: whiteColor,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget descriptionProduct() {
      return Container(
        margin: const EdgeInsets.only(top: 310),
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        width: double.infinity,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: const BorderRadiusDirectional.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product!.name.toString(),
                  style:
                      blackTextStyle.copyWith(fontSize: 18, fontWeight: bold),
                ),
                GestureDetector(
                  onTap: () {
                    cartProvider
                        .addtoCart(
                            userId: user!.id.toString(),
                            productId: product.id!.toString(),
                            quantity: quantity)
                        .then(
                          (value) => Get.snackbar('', '',
                              backgroundColor: secondaryColor.withOpacity(0.8),
                              titleText: Text(
                                'Berhasil',
                                style: whiteTextStyle.copyWith(
                                    fontWeight: semiBold, fontSize: 17),
                              ),
                              mainButton: TextButton(
                                  onPressed: () {
                                    Get.toNamed('/cart-page');
                                  },
                                  child: Text(
                                    'Lihat',
                                    style: whiteTextStyle.copyWith(
                                        fontWeight: semiBold),
                                  )),
                              messageText: Text(
                                  'Berhasil ditambah ke keranjang',
                                  style: whiteTextStyle.copyWith(fontSize: 14)),
                              colorText: Colors.white),
                        );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: primaryColor,
                    ),
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: whiteColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Keranjang',
                          style: whiteTextStyle.copyWith(fontWeight: semiBold),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currencyFormatter.format(product.price),
                  style:
                      blackTextStyle.copyWith(fontSize: 18, fontWeight: medium),
                ),
                GestureDetector(
                  onTap: () async {
                    wishlistProvider.setProduct(widget.product);
                    if (wishlistProvider.isWishlist(widget.product)) {
                      Get.snackbar('', '',
                          backgroundColor: secondaryColor.withOpacity(0.8),
                          titleText: Text(
                            'Sukses',
                            style: whiteTextStyle.copyWith(
                                fontWeight: semiBold, fontSize: 17),
                          ),
                          messageText: Text('Berhasil ditambah ke wishlist',
                              style: whiteTextStyle.copyWith(fontSize: 14)),
                          colorText: Colors.white);
                    } else {
                      Get.snackbar('', '',
                          backgroundColor: dangerColor.withOpacity(0.8),
                          titleText: Text(
                            'Berhasil',
                            style: whiteTextStyle.copyWith(
                                fontWeight: semiBold, fontSize: 17),
                          ),
                          messageText: Text('Berhasil dihapus dari wishlist',
                              style: whiteTextStyle.copyWith(fontSize: 14)),
                          colorText: Colors.white);
                    }
                  },
                  child: Image.asset(
                    wishlistProvider.isWishlist(widget.product)
                        ? 'assets/icon_love_on.png'
                        : 'assets/icon_love_off.png',
                    width: 50,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kategori',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      product.category!.name.toString(),
                      style: blackTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stok',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      product.stock.toString(),
                      style: blackTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Berat',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      product.weight.toString() + ' Kg',
                      style: blackTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Deskripsi Produk',
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.description.toString(),
              textAlign: TextAlign.justify,
              style: blackTextStyle.copyWith(fontSize: 14, fontWeight: medium),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(defaultRadius),
                  child: product.market?.image == null
                      ? Image.asset(
                          'assets/images/not_product.jpeg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          product.market!.image.toString(),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(
                  width: 13,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.market!.nameStore.toString(),
                      style: blackTextStyle.copyWith(
                          fontSize: 16, fontWeight: semiBold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.map_outlined),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          product.market!.village.toString(),
                          style: blackTextStyle.copyWith(fontWeight: medium),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(10)),
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          )),
                      onPressed: () {
                        Get.to(
                          () => DetailStorePage(
                              toko: product.market as TokoModel),
                        );
                      },
                      child: Text('Kunjungi Toko',
                          style: whiteTextStyle.copyWith(fontWeight: bold)),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(
              color: greyColor,
              thickness: 4.0,
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 10.0,
                color: Colors.green,
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(
                children: [
                  detailImage(),
                  header(),
                  descriptionProduct(),
                ],
              ),
            ),
    );
  }
}
