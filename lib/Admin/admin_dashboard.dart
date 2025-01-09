import 'package:flutter/material.dart';
import 'appointment_screen.dart';
import 'appointment_barchart_repository.dart';
import 'appointment_barchart.dart';
import 'crisis_support_viewmodel.dart';
import 'package:student/components/bottom_navigation.dart';

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
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Hi Admin",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),

                  // 2x2 Grid of Cards
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        Color(0xFFA4E3E8),
                        Color(0xFFAF96F5),
                        Color(0xFFF0F0F0),
                        Color(0xFFD9F65C),
                      ];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentScreen(),
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
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Icon(Icons.arrow_forward_ios_rounded,
                                        size: 16),
                                  ],
                                ),
                                Spacer(),
                                // Display dynamic numbers from stats
                                Text(
                                  stats[titles[index]].toString(),
                                  style: TextStyle(
                                      fontSize: 64,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Appointment Statistics',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 300,
                    child: AppointmentBarChart(),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVerticalCard(context, 'Manage UNIMAS Resources',
                          Colors.grey[100], ManageResourcesPage()),
                      _buildVerticalCard(context, 'Manage Crisis Support',
                          Colors.grey[100], CrisisSupport()),
                      _buildVerticalCard(context, 'Manage Self-Help Tools',
                          Colors.grey[100], ManageSelfHelpToolsPage()),
                    ],
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
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
        margin: EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder Pages, DELETE this class when compiling
class ManageResourcesPage extends StatelessWidget {
  const ManageResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage UNIMAS Resources'),
      ),
      body: Center(child: Text('Testing only. Manage Unimas Resources Page')),
    );
  }
}

// Placeholder Pages, DELETE this class when compiling
class ManageSelfHelpToolsPage extends StatelessWidget {
  const ManageSelfHelpToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Self-Help Tools'),
      ),
      body: Center(child: Text('Testing only. Manage Self-Help Tools Page')),
    );
  }
}
