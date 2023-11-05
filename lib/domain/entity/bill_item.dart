import 'package:flowerstore/domain/entity/product.dart';

class BillItem {
  final Product product;
  int quantity;

  BillItem({
    required this.product,
    this.quantity = 0,
  });

  BillItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return BillItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

extension BillItemExtensions on List<BillItem> {
  double get total => fold(
      0,
      (previousValue, element) =>
          previousValue + (element.quantity * element.product.price));
}
