import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
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

    throw Exception('Document in database doesn\'t exist!');
  }

  Future<Uzivatel> getUserById(String userId) async {
    final document = await firestore
        .collection(USERS_COLLECTION_REF)
        .doc(userId)
        .get();

    if (document.data() != null) {
      final data = document.data() as Map<String, Object?>;
      Uzivatel uzivatel = Uzivatel.fromJson(userId, data);
      return uzivatel;
    }

    throw Exception('Document in database doesn\'t exist!');
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

  Future<bool> isUserAdmin() async {
    if ((instance.currentUser!.uid == Consts.ADMIN_UID) &&
        (instance.currentUser!.email == Consts.ADMIN_EMAIL)) {
      return true;
    }
    return false;
  }

  //? Uložení upraveného uživatele
  Future<void> updateUzivatel(Uzivatel uzivatel) async {
    //? Nevím jestli použít .update() nebo .set() - asi nakonecp použiju .set() pro jednoduchost, ikdyž to není nejoptimálnější
    try {
      await firestore
          .collection(USERS_COLLECTION_REF)
          .doc(uzivatel.userUID)
          .set(uzivatel.toJson());
    } catch (e) {
      print("Chyba při ukládání uživatele pomocí .set(): $e");
    }
  }

  //? Uložení upraveného Hodnocení
  Future<void> updateHodnoceni(Hodnoceni hodnoceni) async {
    try {
      await firestore
          .collection(HODNOCENI_COLLECTION_REF)
          .doc(hodnoceni.id)
          .set(hodnoceni.toJson());
    } catch (e) {
      print("Chyba při ukládání hodnocení pomocí .set(): $e");
    }
  }

  //? Uložení upraveného Kadeřníka
  Future<void> updateKadernik(Kadernik kadernik) async {
    try {
      await firestore
          .collection(KADERNICI_COLLECTION_REF)
          .doc(kadernik.id)
          .set(kadernik.toJson());
    } catch (e) {
      print("Chyba při ukládání kadeřníka pomocí .set(): $e");
    }
  }

  //? Uložení upravené Lokace
  Future<void> updateLokace(Lokace lokace) async {
    try {
      await firestore
          .collection(LOKACE_COLLECTION_REF)
          .doc(lokace.id)
          .set(lokace.toJson());
    } catch (e) {
      print("Chyba při ukládání lokace pomocí .set(): $e");
    }
  }

  //? Uložení upraveného Kadeřnického úkonu
  Future<void> updateUkon(KadernickyUkon ukon) async {
    try {
      await firestore
          .collection(KADERNICKEUKONY_COLLECTION_REF)
          .doc(ukon.id)
          .set(ukon.toJson());
    } catch (e) {
      print("Chyba při ukládání Úkonu pomocí .set: $e");
    }
  }

  //? Tvorba nového uzivatele
  Future<void> createNewUzivatel(
    String jmeno,
    String prijmeni,
    String telefon,
  ) async {
    DocumentReference newDocRef = firestore
        .collection(USERS_COLLECTION_REF)
        .doc(instance.currentUser!.uid);

    Uzivatel novyUzivatel = Uzivatel(
      userUID: instance.currentUser!.uid,
      jmeno: jmeno,
      prijmeni: prijmeni,
      email: instance.currentUser!.email!,
      telefon: telefon,
      oblibeniKadernici: [],
    );

    try {
      await newDocRef.set(novyUzivatel.toJson());
      print("Nový uživatel ${novyUzivatel.userUID} vytvořen.");
      ToastClass.showToastSnackbar(message: "Uživatel úspěšně vytvořen");
    } catch (e) {
      print("Chyba při tvorbě nové rezervace: $e");
    }
  }

  //? Tvorba nové rezervace
  Future<bool> createNewRezervace(Rezervace rezervace) async {
    DocumentReference newDocRef = firestore
        .collection(REZERVACE_COLLECTION_REF)
        .doc();
    String newId = newDocRef.id;

    rezervace.id = newId;

    Map<String, dynamic> json = rezervace.toJson();

    try {
      await newDocRef.set(json);
      print("Nová rezervace $newId vytvořena.");
      ToastClass.showToastSnackbar(message: "Rezervace úspěšně vytvořena");
      return true;
    } catch (e) {
      print("Chyba při tvorbě nové rezervace: $e");
      return false;
    }
  }

  //? Tvorba nového hodnocení
  Future<Hodnoceni?> createNewHodnoceni(Hodnoceni hodnoceni) async {
    DocumentReference newDocRef = firestore
        .collection(HODNOCENI_COLLECTION_REF)
        .doc();

    String newId = newDocRef.id;

    hodnoceni.id = newId;

    Map<String, dynamic> json = hodnoceni.toJson();

    try {
      await newDocRef.set(json);
      print("Nové hodnocení $newId vytvořena.");
      return hodnoceni;
    } catch (e) {
      print("Chyba při tvorbě nového hodnocení: $e");
      return null;
    }
  }

  //? Tvorba nového kadeřníka
  Future<Kadernik?> createNewKadernik(Kadernik kadernik) async {
    DocumentReference newDocRef = firestore
        .collection(KADERNICI_COLLECTION_REF)
        .doc();

    String newId = newDocRef.id;

    kadernik.id = newId;

    Map<String, dynamic> json = kadernik.toJson();

    try {
      await newDocRef.set(json);
      print("Nový kadeřník $newId vytvořen.");
      return kadernik;
    } catch (e) {
      print("Chyba při tvorbě nového kadeřníka: $e");
      return null;
    }
  }

  //? Tvorba nového úkonu

  //? Tvorba nové lokace
  Future<Lokace?> createNewLokace(Lokace lokace) async {
    DocumentReference newDocRef = firestore
        .collection(LOKACE_COLLECTION_REF)
        .doc();

    String newId = newDocRef.id;

    lokace.id = newId;

    Map<String, dynamic> json = lokace.toJson();

    try {
      await newDocRef.set(json);
      print("Nová lokace $newId vytvořena.");
      return lokace;
    } catch (e) {
      print("Chyba při tvorbě nové lokace: $e");
      return null;
    }
  }

  //? Tvorba nového Kadeřnického úkonu
  Future<KadernickyUkon?> createNewKadernickyUkon(KadernickyUkon ukon) async {
    DocumentReference newDocRef = firestore
        .collection(KADERNICKEUKONY_COLLECTION_REF)
        .doc();

    String newId = newDocRef.id;

    ukon.id = newId;

    Map<String, dynamic> json = ukon.toJson();

    try {
      await newDocRef.set(json);
      print("Nový úkon $newId vytvořen");
      return ukon;
    } catch (e) {
      print("Chyba při tvorbě nového úkonu: $e");
      return null;
    }
  }

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
    List<Future<Rezervace>> listFutureRezervace = [];

    for (var document in query.docs) {
      final data = document.data();

      Future<Rezervace> rezervace = Rezervace.fromJson(data);
      listFutureRezervace.add(rezervace);
    }

    rezervaceList = await Future.wait(listFutureRezervace);

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
  Future<List<Rezervace>> getAllPastRezervaceOfCurrentUser({
    List<KadernickyUkon> vsechnyUkony = const [],
  }) async {
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
    List<Future<Rezervace>> listFutureRezervace = [];

    for (var document in query.docs) {
      final data = document.data();

      Future<Rezervace> futureRezervace = Rezervace.fromJson(
        data,
        vsechnyUkony: vsechnyUkony,
      );
      listFutureRezervace.add(futureRezervace);
    }

    rezervaceList = await Future.wait(listFutureRezervace);

    print("Počet historických rezervací: ${rezervaceList.length}");

    return rezervaceList.reversed.toList();
  }

  //? Získání všech budoucích rezervací uživatele
  Future<List<Rezervace>> getAllFutureRezervaceOfCurrentUser({
    List<KadernickyUkon> vsechnyUkony = const [],
  }) async {
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
    List<Future<Rezervace>> listFutureRezervace = [];

    for (var document in query.docs) {
      final data = document.data();

      Future<Rezervace> futureRezervace = Rezervace.fromJson(
        data,
        vsechnyUkony: vsechnyUkony,
      );
      listFutureRezervace.add(futureRezervace);
    }

    rezervaceList = await Future.wait(listFutureRezervace);

    print("Počet budoucích rezervací: ${rezervaceList.length}");
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
    List<Future<Kadernik>> listFutureKadernici = [];

    for (var document in query.docs) {
      final data = document.data();

      Future<Kadernik> kadernik = Kadernik.fromJson(data);
      listFutureKadernici.add(kadernik);
    }

    kadernici = await Future.wait(listFutureKadernici);

    return kadernici;
  }

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

  //? Získání všech hodnocení
  Future<List<Hodnoceni>> getAllHodnoceni() async {
    final query = await firestore.collection(HODNOCENI_COLLECTION_REF).get();

    if (query.docs.isEmpty) {
      print("Žádná hodnocení v databázi!");
      return [];
    }

    List<Hodnoceni> hodnoceni = [];

    for (var document in query.docs) {
      final data = document.data();

      Hodnoceni ukon = Hodnoceni.fromJson(data);
      hodnoceni.add(ukon);
    }

    return hodnoceni;
  }

  //? Získání všech lokací
  Future<List<Lokace>> getAllLokace() async {
    final query = await firestore.collection(LOKACE_COLLECTION_REF).get();

    if (query.docs.isEmpty) {
      print("Žádné lokace v databázi");
      return [];
    }

    List<Lokace> lokace = [];

    for (var document in query.docs) {
      final data = document.data();

      Lokace singleLokace = Lokace.fromJson(data);
      lokace.add(singleLokace);
    }

    return lokace;
  }

  //? Zjištění, pokud existuje nějaký dokument Hodnoceni určitého kadeřníka, kde hodnotitel je uživatel
  Future<Hodnoceni?> getHodnoceniOfSpecificKadernikByCurrentUzivatel(
    String kadernikId,
  ) async {
    final query = await firestore
        .collection(HODNOCENI_COLLECTION_REF)
        .where('id_uzivatele', isEqualTo: instance.currentUser!.uid)
        .where('id_kadernika', isEqualTo: kadernikId)
        .get();

    //? Pokud je výsledek empty - znamená to že neexistuje hodnocení tímto uživatelem = return null
    if (query.docs.isEmpty) {
      print("Neexistuje dokument Hodnoceni, který by odpovídal uživateli.");
      return null;
    }
    print("Hodnocení uživatelem bylo nalezeno!");
    Hodnoceni hodnoceni = Hodnoceni.fromJson(query.docs.first.data());

    return hodnoceni;
  }

  //? Smazání Rezervace
  Future<void> deleteRezervace(String rezervaceId) async {
    final query = await firestore
        .collection(REZERVACE_COLLECTION_REF)
        .doc(rezervaceId)
        .delete();

    print("Úspěšně smazána rezervace");
  }

  //? Smazání Rezervace
  Future<void> deleteHodnoceni(String hodnoceniId) async {
    final query = await firestore
        .collection(HODNOCENI_COLLECTION_REF)
        .doc(hodnoceniId)
        .delete();

    print("Úspěšně smazáné hodnocení");
  }

  //? Smazání Kadeřníka
  Future<void> deleteKadernik(String kadernikId) async {
    //? Takové "Otevření" firestore operací - dobré když jich budu dělat více
    WriteBatch batch = firestore.batch();
    final kadernikDocRef = firestore
        .collection(KADERNICI_COLLECTION_REF)
        .doc(kadernikId);
    batch.delete(kadernikDocRef);

    //? Smazání všech Hodnocení kadeřníka
    var hodnoceniQuery = await firestore
        .collection(HODNOCENI_COLLECTION_REF)
        .where('id_kadernika', isEqualTo: kadernikId)
        .get();

    for (var doc in hodnoceniQuery.docs) {
      batch.delete(doc.reference);
    }

    //? Smazání všech rezervací spojených s Kadeřníkem
    var rezervaceQuery = await firestore
        .collection(REZERVACE_COLLECTION_REF)
        .where('id_kadernika', isEqualTo: kadernikId)
        .get();

    for (var doc in rezervaceQuery.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit(); //? Všechny úkony se provedou asynchronně

    print("Kadeřník a všechna jeho data byla úspěšně smazána.");
  }

  //? Smazání lokace
  Future<void> deleteLokace(String lokaceId) async {
    final query = await firestore
        .collection(LOKACE_COLLECTION_REF)
        .doc(lokaceId)
        .delete();

    print("Úspěšně smazána lokace $lokaceId");
  }

  Future<bool> isLokaceUsedByAnyKadernik(String lokaceId) async {
    try {
      final querySnapshot = await firestore
          .collection(KADERNICI_COLLECTION_REF)
          .where('id_lokace', isEqualTo: lokaceId)
          .limit(1) //? Stačí najít jediného, to nám vlastně stačí
          .get();

      //? Pokud querySnapshot.docs není prázný => Lokace je nastavena u nějakého kadeřníka
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Chyba při kontrole využití lokace: $e");
      //? V případě chyby raději vrátíme true (že je použita),
      return true;
    }
  }

  //? Smazání kadeřnického úkonu společně se všemi Rezervacemi, které obsahují tento úkon + všechny zmíňky v dokumentech Kadeřníků, kde by mohli mít tento úkon jako jeden z nabízených
  Future<void> deleteKadernickyUkon(String ukonId) async {
    try {
      WriteBatch batch = firestore.batch();

      //? Smazání samotného Úkonu
      final ukonDocRef = firestore
          .collection(KADERNICKEUKONY_COLLECTION_REF)
          .doc(ukonId);

      batch.delete(ukonDocRef);

      //? Smazání všech Rezervací obsahujících tento úkon (je jedno že obsahuje dalších 5, nedává to smysl držet tuto rezervaci při životě)
      var rezervaceQuery = await firestore
          .collection(REZERVACE_COLLECTION_REF)
          .where('ids_ukony', arrayContains: ukonId)
          .get();

      for (var doc in rezervaceQuery.docs) {
        batch.delete(doc.reference);
      }

      //? Odstranění úkonu z nabídek všech Kadeřníků
      var kaderniciQuery = await firestore
          .collection(KADERNICI_COLLECTION_REF)
          .get();

      for (var doc in kaderniciQuery.docs) {
        Map<String, dynamic> data = doc.data();

        if (data.containsKey('Map_IdsUkonyCena') &&
            data['Map_IdsUkonyCena'] is Map &&
            (data['Map_IdsUkonyCena'] as Map).containsKey(ukonId)) {
          //? Smažeme jen konkrétní klíč v Map (zrychlení programu)
          batch.update(doc.reference, {
            'Map_IdsUkonyCena.$ukonId': FieldValue.delete(),
          });
        }
      }

      //? Odeslání všech změn
      await batch.commit();

      print(
        "Úkon, související rezervace a zmínky u kadeřníků byly úspěšně smazány.",
      );
    } catch (e) {
      print("Chyba při mazání kadeřnického úkonu: $e");
      throw e;
    }
  }
}
