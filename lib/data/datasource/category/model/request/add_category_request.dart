class AddCategoryRequest {
  String name;
  int customerId;

  AddCategoryRequest({
    required this.name,
    required this.customerId,
  });
}

extension AddCategoryRequestJSON on AddCategoryRequest {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'customer_id': customerId,
    };
  }
}