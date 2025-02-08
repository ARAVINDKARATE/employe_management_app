part of 'employee_bloc.dart';

abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;
  EmployeeLoaded(this.employees);
}

class EmployeeError extends EmployeeState {
  final String message;
  EmployeeError(this.message);
}
