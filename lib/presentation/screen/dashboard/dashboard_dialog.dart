import 'package:flowerstore/data/datasource/customer/model/add_customer_request.dart';
import 'package:flowerstore/presentation/widget/dialog/confirm_dialog/core_confirm_dialog.dart';
import 'package:flowerstore/presentation/widget/dialog/input_dialog/core_three_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/customer/customer_bloc.dart';
import 'dashboard_screen.dart';

extension DashboardDialog on DashboardScreenState {
  void showAddedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CoreConfirmDialog(
            message: "ลูกค้าถูกเพิ่มเข้าระบบเรียบร้อย",
            onConfirm: () => Navigator.pop(context),
            primaryButtonTitle: "ตกลง",
            secondaryButtonTitle: "ยกเลิก",
            title: "สำเร็จ");
      },
    );
  }

  void openAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => CoreThreeInputDialog(
        onSubmit: (response) => BlocProvider.of<CustomerBloc>(context).add(
          AddCustomerEvent(
            request: AddCustomerRequest(
              name: response.input1,
              address: response.input2,
              phone: response.input3,
            ),
          ),
        ),
        title: "เพิ่มลูกค้า",
        input1Placeholder: "ชื่อลุกค้า",
        input2Placeholder: "ที่อยู่ลูกค้า",
        input3Placeholder: "เบอร์โทรลูกค้า",
        primaryButtonTitle: "เพิ่ม",
        secondaryButtonTitle: "ยกเลอก",
        autoFocusPosition: ThreeAutoFocusPosition.one,
      ),
    );
  }
}
