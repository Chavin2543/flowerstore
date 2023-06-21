import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';

enum MainMenuType {
  createBill,
  manageBill,
  manageFlower,
  editCustomer,
  deleteCustomer
}

extension MainMenuTypeExtensions on MainMenuType {
  String get title {
    switch (this) {
      case MainMenuType.createBill:
        return "สร้างบิล";
      case MainMenuType.manageBill:
        return "จัดการบิล";
      case MainMenuType.manageFlower:
        return "จัดการดอกไม้";
      case MainMenuType.editCustomer:
        return "แก้ไขข้อมูลลูกค้า";
      case MainMenuType.deleteCustomer:
        return "ลบลูกค้า";
    }
  }

  IconData get icon {
    switch (this) {
      case MainMenuType.createBill:
        return Icons.money;
      case MainMenuType.manageBill:
        return Icons.history;
      case MainMenuType.manageFlower:
        return Icons.energy_savings_leaf;
      case MainMenuType.editCustomer:
        return Icons.edit;
      case MainMenuType.deleteCustomer:
        return Icons.delete;
    }
  }
}