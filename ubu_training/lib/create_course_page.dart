import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

final pb = PocketBase('https://chitipat07.pockethost.io');

class CreateCoursePage extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic>? courseData;

  CreateCoursePage({this.isEditing = false, this.courseData});

  @override
  _CreateCoursePageState createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  final TextEditingController courseCodeController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController courseTimeController = TextEditingController();
  bool courseStatus = false; // Default value for boolean
  final TextEditingController maxParticipantsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController additionalInfoController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController courseDateController = TextEditingController();
  final TextEditingController teacherController = TextEditingController(); // ฟิลด์สำหรับ teacher
  final TextEditingController certificateController = TextEditingController(); // ฟิลด์สำหรับ certificate
  DateTime? registrationOpenDate;
  File? selectedImage;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing && widget.courseData != null) {
      courseCodeController.text = widget.courseData!['courseCode'] ?? '';
      courseNameController.text = widget.courseData!['courseName'] ?? '';
      courseTimeController.text = widget.courseData!['courseTime'] ?? '';
      courseStatus = widget.courseData!['courseStatus'] ?? false;
      maxParticipantsController.text = widget.courseData!['maxParticipants'].toString();
      // currentParticipants จะถูกตั้งค่าเป็น 0 โดยอัตโนมัติเมื่อสร้างใหม่
      locationController.text = widget.courseData!['location'] ?? '';
      additionalInfoController.text = widget.courseData!['additionalInfo'] ?? '';
      descriptionController.text = widget.courseData!['description'] ?? '';
      courseDateController.text = widget.courseData!['courseDate'] ?? '';
      teacherController.text = widget.courseData!['teacher'] ?? ''; // กรอกข้อมูล teacher
      certificateController.text = widget.courseData!['certificate'] ?? ''; // กรอกข้อมูล certificate
      // registrationOpenDate ควรตั้งค่าจากข้อมูลถ้ามี
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> createCourse() async {
    try {
      // Prepare course data
      final courseData = {
        "courseCode": courseCodeController.text,
        "courseName": courseNameController.text,
        "courseTime": courseTimeController.text,
        "courseStatus": courseStatus,
        "maxParticipants": int.tryParse(maxParticipantsController.text) ?? 0,
        "currentParticipants": 0, // ตั้งค่าเริ่มต้นเป็น 0
        "location": locationController.text,
        "additionalInfo": additionalInfoController.text,
        "description": descriptionController.text,
        "courseDate": courseDateController.text,
        "registrationOpenDate": registrationOpenDate?.toIso8601String(),
        "teacher": teacherController.text, // เพิ่มข้อมูล teacher
        "certificate": certificateController.text, // เพิ่มข้อมูล certificate
      };

      // Prepare file upload
      List<http.MultipartFile> files = [];
      if (selectedImage != null) {
        final multipartFile = await http.MultipartFile.fromPath(
          'image',
          selectedImage!.path,
          filename: "course_image.jpg",
        );
        files.add(multipartFile);
      }

      // Create record with PocketBase
      if (widget.isEditing) {
        // Update existing course
        await pb.collection('courses').update(
          widget.courseData!['id'], // Use the course ID to update
          body: courseData,
          files: files.isNotEmpty ? files : [],
          headers: {
            "Authorization": "Bearer ${pb.authStore.token}",
          },
        );
      } else {
        // Create new course
        await pb.collection('courses').create(
          body: courseData,
          files: files.isNotEmpty ? files : [],
          headers: {
            "Authorization": "Bearer ${pb.authStore.token}",
          },
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course created/updated successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create/update course: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField("Course Code", courseCodeController),
              buildTextField("Course Name", courseNameController),
              buildTextField("Course Time", courseTimeController),
              SwitchListTile(
                title: const Text("Course Status"),
                value: courseStatus,
                onChanged: (bool value) {
                  setState(() {
                    courseStatus = value;
                  });
                },
              ),
              buildTextField("Max Participants", maxParticipantsController, inputType: TextInputType.number),
              // ลบ field สำหรับ currentParticipants ออก
              buildTextField("Location", locationController),
              buildTextField("Additional Info", additionalInfoController),
              buildTextField("Description", descriptionController),
              buildTextField("Course Date", courseDateController),
              buildTextField("Teacher", teacherController), // ฟิลด์สำหรับ teacher
              buildTextField("Certificate", certificateController), // ฟิลด์สำหรับ certificate
              ListTile(
                title: const Text("Registration Open Date"),
                subtitle: Text(registrationOpenDate != null
                    ? registrationOpenDate!.toLocal().toString().split(' ')[0]
                    : "Select Date"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      registrationOpenDate = pickedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text("Pick Image"),
              ),
              const SizedBox(height: 10),
              selectedImage != null
                  ? Image.file(
                      selectedImage!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : const Text("No image selected"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: createCourse,
                child: const Text("Create/Update Course"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
