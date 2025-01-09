import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/Admin/models/advertisement.dart';

class AdvertisementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Advertisement> _advertisementRef;

  AdvertisementService() {
    _advertisementRef =
        _firestore.collection('advertisements').withConverter<Advertisement>(
            fromFirestore: (snapshots, _) => Advertisement.fromJson(
                  snapshots.data()!,
                ),
            toFirestore: (advertisement, _) => advertisement.toJson());
  }

  Stream<QuerySnapshot<Advertisement>> getAdvertisements() {
    return FirebaseFirestore.instance
        .collection('advertisements')
        .orderBy('createdOn', descending: true)
        .withConverter<Advertisement>(
          fromFirestore: (snapshot, _) =>
              Advertisement.fromJson(snapshot.data()!),
          toFirestore: (advertisement, _) => advertisement.toJson(),
        )
        .snapshots();
  }

  void addAdvertisement(Advertisement advertisement) async {
    _advertisementRef.add(advertisement);
  }
}
