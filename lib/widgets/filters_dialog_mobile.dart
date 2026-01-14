import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/widgets/filters_dialog_desktop.dart';

class FiltersDialogMobile extends StatefulWidget {
  Filters filters;
  List<Lokace> allLokace;

  double? headingFontSize;
  double? smallHeadingFontSize;
  double? normalTextFontSize;

  FiltersDialogMobile({
    super.key,
    required this.filters,
    required this.allLokace,
    this.headingFontSize,
    this.smallHeadingFontSize,
    this.normalTextFontSize,
  });

  @override
  State<FiltersDialogMobile> createState() => _FiltersDialogMobileState();
}

class _FiltersDialogMobileState extends State<FiltersDialogMobile> {
  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<double>> _dropdownMenuRatingItems = [
      for (double i = 0; i <= 10; i++)
        DropdownMenuItem(
          alignment: AlignmentGeometry.center,
          value: i,
          child: Text(
            i.toString(),
            style: TextStyle(fontSize: widget.normalTextFontSize),
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
          style: TextStyle(fontSize: widget.normalTextFontSize),
          textAlign: TextAlign.center,
        ),
      ),
      for (Lokace lokace in widget.allLokace)
        DropdownMenuItem(
          alignment: AlignmentGeometry.center,
          value: lokace.id,
          child: Text(
            lokace.nazev,
            style: TextStyle(fontSize: widget.normalTextFontSize),
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
        minWidth: MediaQuery.of(context).size.width * 0.8,
        maxWidth: MediaQuery.of(context).size.width * 0.8,
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),

      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Text(
                "Filters:",
                style: TextStyle(
                  fontSize: widget.headingFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.h),
              _favourite(widget.smallHeadingFontSize!),
              SizedBox(height: 10.h),
              _minimalRating(
                widget.smallHeadingFontSize!,
                widget.normalTextFontSize!,
                _dropdownMenuRatingItems,
              ),
              SizedBox(height: 10.h),
              _location(
                widget.smallHeadingFontSize!,
                widget.normalTextFontSize!,
                _dropdownMenuLokaceItems,
              ),
              SizedBox(height: 15.h),
              _saveButton(widget.normalTextFontSize!, widget.filters),
              SizedBox(height: 10.h),
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
        //fixedSize: WidgetStatePropertyAll(Size(400.w, 60.h)),
      ),
      onPressed: () {
        //? Vrátí aktualizovaný dokument s filtry
        Navigator.of(context).pop(filters);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        child: Text(
          "Save filters",
          style: TextStyle(
            fontSize: normalTextFontSize,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Column _location(
    double smallHeadingFontSize,
    double normalTextFontSize,
    List<DropdownMenuItem<String>> _dropdownMenuLokaceItems,
  ) {
    return Column(
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

  Column _minimalRating(
    double smallHeadingFontSize,
    double normalTextFontSize,
    List<DropdownMenuItem<double>> dropdownMenuRatingItems,
  ) {
    return Column(
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
