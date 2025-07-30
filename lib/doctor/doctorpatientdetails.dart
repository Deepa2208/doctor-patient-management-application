import 'package:flutter/material.dart';

class DoctorPatientDetails extends StatelessWidget {
  final List<Map<String, dynamic>> patients = [
    {"id": "PT-2024-0127", "name": "Sarah Thompson"},
    {"id": "PT-2024-0128", "name": "John Davis"},
    {"id": "PT-2024-0129", "name": "Emma Wilson"},
  ];

  void _navigateToPatientPage(BuildContext context, String name, String id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => PatientDetailsPage(patientName: name, patientId: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Doctor's Dashboard",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Patients",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap:
                        () => _navigateToPatientPage(
                          context,
                          patients[index]["name"],
                          patients[index]["id"],
                        ),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person, color: Colors.grey, size: 40),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patients[index]["name"],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "ID: ${patients[index]["id"]}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientDetailsPage extends StatelessWidget {
  final String patientName;
  final String patientId;

  PatientDetailsPage({required this.patientName, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(patientName, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Details for $patientName (ID: $patientId)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
