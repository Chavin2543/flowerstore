class CustomerStore {
  static int? _customerId;
  static String? _customerName;

  static void setCustomerId(int id) {
    _customerId = id;
  }

  static int? getCustomerId() {
    if (_customerId == null) {
      throw Exception("Customer ID is not set.");
    }
    return _customerId;
  }

  static void clearCustomerId() {
    _customerId = null;
  }

  static void setCustomerName(String name) {
    _customerName = name;
  }

  static String? getCustomerName() {
    if (_customerName == null) {
      throw Exception("Customer Name is not set.");
    }
    return _customerName;
  }

  static void clearCustomerName() {
    _customerName = null;
  }
}
