class PatchCategoryRequest {
  final int categoryId;
  final int customerId;
  final String name;

  const PatchCategoryRequest({
    required this.categoryId,
    required this.customerId,
    required this.name,
  });
}

extension PatchCategoryRequestJSON on PatchCategoryRequest {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'customer_id': customerId,
    };
  }
}