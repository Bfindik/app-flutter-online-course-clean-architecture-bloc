import 'package:flutter/material.dart';
import 'package:online_course/core/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CourseSelectionPage extends StatefulWidget {
  @override
  _CourseSelectionPageState createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  late DatabaseHelper _databaseHelper;
  late List<Map<String, dynamic>> _users;
  late String _selectedUser = '';
  late String _selectedPaymentMethod = '';
  late TextEditingController _ibanController;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper.instance;
    _loadUsers();
    _ibanController = TextEditingController();
  }

  Future<void> _loadUsers() async {
    final db = await _databaseHelper.database;
    final users = await db.query('users');
    setState(() {
      _users = users;
    });
  }

  Future<void> _makePayment() async {
    // Ödeme yapılacak kursu ve tarihi kaydetmek için veritabanına kayıt oluşturun
    final db = await _databaseHelper.database;
    final courseId = 1; // Seçilen kursun ID'si
    final userId = _selectedUser; // Seçilen kullanıcının ID'si
    final paymentMethod = _selectedPaymentMethod;
    final paymentDate = DateTime.now().toString();
    await db.insert('payments', {
      'userId': userId,
      'courseId': courseId,
      'paymentMethod': paymentMethod,
      'paymentDate': paymentDate,
    });

    // Ödeme yapıldıktan sonra sayfayı yeniden yükleyin veya başka bir işlem yapın
    // Örneğin, bir teşekkür mesajı gösterebilirsiniz.
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
            DropdownButtonFormField<String>(
              value: _selectedUser,
              hint: Text('Kullanıcı Seçin'),
              items: _users.map((user) {
                return DropdownMenuItem(
                  value: user['id'].toString(),
                  child: Text(user['fullName']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUser = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              hint: Text('Ödeme Yöntemi Seçin'),
              items: ['Nakit', 'Kredi Kartı'].map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
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
