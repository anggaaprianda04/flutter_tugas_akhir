import 'package:flutter_tugas_akhir/models/product_model.dart';

class TokoModel {
  int id;
  int usersId;
  String nameStore;
  String village;
  String address;
  String description;
  String accountName;
  int accountNumber;
  String? image;
  List<ProductModel?> products;

  TokoModel(
      {required this.id,
      required this.usersId,
      required this.nameStore,
      required this.village,
      required this.address,
      required this.description,
      required this.accountName,
      required this.accountNumber,
      required this.image,
      required this.products});

  factory TokoModel.fromJson(Map<String, dynamic> object) {
    return TokoModel(
      id: object['id'] ?? 0,
      usersId: object['users_id'] ?? 0,
      nameStore: object['name_store'] ?? '',
      village: object['village'] ?? '',
      address: object['address'] ?? '',
      description: object['description'] ?? '',
      accountName: object['account_name'] ?? '',
      accountNumber: object['account_number'] ?? 0,
      // ignore: unnecessary_null_comparison
      image: object != null ? object['image'] : null,
      products: object['products'] != null
          ? List.from(object['products'])
              .map((products) => ProductModel.formJson(products))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'users_id': usersId,
      'name_store': nameStore,
      'village': village,
      'address': address,
      'description': description,
      'account_name': accountName,
      'account_number': accountNumber,
      'image': image,
      'products': products.map((products) => products?.id).toList(),
    };
  }
}
