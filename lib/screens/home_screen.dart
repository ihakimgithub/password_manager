import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/password_model.dart';
import '../widgets/password_form.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Password> _passwords = [];

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  Future<void> _loadPasswords() async {
    final passwords = await _databaseHelper.getPasswords();
    setState(() {
      _passwords = passwords;
    });
  }

  void _showPasswordForm([Password? password]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: PasswordForm(
              password: password,
              onSubmit: (newPassword) async {
                if (newPassword.id == null) {
                  await _databaseHelper.insertPassword(newPassword);
                } else {
                  await _databaseHelper.updatePassword(newPassword);
                }
                _loadPasswords();
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Password'),
        content: Text('Are you sure you want to delete this password?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _databaseHelper.deletePassword(id);
              _loadPasswords();
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showPasswordDetails(Password password) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(password.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Username: ${password.username}'),
              SizedBox(height: 8),
              Text('Password: ${password.password}'),
              if (password.website != null) ...[
                SizedBox(height: 8),
                Text('Website: ${password.website}'),
              ],
              if (password.note != null) ...[
                SizedBox(height: 8),
                Text('Note: ${password.note}'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Manager'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showPasswordForm(),
          ),
        ],
      ),
      body: _passwords.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No passwords yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to add your first password',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _passwords.length,
              itemBuilder: (context, index) {
                final password = _passwords[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Icon(Icons.lock, color: Colors.blue),
                    title: Text(
                      password.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(password.username),
                    onTap: () => _showPasswordDetails(password),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showPasswordForm(password),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteDialog(password.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}