import '../models/employee.dart';
import 'employee_database.dart';

class EmployeeRepository {
  final EmployeeDatabase _database = EmployeeDatabase.instance;

  Future<int> insertEmployee(Employee employee) async {
    return await _database.insertEmployee(employee) ?? 0;
  }

  Future<List<Employee>> getAllEmployees() async {
    return await _database.getAllEmployees();
  }

  Future<int> updateEmployee(Employee employee) async {
    return await _database.updateEmployee(employee) ?? 0;
  }

  Future<int> deleteEmployee(int id) async {
    return await _database.deleteEmployee(id) ?? 0;
  }
}
