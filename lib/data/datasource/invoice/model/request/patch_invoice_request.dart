import 'package:flowerstore/domain/entity/bill_item.dart';

class PatchInvoiceRequest {
  int invoiceId;
  int? displayInvoiceId;
  String? date;
  double? total;
  int? customerId;
  List<BillItem>? currentBillItem;

  PatchInvoiceRequest({
    required this.invoiceId,
    this.date,
    this.total,
    this.displayInvoiceId,
    this.customerId,
    this.currentBillItem
  });

  Map<String, dynamic> toJson() {
    return {
      'total': total.toString(),
      'invoice_id': displayInvoiceId,
    };
  }
}
