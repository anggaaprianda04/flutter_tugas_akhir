import 'package:flutter/material.dart';
import 'package:flutter_tugas_akhir/models/category_model.dart';
import 'package:flutter_tugas_akhir/page/category_page.dart';
import 'package:flutter_tugas_akhir/theme.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel categories;

  const CategoryItem({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryPage(category: categories),
            ));
      },
      child: Container(
        height: 40,
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: backgroundColor3,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(
              categories.name,
              style: whiteTextStyle.copyWith(fontWeight: bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}