class Customer {
  int id;
  String name;
  String phone;
  String address;
  // List<int>? departmentIds;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    // this.departmentIds
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      // departmentIds: json['department_ids'] != null
      //     ? List<int>.from(json['department_ids'] as List)
      //     : null,
    );
  }
}