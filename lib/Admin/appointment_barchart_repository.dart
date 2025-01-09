import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentBarChartRepository {
  final CollectionReference appointment =
      FirebaseFirestore.instance.collection('appointment');

  Future<Map<String, dynamic>> getAppointmentStats() async {
    try {
      QuerySnapshot querySnapshot = await appointment.get();

      int completedCount = 0;
      int cancelledCount = 0;
      int upcomingCount = 0;

      for (var doc in querySnapshot.docs) {
        String status = doc['Status'];
        if (status == 'Completed') {
          completedCount++;
        } else if (status == 'Cancelled') {
          cancelledCount++;
        } else if (status == 'Upcoming') {
          upcomingCount++;
        }
      }

      int total = completedCount + cancelledCount + upcomingCount;

      return {
        'Completed': completedCount,
        'Cancelled': cancelledCount,
        'Upcoming': upcomingCount,
        'Total': total,
      };
    } catch (e) {
      print('Error fetching appointment stats: $e');
      return {};
    }
  }
}
