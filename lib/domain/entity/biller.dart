enum Biller {
  kanokkul,
  kawinwach,
  goodflower,
  pionee,
  rosahan,
  vfet,
}

List<String> allBillerNames = [
  Biller.kanokkul.name,
  Biller.kawinwach.name,
  Biller.goodflower.name,
  Biller.pionee.name,
  Biller.rosahan.name,
  Biller.vfet.name,
];

extension BillerExtension on Biller {
  String get name {
    switch (this) {
      case Biller.kanokkul:
        return 'กนกกุล';
      case Biller.kawinwach:
        return 'กวินวัชร์';
      case Biller.goodflower:
        return 'กู้ดฟลาวเวอร์';
      case Biller.pionee:
        return 'พิโอนี';
      case Biller.rosahan:
        return 'โรสซาฮาน';
      case Biller.vfet:
        return 'วีเฟท';
      default:
        return 'ไม่มีข้อมูล';
    }
  }
}