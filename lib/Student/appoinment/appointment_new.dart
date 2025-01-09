import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student/pages/appoinment/appoinment_schedule.dart';

class NewAppointmentScreen extends StatefulWidget {
  const NewAppointmentScreen({super.key});

  @override
  State<NewAppointmentScreen> createState() => _NewAppointmentScreenState();
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController matricController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController issueDescriptionController =
      TextEditingController();

  String counselingType = 'Individual';
  String selectedIssue = 'Academic Stress';

  final List<String> issues = [
    'Academic Stress',
    'Family Issues',
    'Peer Pressure',
    'Personal Problems',
    'Others'
  ];

  final Color appPurple = const Color(0xFF9747FF);

  Future<void> _saveAppointmentToFirestore() async {
    try {
      // Fetch the currently logged-in user's UID
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw 'User is not logged in';
      }

      final appointmentData = {
        'name': nameController.text.trim(),
        'matricNumber': matricController.text.trim(),
        'email': emailController.text.trim(),
        'contactNumber': contactController.text.trim(),
        'issue': selectedIssue,
        'counselingType': counselingType,
        'description': issueDescriptionController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'userId': currentUser.uid, // Using currentUser.uid directly
      };

      // Save the appointment data to Firestore
      await FirebaseFirestore.instance
          .collection('appointment_info')
          .add(appointmentData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment saved successfully!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ScheduleAppointment(),
        ),
      );
    } catch (e) {
      // Display specific error messages for better debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving appointment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Appointment',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField(
                        controller: nameController,
                        labelText: 'Name',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required';
                          }
                          if (!RegExp(r"^[a-zA-Z\s]{2,}$").hasMatch(value)) {
                            return 'Enter a valid name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        controller: matricController,
                        labelText: 'Matric Number',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Matric Number is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        controller: emailController,
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                              .hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        controller: contactController,
                        labelText: 'Contact Number',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Contact Number is required';
                          }
                          if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildDropdown<String>(
                        value: selectedIssue,
                        items: issues,
                        labelText: 'Select Issue',
                        onChanged: (value) {
                          setState(() {
                            selectedIssue = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      const Text('Type of Counseling'),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              title: const Text('Individual'),
                              value: 'Individual',
                              groupValue: counselingType,
                              onChanged: (value) {
                                setState(() {
                                  counselingType = value.toString();
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              title: const Text('Group'),
                              value: 'Group',
                              groupValue: counselingType,
                              onChanged: (value) {
                                setState(() {
                                  counselingType = value.toString();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      _buildInputField(
                        controller: issueDescriptionController,
                        labelText: 'Describe the Issue (Optional)',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveAppointmentToFirestore();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown<T>({
    required String value,
    required List<String> items,
    required String labelText,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
