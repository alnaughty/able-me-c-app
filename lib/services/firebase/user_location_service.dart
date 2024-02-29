import 'package:firebase_database/firebase_database.dart';

class UserLocationFirebaseService {
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('user-location');
  void readData() {
    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<String, dynamic> values = dataSnapshot.value as Map<String, dynamic>;
      values.forEach((key, values) {
        print("KEY : $key");
        print("Value : $values");
        // print('Key: $key');
        // print('Name: ${values['name']}');
        // print('Email: ${values['email']}');
        // print('Age: ${values['age']}');
      });
    });
  }

  void createRecord({required String name,required String avatar, required String coordinates}) {
    databaseReference.push().set({
      'name': 'John Doe',
      'email': 'johndoe@example.com',
      'age': 30,
    });
  }
}
