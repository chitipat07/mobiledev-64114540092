import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:ubu_training/course_detail.dart';
import 'package:ubu_training/login_page.dart';

final pb = PocketBase('https://chitipat07.pockethost.io');

Future<List<RecordModel>> fetchCourses() async {
  try {
    final courses = await pb.collection('courses').getFullList();
    return courses;
  } catch (e) {
    print("Error fetching courses: $e");
    return [];
  }
}

class HomeUser extends StatelessWidget {
  final String username;
  final String userId; // เพิ่ม userId

  HomeUser({required this.username, required this.userId}); // เพิ่มการรับ userId

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            pb.authStore.clear();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'images/Ubu_logo.png',
              height: 40,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'UBU Training',
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 254, 254, 254),
        elevation: 10,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  username,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: () async {
            await fetchCourses(); // คืนค่า fetchCourses() เพื่อให้ Refresh ทำงานได้
          },
          child: FutureBuilder<List<RecordModel>>(
            future: fetchCourses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('เกิดข้อผิดพลาดในการดึงข้อมูล'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('ไม่มีคอร์สที่เปิดอบรม'));
              }

              final courses = snapshot.data!;

              return ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return GestureDetector(
                    onTap: () {
                      String courseId = course.id; // รับค่า courseId

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailPage(
                            courseTitle: course.getString('courseName'),
                            courseDescription: course.getString('description'),
                            date: course.getString('courseDate'),
                            applyDate: 'เปิดรับสมัครถึงวันที่: ${course.getString('registrationOpenDate')}',
                            teacher: course.getString('teacher'),
                            maxParticipants: int.tryParse(course.data['maxParticipants'].toString()) ?? 0,
                            currentParticipants: int.tryParse(course.data['currentParticipants'].toString()) ?? 0,
                            location: course.getString('location'),
                            additionalInfo: course.getString('additionalInfo'),
                            certificate: course.getString('certificate'),
                            userId: userId, // ส่ง userId ไปที่ CourseDetailPage
                            courseId: courseId, // ส่ง courseId ไปที่ CourseDetailPage
                          ),
                        ),
                      );
                    },
                    child: CourseCard(
                      title: course.getString('courseName'),
                      imageUrl:
                          'https://partially-magical-cougar.ngrok-free.app/api/files/${course.collectionId}/${course.id}/${course.getString('image')}',
                      date: course.getString('courseDate'),
                      applyDate: 'เปิดรับสมัครถึงวันที่: ${course.getString('registrationOpenDate')}',
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

extension RecordModelExtensions on RecordModel {
  String getString(String fieldName) {
    return this.data[fieldName]?.toString() ?? 'Unknown';
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String date;
  final String applyDate;

  const CourseCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.applyDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  applyDate,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
