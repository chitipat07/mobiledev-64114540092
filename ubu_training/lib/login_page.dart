import 'package:flutter/material.dart';
import 'package:ubu_training/register_page.dart';
import 'auth_service.dart'; // ไฟล์ที่มีฟังก์ชัน login
import 'home.dart'; // ไฟล์ HomePage ที่จะแสดงหลังจากล็อกอินสำเร็จ

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // เรียกใช้ฟังก์ชัน login จาก auth_service.dart
                try {
                  final user = await login(
                    _emailController.text,
                    _passwordController.text,
                  );

                  // แสดงข้อความเมื่อเข้าสู่ระบบสำเร็จ
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login successful')),
                  );

                  // นำผู้ใช้ไปยังหน้า HomePage และส่ง username
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(username: user.username),
                    ),
                  );
                } catch (e) {
                  // แสดงข้อความเมื่อเข้าสู่ระบบไม่สำเร็จ
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed: $e')),
                  );
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // นำไปยังหน้า RegisterPage เมื่อผู้ใช้กดปุ่มสมัครสมาชิก
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text('Don\'t have an account? Register here'),
            ),
          ],
        ),
      ),
    );
  }
}
