import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/employee_bloc.dart';
import '../data/employee_repository.dart';
import '../models/employee.dart';
import 'add_edit_employee_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeBloc(repository: EmployeeRepository())..add(LoadEmployees()),
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false, title: Text('Employee List')),
        body: BlocBuilder<EmployeeBloc, EmployeeState>(
          builder: (context, state) {
            if (state is EmployeeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is EmployeeLoaded) {
              final employees = state.employees;
              if (employees.isEmpty) {
                return _buildEmptyState();
              }

              // Categorizing employees based on end date
              final currentDate = DateTime.now();
              final currentEmployees = employees.where((e) => e.leaveDate == null || e.leaveDate!.isAfter(currentDate)).toList();
              final previousEmployees = employees.where((e) => e.leaveDate != null && e.leaveDate!.isBefore(currentDate)).toList();

              return ListView(
                children: [
                  if (currentEmployees.isNotEmpty) _buildEmployeeSection("Current Employees", currentEmployees),
                  if (previousEmployees.isNotEmpty) _buildEmployeeSection("Previous Employees", previousEmployees),
                ],
              );
            } else if (state is EmployeeError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEditEmployeeScreen()),
            ).then((result) {
              if (result == true) {
                context.read<EmployeeBloc>().add(LoadEmployees());
              }
            });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildEmployeeSection(String title, List<Employee> employees) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          color: Colors.blueGrey[100],
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];
            return _buildEmployeeTile(employee);
          },
        ),
      ],
    );
  }

  Widget _buildEmployeeTile(Employee employee) {
    final dateFormat = DateFormat('d MMM, yyyy');
    final startDate = dateFormat.format(employee.joinDate);
    final leaveDate = employee.leaveDate != null ? dateFormat.format(employee.leaveDate!) : "Present";

    return Dismissible(
      key: Key(employee.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Image.asset(
          'assets/delete_icon.png',
          width: 24,
          height: 24,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        confirmDelete(employee);
      },
      child: ListTile(
        title: Text(
          capitalizeEachWord(employee.name),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text("${employee.role}\nFrom $startDate - $leaveDate"),
        isThreeLine: true,
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditEmployeeScreen(employee: employee)),
          );
          if (result == true) {
            context.read<EmployeeBloc>().add(LoadEmployees());
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/no_employee_found.png', width: 200, height: 200),
          Text('No employee records found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String capitalizeEachWord(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return ''; // Handle empty words
      return word.characters.first.toUpperCase() + word.characters.skip(1).string;
    }).join(' ');
  }

  void confirmDelete(Employee employee) {
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
              context.read<EmployeeBloc>().add(DeleteEmployee(employee.id!));
              Navigator.popAndPushNamed(context, '/');
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
