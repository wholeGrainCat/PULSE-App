import 'package:flutter/material.dart';
import 'package:student/Admin/psycon_info/counsellor_page.dart';
import 'package:student/Admin/counselling_appointment/appointment_page.dart';
import 'package:student/Admin/counselling_appointment/appointment_barchart_repository.dart';
import 'package:student/Admin/counselling_appointment/appointment_barchart.dart';
import 'package:student/Admin/crisis_support/crisis_support_viewmodel.dart';
import 'package:student/Admin/self-help_tools/selfhelp_tools.dart';
import 'package:student/auth_service.dart';
import 'package:student/components/admin_bottom_navigation.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _DashboardState();
}

class _DashboardState extends State<AdminDashboard> {
  int _currentIndex = 2; // Default to "Home" tab
  Map<String, int> stats = {
    'Approved': 0,
    'Pending': 0,
    'Rejected': 0,
    'Total': 0
  };
  bool isLoading = true;
  String counsellor = "";
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    fetchAppointmentStats();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> fetchAppointmentStats() async {
    try {
      final userData = await _auth.getCurrentUserData();

      if (userData != null) {
        setState(() {
          counsellor = userData['name'] ?? 'N/A';
          isLoading = false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Admin profile not found.")),
          );
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch admin data: $e")),
        );
        setState(() {
          isLoading = false;
        });
      }
    }

    AppointmentBarChartRepository repository = AppointmentBarChartRepository();
    print("The counsellor is {$counsellor}");
    Map<String, dynamic> fetchedStats =
        await repository.getAppointmentStats(counsellor);

    setState(() {
      stats['Approved'] = fetchedStats['Approved'] ?? 0;
      stats['Pending'] = fetchedStats['Pending'] ?? 0;
      stats['Rejected'] = fetchedStats['Rejected'] ?? 0;
      stats['Total'] = fetchedStats['Total'] ?? 0;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Hi Admin",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // 2x2 Grid of Cards
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final titles = [
                        'Approved',
                        'Pending',
                        'Rejected',
                        'Total'
                      ];
                      final colors = [
                        const Color(0xFFA4E3E8),
                        const Color(0xFFAF96F5),
                        const Color(0xFFF0F0F0),
                        const Color(0xFFD9F65C),
                      ];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AdminAppointmentPage(),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: colors[index],
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      titles[index],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const Icon(Icons.arrow_forward_ios_rounded,
                                        size: 16),
                                  ],
                                ),
                                const Spacer(),
                                // Display dynamic numbers from stats
                                Text(
                                  stats[titles[index]].toString(),
                                  style: const TextStyle(
                                      fontSize: 64,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Appointment Statistics',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 350,
                    child: AppointmentBarChart(),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVerticalCard(context, 'Manage UNIMAS Resources',
                          Colors.grey[100], const AdminCounsellorPage()),
                      _buildVerticalCard(context, 'Manage Crisis Support',
                          Colors.grey[100], const CrisisSupport()),
                      _buildVerticalCard(context, 'Manage Self-Help Tools',
                          Colors.grey[100], const SelfhelpToolsPage()),
                    ],
                  ),
                ],
              ),
            ),
      bottomNavigationBar: AdminBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Navigate based on the tab index
          switch (index) {
            case 0:
              // Navigate to Resources page
              Navigator.pushNamed(context, '/adminresource');
              break;
            case 1:
              // Navigate to Appointment page
              Navigator.pushNamed(context, '/adminappointment');
              break;
            case 2:
              // Navigate to Chat page
              Navigator.pushNamed(
                  context, '/admindashboard'); // Use named route for chat
              break;
            case 3:
              // Navigate to Profile page
              Navigator.pushNamed(context, '/adminchat');
              break;
            case 4:
              // Navigate to Profile page
              Navigator.pushNamed(context, '/adminprofile');
              break;
            default:
              break;
          }
        },
      ),
    );
  }

  Widget _buildVerticalCard(BuildContext context, String title, Color? color,
      Widget destinationPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      child: Card(
        elevation: 4,
        color: color,
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}
