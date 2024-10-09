import 'package:flowerstore/data/datasource/department/model/add_department_request.dart';
import 'package:flowerstore/data/datasource/department/model/delete_department_request.dart';
import 'package:flowerstore/domain/entity/department.dart';
import 'package:flowerstore/presentation/screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/department/department_bloc.dart';

class DepartmentSelectionDialog extends StatefulWidget {
  final Function(Department) onSelect;
  final int? selectedDepartment;

  const DepartmentSelectionDialog({
    Key? key,
    required this.onSelect,
    this.selectedDepartment,
  }) : super(key: key);

  @override
  DepartmentSelectionDialogState createState() =>
      DepartmentSelectionDialogState();
}

class DepartmentSelectionDialogState extends State<DepartmentSelectionDialog> {
  String searchQuery = '';
  int hoveredIndex = -1; // Track the hover index

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentBloc, DepartmentState>(
      builder: (context, state) {
        if (state is DepartmentLoaded) {
          List<Department> filteredDepartments = state.departments
              .where((department) =>
                  department.name
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  searchQuery.isEmpty)
              .toList();

          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredDepartments.length +
                        (searchQuery.isNotEmpty &&
                                !state.departments
                                    .any((d) => d.name == searchQuery)
                            ? 1
                            : 0),
                    itemBuilder: (BuildContext context, int index) {
                      bool isAddNewDepartmentItem =
                          index >= filteredDepartments.length;
                      String departmentName;
                      int departmentId;
                      if (!isAddNewDepartmentItem) {
                        departmentName = filteredDepartments[index].name;
                        departmentId = filteredDepartments[index].id;
                      } else {
                        departmentName = searchQuery;
                        departmentId = -1;
                      }
                      return MouseRegion(
                        onEnter: (_) => setState(() => hoveredIndex = index),
                        onExit: (_) => setState(() => hoveredIndex = -1),
                        child: ListTile(
                          title: Text(departmentName),
                          tileColor: widget.selectedDepartment == departmentId ? Colors.amberAccent : hoveredIndex == index
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary,
                          trailing: isAddNewDepartmentItem
                              ? IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    if (isAddNewDepartmentItem) {
                                      BlocProvider.of<DepartmentBloc>(context)
                                          .add(AddDepartmentEvent(
                                              AddDepartmentRequest(
                                                  name: searchQuery)));
                                    }
                                    searchQuery = '';
                                  },
                                )
                              : IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    BlocProvider.of<DepartmentBloc>(context)
                                        .add(DeleteDepartmentEvent(
                                            DeleteDepartmentRequest(
                                                departmentId: departmentId)));

                                    searchQuery = '';
                                  },
                                ),
                          onTap: () {
                            widget.onSelect(filteredDepartments.firstWhere((element) => element.id == departmentId));
                          },
                        ),
                      );
                    },
                  ),
                ),
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}
