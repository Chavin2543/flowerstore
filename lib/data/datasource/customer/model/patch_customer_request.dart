class PatchCustomerRequest {
  int customerId;
  String? name;
  String? phone;
  String? address;

  PatchCustomerRequest({
    required this.customerId,
    this.name,
    this.phone,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
    };
  }
}
