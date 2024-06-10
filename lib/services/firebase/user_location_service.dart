import 'package:able_me/helpers/geo_point_ext.dart';
import 'package:able_me/models/firebase_user_location_model.dart';
import 'package:able_me/models/geocoder/coordinates.dart';
import 'package:able_me/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geoflutterfire/geoflutterfire.dart' as geof;
import 'package:geolocator/geolocator.dart';
import 'package:timeago/timeago.dart' as timeago;
// import 'package:firebase_database/firebase_database.dart';

class UserLocationFirebaseService {
  static final _firestore = FirebaseFirestore.instance;
  // static final geof.Geoflutterfire _geo = geof.Geoflutterfire();
  static final CollectionReference ref = _firestore.collection('user-location');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final geof.GeoFireCollectionRef geoRef =
  //     _geo.collection(collectionRef: _firestore.collection('user-location'));
  /*
  firebaseDocId is uid from firebase Auth User data
   */

  Future<void> updateOrCreateUserLocation(
      User user, Coordinates location, UserModel currentUser) async {
    try {
      // final bool exists = await userExists(user.uid);
      final CollectionReference<Map<String, dynamic>> collectionRef =
          _firestore.collection('user-location');
      // if (!exists) {
      //   await collectionRef.doc(user.uid).set({});
      // }
      // await geoRef.setDoc(user.uid, {
      //   "avatar": currentUser.avatar ?? "",
      //   "id": currentUser.id,
      //   "user_type": currentUser.accountType,
      //   "name": currentUser.fullname,
      //   "last_active": FieldValue.serverTimestamp(),
      //   'location': GeoPoint(
      //     location.latitude,
      //     location.longitude,
      //   ),
      // });
      await collectionRef.doc(user.uid).set({
        "avatar": currentUser.avatar ?? "",
        "id": currentUser.id,
        "user_type": currentUser.accountType,
        "name": currentUser.fullname,
        "last_active": FieldValue.serverTimestamp(),
        'location': GeoPoint(
          location.latitude,
          location.longitude,
        ),
      });
    } on FirebaseException catch (e) {
      print('Ann error due to firebase occured $e');
    } catch (err) {
      print('Ann error occured $err');
    }
  }

  Future<bool> userExists(String firebaseDocId) async {
    try {
      return await _firestore
          .collection('user-location')
          .doc(firebaseDocId)
          .get()
          .then((value) => value.exists);
    } catch (err) {
      return false;
    }
  }

  //use this if user is USER
  Stream<List<FirebaseUserLocation>> driverLocationCollectionStream(
      UserModel user, Position p) {
    return _firestore
        .collection('user-location')
        .where('user_type', isEqualTo: 2)
        .where('id', isNotEqualTo: user.id)
        .snapshots(includeMetadataChanges: true)
        .map(
          (event) => event.docs
              .map((e) => FirebaseUserLocation.fromFirestore(e))
              .toList()
              .where((element) {
            final int diffInMill = DateTime.now()
                .difference(element.lastActive.toDate())
                .inMilliseconds;
            double differenceInHours = diffInMill / (1000 * 60 * 60);
            return element.coordinates.distanceIsWithin(p, kmRadius: 1);
          }).toList(),
        );
  }
}
