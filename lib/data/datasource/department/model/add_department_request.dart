class AddDepartmentRequest {
  String name;

  AddDepartmentRequest({
    required this.name,
  });
}

extension AddDepartmentRequestJSON on AddDepartmentRequest {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}