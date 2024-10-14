import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String username; // ชื่อผู้ใช้ที่ถูกส่งมาจากการล็อกอิน

  const HomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'images/Ubu_logo.png', // ใส่ path ของไฟล์รูปภาพที่ต้องการแสดง
              height: 40, // กำหนดขนาดความสูงของรูปภาพ
            ),
            SizedBox(width: 10), // กำหนดระยะห่างระหว่างรูปภาพและข้อความ
            Expanded(
              child: Text(
                'UBU Training',
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ), // ข้อความ title
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 254, 254, 254),
        elevation: 10,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'ยินดีต้อนรับ, $username', // แสดงชื่อผู้ใช้ที่ล็อกอินสำเร็จ
                style: TextStyle(color: Colors.black),
              ),
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
              child: ListView(
                children: [
                  CourseCard(
                    title:
                        'วิศวกรรมยานยนต์ไฟฟ้าสมัยใหม่\n(Modern Electric Vehicle Engineering)',
                    imageUrl:
                        'images/jjj.jpg', // คุณสามารถแทนที่ URL ด้วย URL ของภาพจริง
                    date:
                        'วันที่อบรม: 25 ต.ค. 2567 - 27 ต.ค. 2567 (09:00 - 16:00)',
                    applyDate: 'เปิดรับสมัครถึงวันที่: 23 ต.ค. 2567',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
