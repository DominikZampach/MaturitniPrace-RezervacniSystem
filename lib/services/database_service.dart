import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rezervacni_system_maturita/models/hodnoceni.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
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
    if (document.data() != null) {
      final data = document.data() as Map<String, Object?>;
      Uzivatel uzivatel = Uzivatel.fromJson(instance.currentUser!.uid, data);
      return uzivatel;
    }

    //? Tady toto se provede, pokud se nenalezne User v databázi, pro teď se vráti dummy data
    throw Exception('Document in database doesn\'t exist!');

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
    final document = await firestore
        .collection(KADERNICI_COLLECTION_REF)
        .doc(uid)
        .get();

    if (document.data() != null) {
      final data = document.data() as Map<String, Object?>;
      Kadernik kadernik = await Kadernik.fromJson(data);
      return kadernik;
    }

    throw Exception('Document in database doesn\'t exist!');
  }

  Future<KadernickyUkon> getKadernickyUkon(String uid) async {
    final document = await firestore
        .collection(KADERNICKEUKONY_COLLECTION_REF)
        .doc(uid)
        .get();

    if (document.data() != null) {
      final data = document.data() as Map<String, Object?>;
      print("Data z dokumentu $uid: $data");
      KadernickyUkon ukon = KadernickyUkon.fromJson(data);
      return ukon;
    }

    throw Exception('Document in database doesn\'t exist!');
  }

  Future<Lokace> getLokace(String uid) async {
    final document = await firestore
        .collection(LOKACE_COLLECTION_REF)
        .doc(uid)
        .get();

    if (document.data() != null) {
      final data = document.data() as Map<String, Object?>;
      Lokace lokace = Lokace.fromJson(data);
      return lokace;
    }

    throw Exception('Document in database doesn\'t exist!');
  }

  Future<Rezervace> getRezervace(String uid) async {
    final document = await firestore
        .collection(REZERVACE_COLLECTION_REF)
        .doc(uid)
        .get();

    if (document.data() != null) {
      final data = document.data() as Map<String, Object?>;
      Rezervace rezervace = await Rezervace.fromJson(data);
      return rezervace;
    }

    throw Exception('Document in database doesn\'t exist!');
  }

  Future<Hodnoceni> getHodnoceni(String uid) async {
    final document = await firestore
        .collection(HODNOCENI_COLLECTION_REF)
        .doc(uid)
        .get();

    if (document.data() != null) {
      final data = document.data() as Map<String, Object?>;
      Hodnoceni hodnoceni = Hodnoceni.fromJson(data);
      return hodnoceni;
    }

    throw Exception('Document in database doesn\'t exist!');
  }

  //? Zjištění, pokud existuje dokument s uid současného uživatele
  Future<bool> doesUzivatelDocumentExist() async {
    final document = await firestore
        .collection(USERS_COLLECTION_REF)
        .doc(instance.currentUser!.uid)
        .get();

    //? Potřeba kontrolovat takto, ne pomocí document.exists, protože pomocí .collection().doc()... se vždy něco vytvoří, ikdyž je to prázdné
    //print("Existuje dokument?: ${document.exists}");
    //print("Obsah dokumentu: ${document.data()}");
    if (document.data() == null) {
      return false;
    }
    return true;
  }

  //? Tvorba nového uzivatele
  Future<void> createNewUzivatel(
    String jmeno,
    String prijmeni,
    String telefon,
    bool povoleneNotifikace,
    bool jeMuz,
  ) async {
    //TODO
    Uzivatel novyUzivatel = Uzivatel(
      userUID: instance.currentUser!.uid,
      jmeno: jmeno,
      prijmeni: prijmeni,
      email: instance.currentUser!.email!,
      telefon: telefon,
      povoleneNotifikace: povoleneNotifikace,
      jeMuz: jeMuz,
      oblibeniKadernici: [],
    );
  }

  //? Tvorba nové rezervace

  //? Tvorba nového kadeřníka

  //? Tvorba nového úkonu

  //? Tvorba nové lokace

  //? Získání všech rezervací uživatele

  //? Získání všech budoucích rezervací
  Future<List<Rezervace>> getAllFutureRezervace() async {
    final DateTime now = DateTime.now();
    final Timestamp nowTimestamp = Timestamp.fromDate(now);

    final query = await firestore
        .collection(REZERVACE_COLLECTION_REF)
        .where('DatumCas_rezervace', isGreaterThan: nowTimestamp)
        .orderBy('DatumCas_rezervace', descending: false)
        .get();

    if (query.docs.isEmpty) {
      print("Nenalezeny žádné budoucí rezervace!");
      return [];
    }

    List<Rezervace> rezervaceList = [];

    for (var document in query.docs) {
      final data = document.data();

      Rezervace rezervace = await Rezervace.fromJson(data);
      rezervaceList.add(rezervace);
    }

    return rezervaceList;
  }

  //? Získání rezervací v určitý den

  //? Získání nejbližší rezervace uživatele
  Future<Rezervace?> getNearestRezervaceOfCurrentUser() async {
    // Funguje dobře
    final DateTime now = DateTime.now();
    final Timestamp nowTimestamp = Timestamp.fromDate(now);

    final query = await firestore
        .collection(REZERVACE_COLLECTION_REF)
        .where('id_uzivatele', isEqualTo: instance.currentUser!.uid)
        .where('DatumCas_rezervace', isGreaterThan: nowTimestamp)
        .orderBy('DatumCas_rezervace', descending: false)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      print("Nenalezena žádná budoucí rezervace!");
      return null; //? Vrátí null, pokud neexistuje žádná budoucí rezervace
    }

    final documentData = query.docs.first.data();
    //print("Načtená data o bodoucí rezervaci: ${documentData}");
    Rezervace nejblizsiRezervace = await Rezervace.fromJson(documentData);
    return nejblizsiRezervace;
  }

  //? Získání všech historických rezervací současného uživatele
  Future<List<Rezervace>> getAllPastRezervaceOfCurrentUser() async {
    // Funguje dobře
    final DateTime now = DateTime.now();
    final Timestamp nowTimestamp = Timestamp.fromDate(now);

    final query = await firestore
        .collection(REZERVACE_COLLECTION_REF)
        .where('id_uzivatele', isEqualTo: instance.currentUser!.uid)
        .where('DatumCas_rezervace', isLessThan: nowTimestamp)
        .orderBy('DatumCas_rezervace', descending: false)
        .get();

    if (query.docs.isEmpty) {
      print("Žádné historické rezervace!");
      return [];
    }

    List<Rezervace> rezervaceList = [];

    for (var document in query.docs) {
      final data = document.data();

      Rezervace rezervace = await Rezervace.fromJson(data);
      rezervaceList.add(rezervace);
    }

    return rezervaceList;
  }

  //? Získání všech budoucích rezervací uživatele
  Future<List<Rezervace>> getAllFutureRezervaceOfCurrentUser() async {
    // Funguje dobře
    final DateTime now = DateTime.now();
    final Timestamp nowTimestamp = Timestamp.fromDate(now);

    final query = await firestore
        .collection(REZERVACE_COLLECTION_REF)
        .where('id_uzivatele', isEqualTo: instance.currentUser!.uid)
        .where('DatumCas_rezervace', isGreaterThanOrEqualTo: nowTimestamp)
        .orderBy('DatumCas_rezervace', descending: false)
        .get();

    if (query.docs.isEmpty) {
      print("Žádné budoucí rezervace!");
      return [];
    }

    List<Rezervace> rezervaceList = [];

    for (var document in query.docs) {
      final data = document.data();

      Rezervace rezervace = await Rezervace.fromJson(data);
      rezervaceList.add(rezervace);
    }

    return rezervaceList;
  }

  //? Získání všech kadeřníků
  Future<List<Kadernik>> getAllKadernici() async {
    final query = await firestore.collection(KADERNICI_COLLECTION_REF).get();

    if (query.docs.isEmpty) {
      print("Žádní kadeřníci v databázi!");
      return [];
    }

    List<Kadernik> kadernici = [];

    for (var document in query.docs) {
      final data = document.data();

      Kadernik kadernik = await Kadernik.fromJson(data);
      kadernici.add(kadernik);
    }

    return kadernici;
  }

  //? Získání oblíbených kadeřníků - možná nebude potřeba a budu filtrovat ty všechny co už mám

  //? Získání všech Kadeřnických úkonů
  Future<List<KadernickyUkon>> getAllKadernickeUkony() async {
    final query = await firestore
        .collection(KADERNICKEUKONY_COLLECTION_REF)
        .get();

    if (query.docs.isEmpty) {
      print("Žádné kadeřnické úkony v databázi!");
      return [];
    }

    List<KadernickyUkon> ukony = [];

    for (var document in query.docs) {
      final data = document.data();

      KadernickyUkon ukon = KadernickyUkon.fromJson(data);
      ukony.add(ukon);
    }

    return ukony;
  }
}
