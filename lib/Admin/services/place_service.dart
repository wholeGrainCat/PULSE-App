import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/Admin/models/place.dart';

class PlaceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Place> _placeRef;

  PlaceService() {
    _placeRef = _firestore.collection('places').withConverter<Place>(
        fromFirestore: (snapshots, _) => Place.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (place, _) => place.toJson());
  }

  Stream<QuerySnapshot<Place>> getPlaces() {
    return FirebaseFirestore.instance
        .collection('places')
        .orderBy('createdOn', descending: false)
        .withConverter<Place>(
          fromFirestore: (snapshot, _) => Place.fromJson(snapshot.data()!),
          toFirestore: (place, _) => place.toJson(),
        )
        .snapshots();
  }

  Future<void> addPlace(Place place) async {
    await _placeRef.add(place);
  }
}
