import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('https://partially-magical-cougar.ngrok-free.app');

class CoRegisterPage extends StatelessWidget {
  final String userId;  // User ID ที่จะใช้ในการลงทะเบียน
  final String courseId;  // Course ID ที่จะใช้ในการลงทะเบียน

  CoRegisterPage({required this.userId, required this.courseId});

  Future<void> registerForCourse() async {
    try {
      // เพิ่มจำนวน currentParticipants ใน course ที่มี courseId
      final course = await pb.collection('courses').getOne(courseId);
      int currentParticipants = course.data['currentParticipants'] ?? 0;
      currentParticipants += 1;

      final updatedData = {
        "currentParticipants": currentParticipants,
      };

      await pb.collection('courses').update(courseId, body: updatedData);
      print('Registration successful');
    } catch (e) {
      print('Failed to register: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register for Course'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            registerForCourse();
            Navigator.pop(context); // กลับไปยังหน้าก่อนหน้า
          },
          child: const Text('ลงทะเบียน'),
        ),
      ),
    );
  }
}
