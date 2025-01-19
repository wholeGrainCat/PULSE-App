import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentBarChartRepository {
  final CollectionReference appointment =
      FirebaseFirestore.instance.collection('appointments');

  Future<Map<String, dynamic>> getAppointmentStats(String counsellor) async {
    try {
      // Filter appointments based on the current counsellor
      QuerySnapshot querySnapshot =
          await appointment.where('counsellor', isEqualTo: counsellor).get();

      int pendingCount = 0;
      int cancelledCount = 0;
      int approvedCount = 0;

      for (var doc in querySnapshot.docs) {
        String status = doc['status'];
        if (status == 'Pending') {
          pendingCount++;
        } else if (status == 'Rejected') {
          cancelledCount++;
        } else if (status == 'Approved') {
          approvedCount++;
        }
      }

      int total = pendingCount + cancelledCount + approvedCount;

      return {
        'Pending': pendingCount,
        'Rejected': cancelledCount,
        'Approved': approvedCount,
        'Total': total,
      };
    } catch (e) {
      print('Error fetching appointment stats: $e');
      return {};
    }
  }
}
