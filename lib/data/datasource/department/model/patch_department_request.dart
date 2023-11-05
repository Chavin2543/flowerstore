class PatchDepartmentRequest {
  final int departmentId;
  final String name;

  const PatchDepartmentRequest({
    required this.departmentId,
    required this.name,
  });
}

extension PatchDepartmentRequestJSON on PatchDepartmentRequest {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}