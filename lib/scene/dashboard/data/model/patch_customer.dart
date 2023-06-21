class PatchCustomer {
  String? name;
  String? phone;
  String? address;

  PatchCustomer({
    this.name,
    this.phone,
    this.address,
  });

  factory PatchCustomer.fromJson(Map<String, dynamic> json) {
    return PatchCustomer(
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
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
