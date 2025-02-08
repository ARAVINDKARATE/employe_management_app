import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/employee.dart';
import '../data/employee_repository.dart';
part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;

  EmployeeBloc({required this.repository}) : super(EmployeeInitial()) {
    on<LoadEmployees>((event, emit) async {
      emit(EmployeeLoading());
      try {
        final employees = await repository.getAllEmployees();
        emit(EmployeeLoaded(employees));
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    });

    on<AddEmployee>((event, emit) async {
      await repository.insertEmployee(event.employee);
      add(LoadEmployees());
    });

    on<UpdateEmployee>((event, emit) async {
      await repository.updateEmployee(event.employee);
      add(LoadEmployees());
    });

    on<DeleteEmployee>((event, emit) async {
      await repository.deleteEmployee(event.id);
      add(LoadEmployees());
    });
  }
}
