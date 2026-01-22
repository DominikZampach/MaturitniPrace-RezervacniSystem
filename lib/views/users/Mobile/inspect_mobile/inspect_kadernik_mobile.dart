import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/getAvgRating.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/hodnoceni.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/users/Desktop/inspect/inspect_kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/views/users/Mobile/create_reservation_dialog_mobile.dart';
import 'package:rezervacni_system_maturita/views/users/Mobile/inspect_mobile/inspect_kadernicky_ukon_mobile.dart';
import 'package:rezervacni_system_maturita/widgets/carousel_photo.dart';

class InspectKadernikMobile extends StatefulWidget {
  final Kadernik kadernik;
  late double hodnoceniKadernika;
  late int pocetHodnoceniKadernika;
  final Uzivatel uzivatel;
  late double hodnoceniKadernikaSoucetVsechnHodnoceni;
  final Function(double, double, int, String?, Hodnoceni?) onChanged;

  final double mobileFontSize;
  final double mobileSmallerFontSize;
  final double mobileHeadingsFontSize;
  final double mobileSmallerHeadingsFontSize;

  InspectKadernikMobile({
    super.key,
    required this.kadernik,
    required this.hodnoceniKadernika,
    required this.pocetHodnoceniKadernika,
    required this.uzivatel,
    required this.hodnoceniKadernikaSoucetVsechnHodnoceni,
    required this.onChanged,
    required this.mobileFontSize,
    required this.mobileSmallerFontSize,
    required this.mobileHeadingsFontSize,
    required this.mobileSmallerHeadingsFontSize,
  });

  @override
  State<InspectKadernikMobile> createState() => _InspectKadernikMobileState();
}

class _InspectKadernikMobileState extends State<InspectKadernikMobile> {
  late Future<_NactenaData> futureLogika;
  late bool isKadernikFavourite;
  late String selectedValueRating;

  Hodnoceni? _aktualniHodnoceniUzivatele;

  @override
  void initState() {
    super.initState();
    futureLogika = _nacteniDat();
    isKadernikFavourite = widget.uzivatel.isKadernikFavourite(
      widget.kadernik.id,
    );
  }

  Future<_NactenaData> _nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    final results = await Future.wait([
      dbService.getHodnoceniOfSpecificKadernikByCurrentUzivatel(
        widget.kadernik.id,
      ),
      widget.kadernik.getAllKadernickyUkonAndPrice(),
    ]);

    final hodnoceniUzivatelem = results[0] as Hodnoceni?;
    final kadernickeUkonySCenami = results[1] as List<KadernickyUkon>;

    _aktualniHodnoceniUzivatele = hodnoceniUzivatelem;

    if (hodnoceniUzivatelem == null) {
      selectedValueRating = "-";
    } else {
      selectedValueRating = hodnoceniUzivatelem.ciselneHodnoceni.toString();
    }

    return _NactenaData(
      hodnoceniUzivatelem: hodnoceniUzivatelem,
      kadernickeUkonySCenami: kadernickeUkonySCenami,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureLogika,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Error při načítání dat: ${snapshot.error}");
          return const Center(
            child: Text(
              "Error occured while trying to load data from database!",
            ),
          );
        }

        return Dialog.fullscreen(
          backgroundColor: Consts.background,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min, //? Možná dát pryč
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _nameDescriptionFavouriteStarLeadingStack(
                    widget.mobileHeadingsFontSize,
                    widget.mobileFontSize,
                  ),

                  SizedBox(height: 30.h),

                  _kaderniksPhoto(),

                  SizedBox(height: 20.h),

                  _services(
                    snapshot.data!.kadernickeUkonySCenami,
                    widget.mobileSmallerHeadingsFontSize,
                    widget.mobileFontSize,
                    widget.mobileSmallerFontSize,
                  ),
                  SizedBox(height: 20.h),
                  _rating(
                    widget.mobileSmallerHeadingsFontSize,
                    widget.mobileFontSize,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "${widget.kadernik.jmeno}'s work:",
                    style: TextStyle(
                      fontSize: widget.mobileSmallerHeadingsFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _carousel(),
                  SizedBox(height: 20.h),
                  Text(
                    "Location:",
                    style: TextStyle(
                      fontSize: widget.mobileSmallerHeadingsFontSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    widget.kadernik.lokace.nazev,
                    style: TextStyle(
                      fontSize: widget.mobileFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Address:",
                    style: TextStyle(
                      fontSize: widget.mobileFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "${widget.kadernik.lokace.adresa}\n${widget.kadernik.lokace.psc}-${widget.kadernik.lokace.mesto}",
                    style: TextStyle(fontSize: widget.mobileFontSize),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await showDialog(
                        context: context,
                        builder: (context) => CreateReservationDialogMobile(
                          mobileFontSize: widget.mobileFontSize,
                          mobileSmallerFontSize: widget.mobileSmallerFontSize,
                          mobileHeadingsFontSize: widget.mobileHeadingsFontSize,
                          mobileSmallerHeadingFontSize:
                              widget.mobileSmallerHeadingsFontSize,
                          defaultKadernikId: widget.kadernik.id,
                          defaultLokaceId: widget.kadernik.lokace.id,
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Consts.secondary),
                    ),
                    child: Text(
                      "Book now",
                      style: TextStyle(
                        fontSize: widget.mobileSmallerHeadingsFontSize,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  CarouselSlider _carousel() {
    return CarouselSlider.builder(
      itemCount: widget.kadernik.odkazyFotografiiPrace.length,
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.3,
        viewportFraction: 0.9,
        initialPage: 0,
        autoPlay: true,
        enableInfiniteScroll: true,
        autoPlayInterval: Duration(seconds: 5),
      ),
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        String urlPhoto = widget.kadernik.odkazyFotografiiPrace[itemIndex];
        return CarouselPhoto(
          url: urlPhoto,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.25,
        );
      },
    );
  }

  Widget _kaderniksPhoto() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(10.r),
        child: FittedBox(
          fit: BoxFit.contain,
          child: CachedNetworkImage(
            imageUrl: widget.kadernik.odkazFotografie,
            httpHeaders: {
              "Access-Control-Allow-Origin": "*",
              "User-Agent": "Mozilla/5.0...",
            },
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error, size: 30.h),
          ),
        ),
      ),
    );
  }

  Padding _services(
    List<KadernickyUkon> kadernickeUkonySCenami,
    double smallHeadingFontSize,
    double normalTextFontSize,
    double smallerTextFontSize,
  ) {
    ScrollController scrollerController = ScrollController();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Text(
              "Services:",
              style: TextStyle(
                fontSize: smallHeadingFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            //? Scrollbar by měl zajistit lepší zobrazení toho scrollovacího baru napravo
            child: Scrollbar(
              controller: scrollerController,
              thumbVisibility: true,
              trackVisibility: false,
              thickness: 7.w,
              radius: Radius.circular(10.r),
              child: ListView.builder(
                controller: scrollerController,
                itemCount: kadernickeUkonySCenami.length,
                itemBuilder: (context, index) {
                  final ukon = kadernickeUkonySCenami[index];

                  return ListTile(
                    title: Text(
                      ukon.nazev,
                      style: TextStyle(fontSize: normalTextFontSize),
                    ),
                    trailing: Text(
                      "${ukon.cena} Kč",
                      style: TextStyle(fontSize: normalTextFontSize),
                    ),
                    subtitle: Text(
                      "Typ: ${ukon.getTypStrihu()}",
                      style: TextStyle(fontSize: smallerTextFontSize),
                    ),
                    onTap: () {
                      final dialogResult = showDialog(
                        context: context,
                        builder: (context) => InspectKadernickyUkonMobile(
                          mobileFontSize: widget.mobileFontSize,
                          mobileSmallerFontSize: widget.mobileSmallerFontSize,
                          mobileHeadingsFontSize: widget.mobileHeadingsFontSize,
                          mobileSmallerHeadingsFontSize:
                              widget.mobileSmallerHeadingsFontSize,
                          kadernickyUkon: ukon,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _rating(double smallHeadingFontSize, double normalTextFontSize) {
    List<DropdownMenuItem> dropdownMenuItems = [
      DropdownMenuItem(
        value: "-",
        child: Text(
          "-",
          style: TextStyle(fontSize: normalTextFontSize),
          textAlign: TextAlign.center,
        ),
      ),
      for (int i = 1; i <= 10; i++)
        DropdownMenuItem(
          value: i.toString(),
          child: Text(
            i.toString(),
            style: TextStyle(fontSize: normalTextFontSize),
            textAlign: TextAlign.center,
          ),
        ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Rating:",
            style: TextStyle(
              fontSize: smallHeadingFontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20.h),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: normalTextFontSize),
              children: [
                TextSpan(text: "Average rating: "),
                TextSpan(
                  text: "${widget.hodnoceniKadernika}*",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Number of reviews: ${widget.pocetHodnoceniKadernika}",
            style: TextStyle(fontSize: normalTextFontSize),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your rating:",
                style: TextStyle(fontSize: normalTextFontSize),
              ),
              DropdownButton(
                value: selectedValueRating,
                items: dropdownMenuItems,
                alignment: AlignmentGeometry.center,
                onChanged: (dynamic newValue) async {
                  //TODO: Přepsat do čitelnější formy, nějak to funguje ale je to mega bordel
                  DatabaseService dbService = DatabaseService();
                  String? idToDelele;
                  Hodnoceni? hodnoceniToAdd;

                  if (_aktualniHodnoceniUzivatele != null) {
                    //? Dokument existuje - úprava dat v databázi
                    int oldHodnoceni =
                        _aktualniHodnoceniUzivatele!.ciselneHodnoceni;

                    if (newValue == "-") {
                      //? Musím to smazat i v Browse Body v listu všech kadeřníkových Hodnocení - proto to posílám ve funkci onChanged
                      idToDelele = _aktualniHodnoceniUzivatele!.id;

                      setState(() {
                        selectedValueRating = "-";
                        widget.pocetHodnoceniKadernika--;
                        widget.hodnoceniKadernikaSoucetVsechnHodnoceni -=
                            oldHodnoceni;

                        if (widget.pocetHodnoceniKadernika > 0) {
                          widget.hodnoceniKadernika = zaokrouhliHodnoceni(
                            widget.hodnoceniKadernikaSoucetVsechnHodnoceni /
                                widget.pocetHodnoceniKadernika,
                          );
                        } else {
                          widget.hodnoceniKadernika = 0.0;
                          widget.hodnoceniKadernikaSoucetVsechnHodnoceni = 0.0;
                        }

                        _aktualniHodnoceniUzivatele = null;
                      });

                      await dbService.deleteHodnoceni(idToDelele);
                    } else {
                      int novyVysledek = int.parse(newValue);
                      int rozdil = novyVysledek - oldHodnoceni;

                      _aktualniHodnoceniUzivatele!.ciselneHodnoceni =
                          novyVysledek;

                      setState(() {
                        selectedValueRating = newValue;
                        widget.hodnoceniKadernikaSoucetVsechnHodnoceni +=
                            rozdil;
                        widget.hodnoceniKadernika = zaokrouhliHodnoceni(
                          widget.hodnoceniKadernikaSoucetVsechnHodnoceni /
                              widget.pocetHodnoceniKadernika,
                        );
                      });
                      await dbService.updateHodnoceni(
                        _aktualniHodnoceniUzivatele!,
                      );
                    }
                  } else {
                    //? Tvorba nového dokumentu v databázi

                    if (newValue == "-") return;

                    Hodnoceni noveHodnoceni = Hodnoceni(
                      id: "",
                      idUzivatele: widget.uzivatel.userUID,
                      idKadernika: widget.kadernik.id,
                      ciselneHodnoceni: int.parse(newValue),
                    );

                    Hodnoceni? noveHodnoceniWithId = await dbService
                        .createNewHodnoceni(noveHodnoceni);

                    //? Musím to nové hodnocení poslat do listu všech uživatelových Hodnocení zpět do Browse body - dám jej tedy do proměnné hodnoceniToAdd
                    hodnoceniToAdd = noveHodnoceniWithId;

                    setState(() {
                      selectedValueRating = newValue;
                      _aktualniHodnoceniUzivatele = noveHodnoceniWithId;
                      widget.pocetHodnoceniKadernika++;
                      widget.hodnoceniKadernikaSoucetVsechnHodnoceni +=
                          double.parse(newValue);
                      widget.hodnoceniKadernika = zaokrouhliHodnoceni(
                        widget.hodnoceniKadernikaSoucetVsechnHodnoceni /
                            widget.pocetHodnoceniKadernika,
                      );
                    });
                  }

                  widget.onChanged(
                    widget.hodnoceniKadernika,
                    widget.hodnoceniKadernikaSoucetVsechnHodnoceni,
                    widget.pocetHodnoceniKadernika,
                    idToDelele,
                    hodnoceniToAdd,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Text _description(double normalTextFontSize) {
    return Text(
      widget.kadernik.popisek,
      style: TextStyle(
        fontSize: normalTextFontSize,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  SizedBox _nameDescriptionFavouriteStarLeadingStack(
    double headingFontSize,
    double normalTextFontSize,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Text(
                widget.kadernik.getFullNameString(),
                style: TextStyle(
                  fontSize: headingFontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              _description(normalTextFontSize),
            ],
          ),
          //? Widget Positioned umístí child podle určených parametrů (tady right = 0) na pozici ve Stacku
          _favouriteStar(),
          _leading(),
        ],
      ),
    );
  }

  Positioned _leading() {
    return Positioned(
      left: 10,
      top: 5,
      child: GestureDetector(
        onTap: () => Navigator.of(context, rootNavigator: true).pop(),
        child: Icon(Icons.arrow_back, size: 20.h),
      ),
    );
  }

  Positioned _favouriteStar() {
    return Positioned(
      right: 10,
      top: 5,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (isKadernikFavourite) {
              //? Toto se provede pokud byl kadeřník favourite - po kliknutí tedy už není
              widget.uzivatel.oblibeniKadernici.remove(widget.kadernik.id);
            } else {
              //? Toto se provede pokud kadeřník nebyl favourite - přidá se do listu favourite kadeřníků
              widget.uzivatel.oblibeniKadernici.add(widget.kadernik.id);
            }

            DatabaseService dbService = DatabaseService();

            dbService.updateUzivatel(widget.uzivatel);

            setState(() {
              isKadernikFavourite = !isKadernikFavourite;
            });
          },
          child: Icon(
            //? Ukáže se správná verze hvězdy
            isKadernikFavourite ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 20.h,
          ),
        ),
      ),
    );
  }
}

class _NactenaData {
  final Hodnoceni? hodnoceniUzivatelem;
  final List<KadernickyUkon> kadernickeUkonySCenami;

  const _NactenaData({
    required this.hodnoceniUzivatelem,
    required this.kadernickeUkonySCenami,
  });
}
