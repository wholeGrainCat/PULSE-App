import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/Admin/counselling_appointment/appointment.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Appointment> _appointmentRef;

  AppointmentService() {
    _appointmentRef =
        _firestore.collection('appointments').withConverter<Appointment>(
              fromFirestore: (snapshots, _) =>
                  Appointment.fromJson(snapshots.data()!),
              toFirestore: (appointment, _) => appointment.toJson(),
            );
  }

  Stream<QuerySnapshot<Appointment>> getAppointments() {
    return _appointmentRef
        .orderBy('appointmentDate', descending: true)
        .snapshots();
  }

  Stream<List<Appointment>> getAppointmentsByStatus(
      String status, String counsellor) {
    return _appointmentRef
        .where('status', isEqualTo: status)
        .where('counsellor', isEqualTo: counsellor)
        .orderBy('appointmentDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data().toJson();
        return Appointment.fromFirestore(data, doc.id);
      }).toList();
    });
  }

  void addAppointment(Appointment appointment) async {
    _appointmentRef.add(appointment);
  }
}
