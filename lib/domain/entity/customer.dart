class Customer {
  int id;
  String name;
  String phone;
  String address;
  String departmentIds;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.departmentIds
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      departmentIds: json['department_ids'],
    );
  }
}