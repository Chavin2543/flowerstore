import 'package:flutter/material.dart';

enum MainMenuType {
  createBill,
  manageBill,
  manageFlower,
  editCustomer,
  deleteCustomer,
  report,
}

extension MainMenuTypeExtensions on MainMenuType {
  String get title {
    switch (this) {
      case MainMenuType.createBill:
        return "จัดทำบิล";
      case MainMenuType.manageBill:
        return "ประวัติบิล";
      case MainMenuType.manageFlower:
        return "กำหนดราคา";
      case MainMenuType.editCustomer:
        return "แก้ไขข้อมูลลูกค้า";
      case MainMenuType.deleteCustomer:
        return "ลบลูกค้า";
      case MainMenuType.report:
        return "รายงาน";
    }
  }

  IconData get icon {
    switch (this) {
      case MainMenuType.createBill:
        return Icons.money;
      case MainMenuType.manageFlower:
        return Icons.energy_savings_leaf;
      case MainMenuType.editCustomer:
        return Icons.edit;
      case MainMenuType.deleteCustomer:
        return Icons.delete;
      case MainMenuType.report:
        return Icons.info_rounded;
      case MainMenuType.manageBill:
        return Icons.history;
    }
  }
}