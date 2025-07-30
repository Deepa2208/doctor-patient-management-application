import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'dart:typed_data';

class PatientDetailsScreen extends StatefulWidget {
  @override
  _PatientDetailsScreenState createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final List<Map<String, dynamic>> previousImages = [];
  final Map<String, bool> weeklyProgress = {
    "Sun": false,
    "Mon": false,
    "Tue": false,
    "Wed": false,
    "Thu": false,
    "Fri": false,
    "Sat": false,
  };

  final String bucketId = "67ded430003419eba777"; // Your Wound_images bucket ID
  late Storage _storage;

  @override
  void initState() {
    super.initState();
    Client client = Client();
    client
        .setEndpoint('http://localhost/v1') // Your Appwrite endpoint
        .setProject('67ded3d9003dccc1a1e6'); // Your Appwrite project ID
    _storage = Storage(client);
  }

  Future<void> _uploadImage(XFile pickedFile) async {
    try {
      Uint8List bytes = await pickedFile.readAsBytes();
      String fileName = pickedFile.name;

      final response = await _storage.createFile(
        bucketId: bucketId,
        fileId: ID.unique(),
        file: InputFile.fromBytes(bytes: bytes, filename: fileName),
      );

      setState(() {
        previousImages.add({
          "imageId": response.$id,
          "image": fileName,
          "description": "Image uploaded on ${DateTime.now()}",
        });

        String today =
            [
              "Sun",
              "Mon",
              "Tue",
              "Wed",
              "Thu",
              "Fri",
              "Sat",
            ][DateTime.now().weekday % 7];
        weeklyProgress[today] = true;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Image uploaded successfully")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error uploading image: $e")));
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      await _uploadImage(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daily Progress",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  weeklyProgress.keys.map((day) {
                    return Column(
                      children: [
                        Text(day, style: TextStyle(fontSize: 16)),
                        Icon(
                          weeklyProgress[day]!
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color:
                              weeklyProgress[day]! ? Colors.green : Colors.grey,
                        ),
                      ],
                    );
                  }).toList(),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.camera_alt),
                label: Text("Take New Photo"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Previous Images",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            previousImages.isEmpty
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("No previous images available."),
                  ),
                )
                : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: previousImages.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: MemoryImage(
                                    Uint8List.fromList(
                                      previousImages[index]['image'],
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              previousImages[index]["description"],
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
