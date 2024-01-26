import 'package:flowerstore/domain/entity/bill_item.dart';

class AddInvoiceRequest {
  DateTime date = DateTime.now();
  double total;
  int customerId;
  int invoiceId;
  List<BillItem> billItems;

  AddInvoiceRequest({
    required this.total,
    required this.customerId,
    required this.billItems,
    required this.invoiceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'total': 0.00,
      'customer_id': customerId,
      'invoice_id': invoiceId,
      'discount' : 0.00,
      'discounted_total' : 0.00,
      'biller': "",
      'department_id': 0
    };
  }
}
