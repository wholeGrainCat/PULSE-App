import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulse/models/counsellor.dart';

class CounsellorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Counsellor> _counsellorRef;

  CounsellorService() {
    _counsellorRef = _firestore
      .collection('counsellors')
      .withConverter<Counsellor>(
        fromFirestore: (snapshots, _) => 
          Counsellor.fromJson(snapshots.data()!,), 
        toFirestore: (counsellor, _) => counsellor.toJson());
  }

  Stream<QuerySnapshot<Counsellor>> getCounsellors() {
      return _counsellorRef.orderBy('name').snapshots();
  }

  Future<void> addCounsellor(Counsellor counsellor) async {
    await _counsellorRef.add(counsellor);
  }
}