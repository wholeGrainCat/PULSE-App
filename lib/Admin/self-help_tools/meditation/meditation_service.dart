import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/Admin/self-help_tools/meditation/meditation.dart';

class MeditationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Meditation> _meditationRef;

  MeditationService() {
    _meditationRef =
        _firestore.collection('meditations').withConverter<Meditation>(
            fromFirestore: (snapshots, _) => Meditation.fromJson(
                  snapshots.data()!,
                ),
            toFirestore: (meditation, _) => meditation.toJson());
  }

  Stream<QuerySnapshot<Meditation>> getMeditations() {
    return FirebaseFirestore.instance
        .collection('meditations')
        .orderBy('createdOn', descending: true)
        .withConverter<Meditation>(
          fromFirestore: (snapshot, _) => Meditation.fromJson(snapshot.data()!),
          toFirestore: (meditation, _) => meditation.toJson(),
        )
        .snapshots();
  }

  Future<void> addMeditation(Meditation meditation) async {
    await _meditationRef.add(meditation);
  }
}
