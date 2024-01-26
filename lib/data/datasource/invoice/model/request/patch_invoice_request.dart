import 'package:flowerstore/domain/entity/bill_item.dart';

class PatchInvoiceRequest {
  int invoiceId;
  int? displayInvoiceId;
  String? date;
  double? total;
  double? discount;
  double? discountedTotal;
  int? department;
  String? biller;
  int? customerId;
  List<BillItem>? currentBillItem;

  PatchInvoiceRequest({
    required this.invoiceId,
    this.date,
    this.total,
    this.displayInvoiceId,
    this.customerId,
    this.currentBillItem,
    this.discount,
    this.discountedTotal,
    this.department,
    this.biller
  });

  Map<String, dynamic> toJson() {
    return {
      'total': total.toString(),
      'invoice_id': displayInvoiceId,
      'department_id': department,
      'biller' : biller,
      'discount': discount,
      'discounted_total': discountedTotal
    };
  }
}
