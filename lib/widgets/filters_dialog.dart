import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';

class FiltersDialog extends StatefulWidget {
  Filters filters;
  List<Lokace> allLokace;
  FiltersDialog({super.key, required this.filters, required this.allLokace});

  @override
  State<FiltersDialog> createState() => _FiltersDialogState();
}

class _FiltersDialogState extends State<FiltersDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double headingFontSize = 15.sp;
    final double smallHeadingFontSize = 13.sp;
    final double normalTextFontSize = 11.sp;
    final double smallerTextFontSize = 10.sp;

    final List<DropdownMenuItem<double>> _dropdownMenuRatingItems = [
      for (double i = 0; i <= 10; i++)
        DropdownMenuItem(
          alignment: AlignmentGeometry.center,
          value: i,
          child: Text(
            i.toString(),
            style: TextStyle(fontSize: normalTextFontSize),
            textAlign: TextAlign.center,
          ),
        ),
    ];

    final List<DropdownMenuItem<String>> _dropdownMenuLokaceItems = [
      DropdownMenuItem(
        alignment: AlignmentGeometry.center,
        value: null,
        child: Text(
          "No preference",
          style: TextStyle(fontSize: normalTextFontSize),
          textAlign: TextAlign.center,
        ),
      ),
      for (Lokace lokace in widget.allLokace)
        DropdownMenuItem(
          alignment: AlignmentGeometry.center,
          value: lokace.id,
          child: Text(
            lokace.nazev,
            style: TextStyle(fontSize: normalTextFontSize),
            textAlign: TextAlign.center,
          ),
        ),
    ];

    return Dialog(
      backgroundColor: Consts.background,
      alignment: Alignment.center,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10.r),
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.4,
        minWidth: MediaQuery.of(context).size.width * 0.3,
        maxWidth: MediaQuery.of(context).size.width * 0.3,
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),

      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Text(
                "Filters:",
                style: TextStyle(
                  fontSize: headingFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.h),
              _favourite(smallHeadingFontSize),
              _minimalRating(
                smallHeadingFontSize,
                normalTextFontSize,
                _dropdownMenuRatingItems,
              ),
              _location(
                smallHeadingFontSize,
                normalTextFontSize,
                _dropdownMenuLokaceItems,
              ),
              SizedBox(height: 15.h),
              _saveButton(normalTextFontSize, widget.filters),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _saveButton(double normalTextFontSize, Filters filters) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Consts.secondary),
        fixedSize: WidgetStatePropertyAll(Size(120.w, 40.h)),
      ),
      onPressed: () {
        //? Vrátí aktualizovaný dokument s filtry
        Navigator.of(context).pop(filters);
      },
      child: Text(
        "Save filters",
        style: TextStyle(
          fontSize: normalTextFontSize,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Row _location(
    double smallHeadingFontSize,
    double normalTextFontSize,
    List<DropdownMenuItem<String>> _dropdownMenuLokaceItems,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Select location:",
          style: TextStyle(fontSize: smallHeadingFontSize),
        ),
        DropdownButton<String>(
          alignment: AlignmentGeometry.center,
          style: TextStyle(fontSize: normalTextFontSize),
          items: _dropdownMenuLokaceItems,
          value: widget.filters.lokaceId,
          onChanged: (String? newValue) {
            setState(() {
              widget.filters.lokaceId = newValue;
            });
          },
        ),
      ],
    );
  }

  Row _minimalRating(
    double smallHeadingFontSize,
    double normalTextFontSize,
    List<DropdownMenuItem<double>> dropdownMenuRatingItems,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Minimal rating:",
          style: TextStyle(fontSize: smallHeadingFontSize),
        ),
        DropdownButton<double>(
          alignment: AlignmentGeometry.center,
          style: TextStyle(fontSize: normalTextFontSize),
          items: dropdownMenuRatingItems,
          value: widget.filters.minimalRating,
          onChanged: (double? newValue) {
            setState(() {
              if (newValue != null) {
                widget.filters.minimalRating = newValue;
              }
            });
          },
        ),
      ],
    );
  }

  Row _favourite(double smallHeadingFontSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Show only favourite:",
          style: TextStyle(fontSize: smallHeadingFontSize),
        ),
        Checkbox(
          value: widget.filters.showOnlyFavourite,
          onChanged: (value) => setState(() {
            widget.filters.showOnlyFavourite =
                !widget.filters.showOnlyFavourite;
          }),
        ),
      ],
    );
  }
}

class Filters {
  bool showOnlyFavourite;
  double minimalRating;
  String? lokaceId;

  Filters({
    required this.showOnlyFavourite,
    required this.minimalRating,
    required this.lokaceId,
  });
}
