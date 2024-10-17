import 'package:flutter/material.dart';
import 'login_page.dart'; // นำเข้า LoginPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UBU Training',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'images/Ubu_logo.png', // ตรวจสอบให้แน่ใจว่าโลโก้อยู่ในโฟลเดอร์นี้
              height: 40,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'UBU Training',
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 254, 254, 254),
        elevation: 10,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), // ไปยังหน้า LoginPage
              );
            },
            child: const Text(
              'สมัคร/Login',
              style: TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
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
                    imageUrl: 'images/jjj.jpg', // ใช้ Image.asset แทน
                    date: 'วันที่อบรม: 25 ต.ค. 2567 - 27 ต.ค. 2567 (09:00 - 16:00)',
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
            child: Image.asset( // ใช้ Image.asset เพื่อแสดงภาพที่อยู่ในโฟลเดอร์ local
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
