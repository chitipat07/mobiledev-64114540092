import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('https://partially-magical-cougar.ngrok-free.app');

Future<void> deleteCourse(String courseId) async {
  try {
    await pb.collection('courses').delete(courseId);
    print('Course deleted successfully');
  } catch (e) {
    print('Failed to delete course: $e');
    throw Exception('Failed to delete course');
  }
}
