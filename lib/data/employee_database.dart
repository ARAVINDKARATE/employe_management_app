import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/employee.dart';

class EmployeeDatabase {
  static final EmployeeDatabase instance = EmployeeDatabase._init();
  static Database? _database;

  EmployeeDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('employees.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);
      return await openDatabase(path, version: 1, onCreate: _createDB);
    } catch (e) {
      log('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _createDB(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE employees (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          role TEXT,
          joinDate TEXT,
          leaveDate TEXT
        )
      ''');
    } catch (e) {
      log('Error creating table: $e');
    }
  }

  Future<int?> insertEmployee(Employee employee) async {
    try {
      final db = await instance.database;
      return await db.insert('employees', employee.toMap());
    } catch (e) {
      log('Error inserting employee: $e');
      return null;
    }
  }

  Future<List<Employee>> getAllEmployees() async {
    try {
      final db = await instance.database;
      final maps = await db.query('employees');
      return maps.map((map) => Employee.fromMap(map)).toList();
    } catch (e) {
      log('Error fetching employees: $e');
      return [];
    }
  }

  Future<int?> updateEmployee(Employee employee) async {
    try {
      final db = await instance.database;
      return await db.update(
        'employees',
        employee.toMap(),
        where: 'id = ?',
        whereArgs: [employee.id],
      );
    } catch (e) {
      log('Error updating employee: $e');
      return null;
    }
  }

  Future<int?> deleteEmployee(int id) async {
    try {
      final db = await instance.database;
      return await db.delete(
        'employees',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      log('Error deleting employee: $e');
      return null;
    }
  }

  Future<void> close() async {
    try {
      final db = await instance.database;
      await db.close();
    } catch (e) {
      log('Error closing database: $e');
    }
  }
}
