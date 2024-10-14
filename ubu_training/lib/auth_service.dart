import 'package:pocketbase/pocketbase.dart';

// สร้าง PocketBase instance
final pb = PocketBase('http://127.0.0.1:8090/');

// คลาส User เพื่อเก็บข้อมูลผู้ใช้
class User {
  final String username;
  final String email;

  User({required this.username, required this.email});
}

Future<User> login(String email, String password) async {
  try {
    final authData =
        await pb.collection('users').authWithPassword(email, password);

    // ตรวจสอบ authData.record ว่าไม่เป็น null ก่อนดึงข้อมูล
    final user = User(
      username: authData.record?.data['username'] ??
          'Unknown', // ใช้ data ในการดึงข้อมูล username
      email: email,
    );

    print('Login successful');
    print('Token: ${authData.token}');

    return user; // ส่งคืนวัตถุ User
  } catch (e) {
    print('Login failed: $e');
    throw Exception('Login failed');
  }
}

extension on RecordModel? {
  getString(String s) {}
}
