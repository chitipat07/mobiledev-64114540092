import 'package:flutter/material.dart';
import 'package:ubu_training/Co_register.dart'; // หน้าที่จะไปหลังจากลงทะเบียน

class CourseDetailPage extends StatelessWidget {
  final String courseTitle;
  final String courseDescription;
  final String date;
  final String applyDate;
  final String teacher;
  final int maxParticipants;
  final int currentParticipants;
  final String location;
  final String additionalInfo;
  final String certificate;

  final String userId; // เพิ่มตัวแปร userId เพื่อส่งไปที่หน้าลงทะเบียน
  final String courseId; // เพิ่มตัวแปร courseId เพื่อส่งไปที่หน้าลงทะเบียน

  const CourseDetailPage({
    Key? key,
    required this.courseTitle,
    required this.courseDescription,
    required this.date,
    required this.applyDate,
    required this.teacher,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.location,
    required this.additionalInfo,
    required this.certificate,
    required this.userId, // เพิ่มตัวแปรที่จำเป็นในการลงทะเบียน
    required this.courseId, // เพิ่มตัวแปรที่จำเป็นในการลงทะเบียน
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title section
              Text(
                courseTitle,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Course Description
              Text(
                courseDescription,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 16),

              // Date information
              _buildDetailSection(
                icon: Icons.calendar_today,
                title: "วันที่จัด",
                content: date,
              ),
              _buildDetailSection(
                icon: Icons.access_time,
                title: "เปิดรับสมัครถึงวันที่",
                content: applyDate,
              ),
              const SizedBox(height: 16),

              // Teacher and participant info
              _buildDetailSection(
                icon: Icons.person,
                title: "วิทยากร",
                content: teacher,
              ),
              _buildDetailSection(
                icon: Icons.group,
                title: "จำนวนรับ",
                content: "$maxParticipants คน",
              ),
              _buildDetailSection(
                icon: Icons.people,
                title: "จำนวนคนสมัครแล้ว",
                content: "$currentParticipants คน",
              ),
              const SizedBox(height: 16),

              // Location and additional info
              _buildDetailSection(
                icon: Icons.location_on,
                title: "สถานที่อบรม",
                content: location,
              ),
              _buildDetailSection(
                icon: Icons.info,
                title: "ข้อมูลเพิ่มเติม",
                content: additionalInfo,
              ),
              const SizedBox(height: 16),

              // Certificate
              _buildDetailSection(
                icon: Icons.card_membership,
                title: "การออกใบประกาศนียบัตร",
                content: certificate,
              ),

              const SizedBox(height: 20),

              // Register button (ไม่ต้องเช็ค isUser)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // นำไปยังหน้า CoRegisterPage พร้อมส่งค่า userId และ courseId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoRegisterPage(
                          userId: userId, // ส่งค่า userId ไปที่หน้า CoRegisterPage
                          courseId: courseId, // ส่งค่า courseId ไปที่หน้า CoRegisterPage
                        ),
                      ),
                    );
                  },
                  child: Text('ลงทะเบียน'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection({required IconData icon, required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  content,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
