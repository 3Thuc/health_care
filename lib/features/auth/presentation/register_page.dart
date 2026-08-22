import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'Họ tên')),
            SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 16),
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'Mật khẩu')),
            SizedBox(height: 24),
            ElevatedButton(onPressed: null, child: Text('Tạo tài khoản')),
          ],
        ),
      ),
    );
  }
}
