import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, 'maas_yonetimi.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db, version);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Eski sürümü yükseltmek için kullanılabilir, şu anki senaryoda kullanmıyoruz
      },
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees (
        id TEXT PRIMARY KEY,
        name TEXT,
        department TEXT,
        salary REAL,
        address TEXT,
        workYear INTEGER,
        imagePath TEXT,
        identityNumber TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE salaries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employeeId TEXT,
        amount REAL,
        date TEXT
      )
    ''');
  }

  Future<void> insertEmployee(Employee employee) async {
    final db = await instance.database;
    await db.insert('employees', employee.toMap());
  }

  Future<List<Employee>> getAllEmployees() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('employees');
    return List.generate(maps.length, (i) {
      return Employee.fromMap(maps[i]);
    });
  }

  Future<Employee?> getEmployeeById(String id) async {
    final db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Employee.fromMap(maps[0]);
    } else {
      return null;
    }
  }

  Future<void> insertSalary(Salary salary) async {
    final db = await instance.database;
    await db.insert('salaries', salary.toMap());
  }

  Future<List<Salary>> getAllSalaries() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('salaries');
    return List.generate(maps.length, (i) {
      return Salary.fromMap(maps[i]);
    });
  }

  Future<void> updateEmployee(Employee employee) async {
    final db = await instance.database;
    await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<List<Salary>> getEmployeeSalaries(String employeeId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'salaries',
      where: 'employeeId = ?',
      whereArgs: [employeeId],
    );

    return List.generate(maps.length, (i) {
      return Salary.fromMap(maps[i]);
    });
  }
}

class Employee {
  final String? id;
  final String name;
  final String department;
  final double salary;
  final String address;
  final int workYear;
  final String imagePath;
  final String? identityNumber;

  Employee({
    this.id,
    required this.name,
    required this.department,
    required this.salary,
    required this.address,
    required this.workYear,
    required this.imagePath,
    this.identityNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'salary': salary,
      'address': address,
      'workYear': workYear,
      'imagePath': imagePath,
      'identityNumber': identityNumber,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      department: map['department'],
      salary: map['salary'],
      address: map['address'],
      workYear: map['workYear'],
      imagePath: map['imagePath'],
      identityNumber: map['identityNumber'],
    );
  }
  double calculateSalaryWithBonus() {
    double baseSalary = this.salary;

    // Firmanın belirlediği zam oranları
    double tenureBonus = 0.0;

    if (this.workYear >= 10 && this.workYear < 20) {
      tenureBonus = baseSalary * 0.15;
    } else if (this.workYear >= 20) {
      tenureBonus = baseSalary * 0.25;
    }

    return baseSalary + tenureBonus;
  }
}

class Salary {
  final int? id;
  final String employeeId;
  final double amount;
  final String date;

  Salary({
    this.id,
    required this.employeeId,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'amount': amount,
      'date': date,
    };
  }

  factory Salary.fromMap(Map<String, dynamic> map) {
    return Salary(
      id: map['id'],
      employeeId: map['employeeId'],
      amount: map['amount'],
      date: map['date'],
    );
  }
}
