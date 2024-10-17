import 'package:pocketbase/pocketbase.dart';

// สร้าง PocketBase instance
final pb = PocketBase('https://partially-magical-cougar.ngrok-free.app');

// คลาส User เพื่อเก็บข้อมูลผู้ใช้
class User {
  final String username;
  final String email;
  final bool isAdmin;

  User({required this.username, required this.email, this.isAdmin = false});
}

Future<User> login(String email, String password) async {
  try {
    // ลองทำการล็อกอินสำหรับ user ปกติก่อน
    try {
      final authData = await pb.collection('users').authWithPassword(email, password);
      
      final user = User(
        username: authData.record?.data['username'] ?? 'Unknown',
        email: email,
        isAdmin: false, // กำหนดว่าไม่ใช่ admin
      );

      print('Login successful');
      print('Token: ${authData.token}');
      return user;
    } catch (e) {
      print('User login failed, trying admin login...');
      
      // ถ้าล็อกอินแบบ user ไม่ได้ ให้ลองล็อกอินแบบ admin
      final authData = await pb.admins.authWithPassword(email, password);
      final user = User(
        username: "Admin",
        email: email,
        isAdmin: true, // กำหนดว่าเป็น admin
      );

      print('Admin login successful');
      print('Token: ${authData.token}');
      return user;
    }
  } catch (e) {
    print('Login failed: $e');
    throw Exception('Login failed');
  }
}

Future<void> register(String username, String email, String password) async {
  try {
    // สร้างข้อมูลของผู้ใช้ใหม่
    final newUser = {
      'username': username,
      'email': email,
      'password': password,
      'passwordConfirm': password, // ยืนยันรหัสผ่าน
    };

    // ส่งคำขอไปยัง PocketBase เพื่อสร้างผู้ใช้ใหม่
    final response = await pb.collection('users').create(body: newUser);

    print('User registered successfully: ${response.data}');
  } catch (e) {
    print('Failed to Register: $e');
    throw Exception('Registration failed');
  }
}
