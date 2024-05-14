import 'package:flutter/material.dart';
import 'package:online_course/core/services/database_helper.dart';
import 'package:online_course/src/JSON/users.dart';
import 'package:online_course/src/features/course/domain/entities/course.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CourseSelectionPage extends StatefulWidget {
  final Course course;

  const CourseSelectionPage({Key? key, required this.course}) : super(key: key);
  @override
  _CourseSelectionPageState createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  late DatabaseHelper _databaseHelper;
  late List<Map<String, dynamic>> _users;
  late String _selectedUser = '';
  late String _selectedPaymentMethod = '';
  late TextEditingController _ibanController;
  int? selectedUserId;
  List<String> list = <String>['Nakit', 'Kredi Kartı'];

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper.instance;
    _loadUsers();
    _ibanController = TextEditingController();
  }

  Future<void> _loadUsers() async {
    final users = await _databaseHelper.getUsers();
    print(users);
    setState(() {
      _users = users;
      print(_users);
    });
  }

  Future<void> _makePayment() async {
    if (selectedUserId != null) {
      Users? user = await _databaseHelper.getUserById(selectedUserId!);
      if (user != null) {
        final db = await _databaseHelper.database;
        final courseId = 1;
        final userId = user.usrId;
        final paymentMethod = _selectedPaymentMethod;
        final paymentDate = DateTime.now().toString();
        await db.insert('payments', {
          'userId': userId,
          'courseId': courseId,
          'paymentMethod': paymentMethod,
          'paymentDate': paymentDate,
        });
        _databaseHelper.printPayments();
      } else {
        print('Error: User not found!');
      }
    } else {
      print('Error: User not selected!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kurs Seçimi ve Ödeme'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButton<int>(
                  hint: Text(
                    'Kayıt olacak kursiyeri seçin',
                    style: TextStyle(fontSize: 20),
                  ),
                  value: selectedUserId,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedUserId = newValue;
                    });
                  },
                  items: _users
                      .map<DropdownMenuItem<int>>((Map<String, dynamic> user) {
                    return DropdownMenuItem<int>(
                      value: user['usrId'],
                      child: Text(
                        user['fullName'],
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Ödeme Yöntemi:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: _selectedPaymentMethod,
              onChanged: (String? value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            if (_selectedPaymentMethod == 'Kredi Kartı') ...[
              SizedBox(height: 16.0),
              TextFormField(
                controller: _ibanController,
                decoration: InputDecoration(labelText: 'IBAN'),
              ),
            ],
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _makePayment,
              child: Text('Ödeme Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
