import 'package:flutter/material.dart';
import 'package:student/Admin/psycon_info/counsellor_page.dart';
import 'package:student/Admin/counselling_appointment/appointment_page.dart';
import 'package:student/Admin/counselling_appointment/appointment_barchart_repository.dart';
import 'package:student/Admin/counselling_appointment/appointment_barchart.dart';
import 'package:student/Admin/crisis_support/crisis_support_viewmodel.dart';
import 'package:student/Admin/self-help_tools/selfhelp_tools.dart';
import 'package:student/components/admin_bottom_navigation.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _DashboardState();
}

class _DashboardState extends State<AdminDashboard> {
  int _currentIndex = 2; // Default to "Home" tab
  Map<String, int> stats = {
    'Upcoming': 0,
    'Completed': 0,
    'Cancelled': 0,
    'Total': 0
  };
  bool isLoading = true;

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
    AppointmentBarChartRepository repository = AppointmentBarChartRepository();
    Map<String, dynamic> fetchedStats = await repository.getAppointmentStats();

    setState(() {
      stats['Upcoming'] = fetchedStats['Upcoming'] ?? 0;
      stats['Completed'] = fetchedStats['Completed'] ?? 0;
      stats['Cancelled'] = fetchedStats['Cancelled'] ?? 0;
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
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
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
                  const SizedBox(height: 20),

                  // 2x2 Grid of Cards
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final titles = [
                        'Upcoming',
                        'Completed',
                        'Cancelled',
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
                            borderRadius: BorderRadius.circular(24),
                          ),
                          color: colors[index],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Appointment Statistics',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 300,
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
