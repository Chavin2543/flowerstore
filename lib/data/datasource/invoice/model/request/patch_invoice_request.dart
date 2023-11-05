import 'package:flowerstore/domain/entity/bill_item.dart';

class PatchInvoiceRequest {
  int invoiceId;
  String? date;
  double? total;
  int? customerId;
  List<BillItem>? currentBillItem;

  PatchInvoiceRequest({
    required this.invoiceId,
    this.date,
    this.total,
    this.customerId,
    this.currentBillItem
  });

  Map<String, dynamic> toJson() {
    return {
      'total': total,
    };
  }
}
