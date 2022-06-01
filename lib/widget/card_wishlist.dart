import 'package:flutter/material.dart';
import 'package:flutter_tugas_akhir/theme.dart';

class CardWishlist extends StatelessWidget {
  const CardWishlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(defaultRadius),
          boxShadow: [
            BoxShadow(
              blurRadius: 3.0,
              color: greyColor.withOpacity(0.3),
              offset: const Offset(0, 1),
            )
          ]),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/img2.png',
                  width: 75,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apel Manis',
                      style: blackTextStyle.copyWith(fontWeight: semiBold),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Rp. 10.000',
                      style: greenTextStyle.copyWith(fontWeight: semiBold),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      '1x',
                      style: blackTextStyle,
                    )
                  ],
                ),
              ),
              Image.asset(
                'assets/icon_delete.png',
                width: 25,
                color: greyColor,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: lightColor,
                borderRadius: BorderRadiusDirectional.circular(5),
              ),
              child: Text(
                'Tambah dalam keranjang',
                textAlign: TextAlign.center,
                style: whiteTextStyle.copyWith(fontWeight: bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}