import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/employee_bloc.dart';
import '../models/employee.dart';
import 'widgets/date_picker.dart';
import 'widgets/role_picker.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  const AddEditEmployeeScreen({super.key, this.employee});

  @override
  _AddEditEmployeeScreenState createState() => _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  DateTime? _joinDate;
  DateTime? _leaveDate;

  final List<String> _roles = ['Product Designer', 'Flutter Developer', 'QA Tester', 'Product Owner'];

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _roleController.text = widget.employee!.role;
      _joinDate = widget.employee!.joinDate;
      _leaveDate = widget.employee!.leaveDate;
    }
  }

  void _showRolePicker(BuildContext context) {
    RolePicker.show(
      context: context,
      roles: _roles,
      onRoleSelected: (role) {
        setState(() {
          _roleController.text = role;
        });
      },
    );
  }

  Future<void> _pickDate(BuildContext context, bool isJoinDate, {DateTime? joinDate}) async {
    DateTime initialDate = isJoinDate ? (_joinDate ?? DateTime.now()) : (_leaveDate ?? DateTime.now());

    DateTime? pickedDate = await DatePicker.show(
      context: context,
      initialDate: initialDate,
      isJoinDate: isJoinDate,
      joinDate: joinDate,
    );

    if (pickedDate != null) {
      setState(() {
        if (isJoinDate) {
          _joinDate = pickedDate;
        } else {
          _leaveDate = pickedDate == DateTime(0) ? null : pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? iconColor = Theme.of(context).colorScheme.primary;

    OutlineInputBorder customBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? 'Add Employee Details' : 'Edit Employee Details'),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF1DA1F2),
        actions: widget.employee != null
            ? [
                GestureDetector(
                  onTap: () => confirmDelete(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      'assets/delete_icon.png',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.delete, color: Colors.white),
                //   onPressed: () => _confirmDelete(),
                // ),
              ]
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Employee Name',
                        labelStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.person_outline, color: iconColor),
                        border: customBorder,
                        enabledBorder: customBorder,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                        ),
                      ),
                      validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                    ),
                    SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => _showRolePicker(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _roleController,
                          decoration: InputDecoration(
                            labelText: 'Select Role',
                            labelStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.work_outline, color: iconColor),
                            border: customBorder,
                            enabledBorder: customBorder,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                            ),
                            suffixIcon: Icon(Icons.arrow_drop_down, color: iconColor),
                          ),
                          validator: (value) => value!.isEmpty ? 'Please select a role' : null,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _pickDate(context, true),
                            icon: Image.asset(
                              'assets/calendar_icon.png',
                              width: 16,
                              height: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            label: Text(
                              _joinDate == null ? "Today" : DateFormat('d MMM yyyy').format(_joinDate!),
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.arrow_right_alt, color: iconColor),
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _pickDate(context, false, joinDate: _joinDate),
                            icon: Image.asset(
                              'assets/calendar_icon.png',
                              width: 16,
                              height: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            label: Text(
                              _leaveDate == null ? "No date" : DateFormat('d MMM yyyy').format(_leaveDate!),
                              style: TextStyle(color: Colors.black54),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
            SizedBox(width: 15),
            ElevatedButton(
              onPressed: () {
                _joinDate ??= DateTime.now();
                if (_formKey.currentState!.validate()) {
                  final employee = Employee(
                    id: widget.employee?.id,
                    name: _nameController.text,
                    role: _roleController.text,
                    joinDate: _joinDate!,
                    leaveDate: _leaveDate,
                  );
                  if (widget.employee == null) {
                    context.read<EmployeeBloc>().add(AddEmployee(employee));
                  } else {
                    context.read<EmployeeBloc>().add(UpdateEmployee(employee));
                  }
                  Navigator.popAndPushNamed(context, '/');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Employee"),
        content: Text("Are you sure you want to delete this employee?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (widget.employee != null) {
                context.read<EmployeeBloc>().add(DeleteEmployee(widget.employee!.id!));
                Navigator.popAndPushNamed(context, '/');
              }
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
