import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ubu_training/home_admin.dart';

class EditCoursePage extends StatefulWidget {
  final RecordModel course;

  EditCoursePage({required this.course});

  @override
  _EditCoursePageState createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  final TextEditingController courseCodeController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController courseTimeController = TextEditingController();
  bool courseStatus = false;
  final TextEditingController maxParticipantsController = TextEditingController();
  final TextEditingController currentParticipantsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController additionalInfoController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController courseDateController = TextEditingController();
  DateTime? registrationOpenDate;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    // ตั้งค่า Controller ด้วยข้อมูลของ course ที่ส่งมา
    courseCodeController.text = widget.course.getString('courseCode');
    courseNameController.text = widget.course.getString('courseName');
    courseTimeController.text = widget.course.getString('courseTime');
    courseStatus = widget.course.getString('courseStatus') == 'true';
    maxParticipantsController.text = widget.course.getString('maxParticipants');
    currentParticipantsController.text = widget.course.getString('currentParticipants');
    locationController.text = widget.course.getString('location');
    additionalInfoController.text = widget.course.getString('additionalInfo');
    descriptionController.text = widget.course.getString('description');
    courseDateController.text = widget.course.getString('courseDate');
    registrationOpenDate = DateTime.tryParse(widget.course.getString('registrationOpenDate'));
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

  Future<void> updateCourse() async {
    try {
      // Prepare course data for update
      final courseData = {
        "courseCode": courseCodeController.text,
        "courseName": courseNameController.text,
        "courseTime": courseTimeController.text,
        "courseStatus": courseStatus.toString(),
        "maxParticipants": int.tryParse(maxParticipantsController.text) ?? 0,
        "currentParticipants": int.tryParse(currentParticipantsController.text) ?? 0,
        "location": locationController.text,
        "additionalInfo": additionalInfoController.text,
        "description": descriptionController.text,
        "courseDate": courseDateController.text,
        "registrationOpenDate": registrationOpenDate?.toIso8601String(),
      };

      List<http.MultipartFile> files = [];
      if (selectedImage != null) {
        final multipartFile = await http.MultipartFile.fromPath(
          'image',
          selectedImage!.path,
          filename: "course_image.jpg",
        );
        files.add(multipartFile);
      }

      await pb.collection('courses').update(widget.course.id, body: courseData, files: files);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Course updated successfully!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update course: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
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
              buildTextField("Current Participants", currentParticipantsController, inputType: TextInputType.number),
              buildTextField("Location", locationController),
              buildTextField("Additional Info", additionalInfoController),
              buildTextField("Description", descriptionController),
              buildTextField("Course Date", courseDateController),
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
                onPressed: updateCourse,
                child: const Text("Update Course"),
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
