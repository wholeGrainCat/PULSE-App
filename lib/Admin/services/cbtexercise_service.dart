import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/Admin/models/cbtexercise.dart';

class CbtexerciseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Cbtexercise> _cbtexerciseRef;

  CbtexerciseService() {
    _cbtexerciseRef =
        _firestore.collection('cbtexercises').withConverter<Cbtexercise>(
              fromFirestore: (snapshots, _) =>
                  Cbtexercise.fromJson(snapshots.data()!),
              toFirestore: (cbtexercise, _) => cbtexercise.toJson(),
            );
  }

  Stream<QuerySnapshot<Cbtexercise>> getCbtexercises() {
    return _cbtexerciseRef.orderBy('number', descending: false).snapshots();
  }
}

class CbtVideoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<CbtVideo> _cbtvideoRef;

  CbtVideoService() {
    _cbtvideoRef = _firestore.collection('cbtvideos').withConverter<CbtVideo>(
          fromFirestore: (snapshot, _) => CbtVideo.fromJson(snapshot.data()!),
          toFirestore: (cbtvideo, _) => cbtvideo.toJson(),
        );
  }

  Stream<QuerySnapshot<CbtVideo>> getCbtVideos() {
    return _cbtvideoRef.snapshots();
  }
}
