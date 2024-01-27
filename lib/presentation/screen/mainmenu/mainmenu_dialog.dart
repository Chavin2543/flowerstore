import 'package:flowerstore/presentation/screen/mainmenu/mainmenu_navigation.dart';
import 'package:flowerstore/presentation/screen/mainmenu/mainmenu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../data/datasource/customer/model/delete_customer_request.dart';
import '../../../data/datasource/customer/model/patch_customer_request.dart';
import '../../../domain/entity/customer.dart';
import '../../../helper/customer_store.dart';
import '../../bloc/customer/customer_bloc.dart';
import '../../widget/dialog/confirm_dialog/core_confirm_dialog.dart';
import '../../widget/dialog/input_dialog/core_three_input_dialog.dart';

extension MainMenuDialog on MainMenuScreen {
  void openDialog(
    BuildContext context,
    Customer customer,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CoreThreeInputDialog(
          onSubmit: (response) {
            BlocProvider.of<CustomerBloc>(context).add(
              PatchCustomerEvent(
                request: PatchCustomerRequest(
                  customerId: customer.id,
                  name: response.input1,
                  address: response.input2,
                  phone: response.input3,
                ),
              ),
            );
          },
          title: "แก้ไข้ข้อมูลลูกค้า",
          input1Placeholder: "ชื่อ",
          prefillInput1: customer.name,
          input2Placeholder: "ที่อยู่",
          prefillInput2: customer.address,
          input3Placeholder: "เบอร์โทร",
          prefillInput3: customer.phone,
          primaryButtonTitle: "แก้ไข",
          secondaryButtonTitle: "ยกเลิก",
          autoFocusPosition: ThreeAutoFocusPosition.one,
        );
      },
    );
  }

  void openCreateBillConfirmationDialog(BuildContext context, int displayedInvoiceId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CoreConfirmDialog(
          message: "ต้องการสร้างบิลที่ $displayedInvoiceId \nของ ${CustomerStore.getCustomerName()} \nต้องการยืนยันหรือไม่?",
          onConfirm: () {
            Navigator.pop(context);
            navigateToCreateBillScreen(context, displayedInvoiceId);
          },
          primaryButtonTitle: "สร้าง",
          secondaryButtonTitle: "ยกเลิก",
          title: "สร้างบิล",
        );
      },
    );
  }

  void openConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CoreConfirmDialog(
          message: "หากลบแล้วจะไม่สามารถย้อนคืนได้",
          onConfirm: () {
            final customerId = CustomerStore.getCustomerId();
            if (customerId != null) {
              BlocProvider.of<CustomerBloc>(context).add(
                DeleteCustomerEvent(
                  request: DeleteCustomerRequest(customerId: customerId),
                ),
              );
            }
            Navigator.of(context).pop();
          },
          primaryButtonTitle: "ลบ",
          secondaryButtonTitle: "ยกเลิก",
          title: "ยืนยันการลบลูกค้า",
        );
      },
    );
  }

  void showPatchToast(BuildContext context) {
    Fluttertoast.showToast(
      msg: 'ข้อมูลถูกแก้ไขแล้ว',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
