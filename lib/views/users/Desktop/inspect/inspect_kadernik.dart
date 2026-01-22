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
import 'package:rezervacni_system_maturita/views/users/Desktop/create_reservation_dialog.dart';
import 'package:rezervacni_system_maturita/views/users/Desktop/inspect/inspect_kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/widgets/carousel_photo.dart';
import 'package:rezervacni_system_maturita/widgets/hairdresser_card.dart';

class InspectKadernik extends StatefulWidget {
  final Kadernik kadernik;
  late double hodnoceniKadernika;
  late int pocetHodnoceniKadernika;
  final Uzivatel uzivatel;
  late double hodnoceniKadernikaSoucetVsechnHodnoceni;
  final Function(double, double, int, String?, Hodnoceni?) onChanged;

  InspectKadernik({
    super.key,
    required this.kadernik,
    required this.hodnoceniKadernika,
    required this.pocetHodnoceniKadernika,
    required this.uzivatel,
    required this.hodnoceniKadernikaSoucetVsechnHodnoceni,
    required this.onChanged,
  });

  @override
  State<InspectKadernik> createState() => _InspectKadernikState();
}

class _InspectKadernikState extends State<InspectKadernik> {
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
    final double headingFontSize = 15.sp;
    final double smallHeadingFontSize = 13.sp;
    final double normalTextFontSize = 11.sp;
    final double smallerTextFontSize = 10.sp;

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

        return Dialog(
          backgroundColor: Consts.background,
          alignment: Alignment.center,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10.r),
          ),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.9,
            minWidth: MediaQuery.of(context).size.width * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),

          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min, //? Možná dát pryč
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _nameDescriptionFavouriteStarStack(
                      headingFontSize,
                      normalTextFontSize,
                    ),

                    SizedBox(height: 30.h),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _services(
                                    snapshot.data!.kadernickeUkonySCenami,
                                    smallHeadingFontSize,
                                    normalTextFontSize,
                                    smallerTextFontSize,
                                  ),
                                  _rating(
                                    smallHeadingFontSize,
                                    normalTextFontSize,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                "${widget.kadernik.jmeno}'s work:",
                                style: TextStyle(
                                  fontSize: smallHeadingFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              _carousel(),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20.h),
                              _kaderniksPhoto(),
                              SizedBox(height: 20.h),
                              Text(
                                "Location:",
                                style: TextStyle(
                                  fontSize: headingFontSize,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                widget.kadernik.lokace.nazev,
                                style: TextStyle(
                                  fontSize: normalTextFontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "Address:",
                                style: TextStyle(
                                  fontSize: normalTextFontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "${widget.kadernik.lokace.adresa}\n${widget.kadernik.lokace.psc}-${widget.kadernik.lokace.mesto}",
                                style: TextStyle(fontSize: normalTextFontSize),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20.h),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        CreateReservationDialog(
                                          defaultKadernikId: widget.kadernik.id,
                                          defaultLokaceId:
                                              widget.kadernik.lokace.id,
                                        ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Consts.secondary,
                                  ),
                                ),
                                child: Text(
                                  "Book now",
                                  style: TextStyle(
                                    fontSize: smallHeadingFontSize,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
        viewportFraction: 0.33,
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
      //width: MediaQuery.of(context).size.width * 0.2,
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

  Expanded _services(
    List<KadernickyUkon> kadernickeUkonySCenami,
    double smallHeadingFontSize,
    double normalTextFontSize,
    double smallerTextFontSize,
  ) {
    ScrollController scrollerController = ScrollController();

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        //? Otevření Dialogu, kde budou informace a fotky úkonu
                        final dialogResult = showDialog(
                          context: context,
                          builder: (context) =>
                              InspectKadernickyUkon(kadernickyUkon: ukon),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _rating(double smallHeadingFontSize, double normalTextFontSize) {
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

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                            widget.hodnoceniKadernikaSoucetVsechnHodnoceni =
                                0.0;
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

  SizedBox _nameDescriptionFavouriteStarStack(
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
        ],
      ),
    );
  }

  Positioned _favouriteStar() {
    return Positioned(
      right: 0,
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
            size: 30.w,
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
