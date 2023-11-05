import 'package:flowerstore/domain/entity/bill_item.dart';

class AddInvoiceRequest {
  DateTime date = DateTime.now();
  double total;
  int customerId;
  List<BillItem> billItems;

  AddInvoiceRequest({
    required this.total,
    required this.customerId,
    required this.billItems,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'total': total,
      'customer_id': customerId,
    };
  }
}