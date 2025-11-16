import 'package:flutter/material.dart';
import '../models/password_model.dart';

class PasswordForm extends StatefulWidget {
  final Password? password;
  final Function(Password) onSubmit;

  const PasswordForm({
    Key? key,
    this.password,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _websiteController = TextEditingController();
  final _noteController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    if (widget.password != null) {
      _titleController.text = widget.password!.title;
      _usernameController.text = widget.password!.username;
      _passwordController.text = widget.password!.password;
      _websiteController.text = widget.password!.website ?? '';
      _noteController.text = widget.password!.note ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username/Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter username/email';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _websiteController,
              decoration: InputDecoration(
                labelText: 'Website (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Note (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.password == null ? 'Add Password' : 'Update Password'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final password = Password(
        id: widget.password?.id,
        title: _titleController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        website: _websiteController.text.isEmpty ? null : _websiteController.text,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        createdAt: widget.password?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      widget.onSubmit(password);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _websiteController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}