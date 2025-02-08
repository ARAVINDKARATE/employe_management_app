import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/employee_bloc.dart';
import 'data/employee_repository.dart';
import 'screens/employee_list_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => EmployeeBloc(repository: EmployeeRepository())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Management',
      theme: ThemeData(
        primaryColor: Color(0xFF1DA1F2),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1DA1F2),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1DA1F2),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1DA1F2),
            foregroundColor: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF1DA1F2),
          secondary: Color(0xFFEDF8FF),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => EmployeeBloc(repository: EmployeeRepository()),
        child: EmployeeListScreen(),
      ),
    );
  }
}
