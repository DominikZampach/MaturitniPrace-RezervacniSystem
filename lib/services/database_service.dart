import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';

const USERS_COLLECTION_REF = "users";
const KADERNICI_COLLECTION_REF = "kadernici";
const REZERVACE_COLLECTION_REF = "rezervace";
const LOKACE_COLLECTION_REF = "lokace";
const HODNOCENI_COLLECTION_REF = "hodnoceni";
const KADERNICKEUKONY_COLLECTION_REF = "kadernicke_ukony";

class DatabaseService {
  final FirebaseAuth instance = FirebaseAuth.instance;
  final FirebaseApp app = FirebaseAuth.instance.app;
  late FirebaseFirestore firestore;

  DatabaseService() {
    firestore = FirebaseFirestore.instanceFor(app: app);
  }

  Future<Uzivatel> getUzivatel() async {
    //? Získání dokumentu s uživatelovým userUID
    final document = await firestore
        .collection(USERS_COLLECTION_REF)
        .doc(instance.currentUser!.uid)
        .get();

    //? Kontrola, pokud tento dokument existuje a případně vracíme uživatele
    if (document.exists) {
      final data = document.data() as Map<String, Object?>;
      Uzivatel uzivatel = Uzivatel.fromJson(instance.currentUser!.uid, data);
      return uzivatel;
    }

    //? Tady toto se provede, pokud se nenalezne User v databázi, pro teď se vráti dummy data
    print('Document doesn\'t exist!');
    return Uzivatel(
      userUID: "123456789",
      jmeno: "jmeno",
      prijmeni: "prijmeni",
      email: "email@email.com",
      telefon: "000000000",
      povoleneNotifikace: false,
      jeMuz: false,
      oblibeniKadernici: [],
    );

    /* Kód využitelný třeba pro write!
    dynamic user = firestore
        .collection(USERS_COLLECTION_REF)
        .doc(instance.currentUser!.uid)
        .withConverter(
          fromFirestore: (snapshot, _) => {
            if (snapshot.data() != null){
              return Uzivatel.fromJson(instance.currentUser!.uid, snapshot.data())
            }
          },
          toFirestore: (user, _) => {},
        );
    */
  }

  Future<Kadernik> getKadernik(String uid) async {
    //TODO
    return Kadernik();
  }

  Future<KadernickyUkon> getKadernickyUkon(String uid) async {
    //TODO
    return KadernickyUkon(
      nazev: "",
      delkaMinuty: 0,
      popis: "",
      odkazyFotografiiPrikladu: [],
    );
  }
}
