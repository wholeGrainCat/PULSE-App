import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student/Admin/counselling_appointment/appointment.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current counselor's name
  Future<String?> getCurrentCounselorName() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot counselorDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('counsellors')
          .doc('profile')
          .get();

      if (counselorDoc.exists) {
        return counselorDoc.get('name') as String;
      }
    }
    return null;
  }

  // Get appointments by status and counselor
  Stream<List<Appointment>> getAppointmentsByStatus(String status,
      {String? counselorName}) {
    var query = _firestore
        .collection('scheduled_appointments')
        .where('status', isEqualTo: status);

    if (counselorName != null) {
      query = query.where('counselor', isEqualTo: counselorName);
    }

    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Appointment> appointments = [];
      for (var doc in snapshot.docs) {
        String userName = await getUserName(doc.data()['userId'] ?? '');
        appointments.add(Appointment(
          id: doc.id,
          name: userName,
          date: doc.data()['date'] ?? '',
          time: doc.data()['time'] ?? '',
          location: doc.data()['location'] ?? '',
          counselor: doc.data()['counselor'] ?? '',
          status: doc.data()['status'] ?? '',
          createdAt: doc.data()['createdAt'] ?? Timestamp.now(),
        ));
      }
      return appointments;
    });
  }

  Future<String> getUserName(String userId) async {
    if (userId.isEmpty) return 'Unknown User';

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['name'] ?? 'Unknown User';
      }
      return 'Unknown User';
    } catch (e) {
      print('Error fetching user name: $e');
      return 'Unknown User';
    }
  }

  // Update appointment status
  Future<void> updateAppointmentStatus(
      String appointmentId, String status) async {
    try {
      await _firestore
          .collection('scheduled_appointments')
          .doc(appointmentId)
          .update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print(
          'Appointment status updated successfully: $appointmentId to $status');
    } catch (e) {
      print('Error updating appointment status: $e');
      throw Exception('Failed to update appointment status: $e');
    }
  }

  // Update appointment details
  Future<void> updateAppointment(
      String appointmentId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore
          .collection('scheduled_appointments')
          .doc(appointmentId)
          .update(updates);
      print('Appointment updated successfully: $appointmentId');
    } catch (e) {
      print('Error updating appointment: $e');
      throw Exception('Failed to update appointment: $e');
    }
  }
}
