import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulse/models/breathing.dart';

class BreathingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Breathing> _breathingRef;

  BreathingService() {
    _breathingRef = _firestore
      .collection('breaths')
      .withConverter<Breathing>(
        fromFirestore: (snapshots, _) => 
          Breathing.fromJson(snapshots.data()!,), 
        toFirestore: (breathing, _) => breathing.toJson());
  }


  Stream<QuerySnapshot<Breathing>> getBreaths() {
      return _breathingRef.orderBy('title').snapshots();
  }
}

class BreathingVideoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<BreathingVideo> _breathingvideoRef;

  BreathingVideoService() {
    _breathingvideoRef = _firestore
      .collection('breathingvideos')
      .withConverter<BreathingVideo>(
        fromFirestore: (snapshots, _) => 
          BreathingVideo.fromJson(snapshots.data()!,), 
        toFirestore: (breathingvideo, _) => breathingvideo.toJson());
  }


  Stream<QuerySnapshot<BreathingVideo>> getBreathingVideos() {
      return _breathingvideoRef.orderBy('title').snapshots();
  }
}