part of blocs.pins;

class PinRepository {
  final pinsCollection = FirebaseFirestore.instance.collection('pins');

  Future<void> addPin(Pin pin) {
    return pinsCollection.add(pin.toJson());
  }

  Future<void> deletePin(Pin pin) {
    return pinsCollection.doc(pin.id).delete();
  }

  Future<void> updatePin(Pin update) {
    return pinsCollection.doc(update.id).update(update.toJson());
  }

  Stream<List<Pin>> pins() {
    return pinsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Pin.fromJson(doc.data())).toList();
    });
  }
}
