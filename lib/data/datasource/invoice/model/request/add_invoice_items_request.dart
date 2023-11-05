import '../../../../../domain/entity/bill_item.dart';

class AddInvoiceItemsRequest {
  int invoiceId;
  List<BillItem> billItem;

  AddInvoiceItemsRequest({
    required this.invoiceId,
    required this.billItem,
  });
}