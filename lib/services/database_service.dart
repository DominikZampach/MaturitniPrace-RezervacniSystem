import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

const USERS_COLLECTION_REF = "users";
const KADERNICI_COLLECTION_REF = "kadernici";
const REZERVACE_COLLECTION_REF = "rezervace";
const LOKACE_COLLECTION_REF = "lokace";
const HODNOCENI_COLLECTION_REF = "hodnoceni";
const KADERNICKEUKONY_COLLECTION_REF = "kadernicke_ukony";

class DatabaseService {
  final FirebaseApp app = FirebaseAuth.instance.app;
  late FirebaseFirestore firestore;

  DatabaseService() {
    firestore = FirebaseFirestore.instanceFor(app: app);
  }

  Future<void> getUser(String userUID) async {
    dynamic user = firestore
        .collection(USERS_COLLECTION_REF)
        .doc(userUID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            print('Document Data: ${documentSnapshot.data()}');
          } else {
            print('Document doesnt exists');
          }
        });

    /*    
    dynamic user2 = firestore
        .collection(USERS_COLLECTION_REF)
        .doc(userUID)
        .withConverter(
          fromFirestore: (snapshot, _) => print(""),
          toFirestore: (user, _) => {},
        );
    */
  }
}
