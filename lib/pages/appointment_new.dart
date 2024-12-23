import 'package:flutter/material.dart';
import 'package:student/pages/appoinment_schedule.dart';

class NewAppointmentScreen extends StatefulWidget {
  const NewAppointmentScreen({super.key});

  @override
  State<NewAppointmentScreen> createState() => _NewAppointmentScreenState();
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController matricController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController issueDescriptionController =
      TextEditingController();

  String selectedCounselor = 'Pn Fauziah Bee binti Mohd Salleh';
  String counselingType = 'Individual';
  String selectedIssue = 'Academic Stress';

  // Dropdown options
  final List<String> counselors = [
    'Pn Fauziah Bee binti Mohd Salleh',
    'Pn Saptuyah Bt Barahim',
    'Pn Debra Adrian',
    'En. Lawrence Sengkuai Anak Henry ',
    'Cik Ummikhaira Sofea Bt Ja’afar',
  ];

  final List<String> issues = [
    'Academic Stress',
    'Family Issues',
    'Peer Pressure',
    'Personal Problems',
    'Others'
  ];

  final Color appPurple = const Color(0xFF9747FF);

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
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 16.0, bottom: 80.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    _buildInputField(
                      controller: nameController,
                      labelText: 'Name',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
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
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
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
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildDropdown<String>(
                      value: selectedCounselor,
                      items: counselors,
                      labelText: 'Choose Counselor',
                      onChanged: (value) {
                        setState(() {
                          selectedCounselor = value!;
                        });
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
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _showConfirmationDialog(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appPurple,
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
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
          borderSide: BorderSide(color: appPurple),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: appPurple, width: 2),
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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${nameController.text}'),
              Text('Matric Number: ${matricController.text}'),
              Text('Email: ${emailController.text}'),
              Text('Contact Number: ${contactController.text}'),
              Text('Counselor: $selectedCounselor'),
              Text('Issue: $selectedIssue'),
              Text('Counseling Type: $counselingType'),
              if (issueDescriptionController.text.isNotEmpty)
                Text('Description: ${issueDescriptionController.text}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ScheduleAppointment()),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
