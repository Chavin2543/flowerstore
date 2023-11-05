class AddCustomerRequest {
  String name;
  String address;
  String phone;

  AddCustomerRequest({
    required this.name,
    required this.address,
    required this.phone,
  });
}

extension AddCustomerRequestJSON on AddCustomerRequest {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
    };
  }
}
