import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:ubu_training/login_page.dart';
import 'create_course_page.dart'; // สร้างหน้าสำหรับสร้างคอร์ส
import 'package:ubu_training/course_detail_admin.dart';
import 'edit_course.dart'; // เพิ่มการนำเข้าไฟล์ EditCoursePage
import 'delete_course.dart'; // เพิ่มการนำเข้าไฟล์ DeleteCoursePage

final pb = PocketBase('https://chitipat07.pockethost.io');

class HomeAdmin extends StatefulWidget {
  final String username;

  HomeAdmin({required this.username});

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  List<RecordModel> courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses(); // ดึงข้อมูลเมื่อ Widget สร้างขึ้น
  }

  Future<void> fetchCourses() async {
    try {
      final fetchedCourses = await pb.collection('courses').getFullList();
      setState(() {
        courses = fetchedCourses;
      });
    } catch (e) {
      print("Error fetching courses: $e");
    }
  }

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
                      Icon(Icons.person, color: Colors.black), // ไอคอนผู้ใช้
                      const SizedBox(width: 5), // เพิ่มช่องว่างระหว่างไอคอนกับชื่อ
                      Text(
                        '${widget.username}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'คอร์สที่เปิดอบรม',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: RefreshIndicator(
                onRefresh: fetchCourses,
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return GestureDetector(
                      onTap: () {
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
                        onEditPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCoursePage(course: course),
                            ),
                          ).then((_) => fetchCourses()); // รีเฟรชเมื่อกลับมาจากหน้าแก้ไข
                        },
                        onDeletePressed: () {
                          // เรียกใช้การลบคอร์ส
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("ยืนยันการลบ"),
                                content: const Text("คุณแน่ใจหรือว่าต้องการลบคอร์สนี้?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // ปิด dialog
                                    },
                                    child: const Text("ยกเลิก"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await deleteCourse(course.id); // ฟังก์ชันลบคอร์ส
                                      Navigator.of(context).pop(); // ปิด dialog
                                      fetchCourses(); // รีเฟรชคอร์สหลังจากลบ
                                    },
                                    child: const Text("ลบ"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateCoursePage()),
          );
        },
        child: Icon(Icons.add), // ไอคอนสำหรับปุ่ม "สร้างคอร์ส"
        tooltip: 'Create Course',
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
  final VoidCallback onEditPressed; // Callback สำหรับปุ่มแก้ไข
  final VoidCallback onDeletePressed; // Callback สำหรับปุ่มลบ

  const CourseCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.applyDate,
    required this.onEditPressed, // รับค่า callback
    required this.onDeletePressed, // รับค่า callback สำหรับลบ
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
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.yellow,
                      onPressed: onEditPressed, // เรียกใช้ callback แก้ไข
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: onDeletePressed, // เรียกใช้ callback ลบ
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
