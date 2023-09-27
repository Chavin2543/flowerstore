import 'package:flowerstore/scene/createbill/data/model/product.dart';

class BillItemModel {
  final Product product;
  int quantity;

  BillItemModel({
    required this.product,
    this.quantity = 0,
  });
}

extension BillItemModelExtensions on List<BillItemModel> {
  double get total => fold(
        0,
        (
          previousValue,
          element,
        ) =>
            previousValue + (element.quantity * element.product.price),
      );
}
