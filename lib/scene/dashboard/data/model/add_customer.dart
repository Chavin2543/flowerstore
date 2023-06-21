class AddCustomer {
  String name;
  String address;
  String phone;

  AddCustomer({
    required this.name,
    required this.address,
    required this.phone,
  });

  factory AddCustomer.fromJson(Map<String, dynamic> json) {
    return AddCustomer(
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
    };
  }
}
