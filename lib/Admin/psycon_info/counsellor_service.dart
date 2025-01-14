import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/Admin/psycon_info/counsellor.dart';

class CounsellorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Counsellor> _counsellorRef;

  CounsellorService() {
    _counsellorRef =
        _firestore.collection('counsellors_info').withConverter<Counsellor>(
              fromFirestore: (snapshots, _) =>
                  Counsellor.fromJson(snapshots.data()!),
              toFirestore: (counsellor, _) => counsellor.toJson(),
            );
  }

  // Make the return type nullable
  Stream<QuerySnapshot<Counsellor>>? getCounsellors() {
    try {
      return _counsellorRef.orderBy('name').snapshots();
    } catch (e) {
      print('Error getting counselors: $e');
      return null;
    }
  }

  Future<void> addCounsellor(Counsellor counsellor) async {
    try {
      await _counsellorRef.add(counsellor);
    } catch (e) {
      print('Error adding counselor: $e');
      throw e; // Re-throw to handle in UI
    }
  }
}
