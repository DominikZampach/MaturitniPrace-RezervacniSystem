import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/widgets/carousel_photo.dart';
import 'package:rezervacni_system_maturita/widgets/informations_textbox.dart';
import 'package:http/http.dart' as http;

class SelectPhotosDialog extends StatefulWidget {
  final List<String> photosUrls;
  final Function(dynamic) updateCallback;

  const SelectPhotosDialog({
    super.key,
    required this.photosUrls,
    required this.updateCallback,
  });

  @override
  State<SelectPhotosDialog> createState() => _SelectPhotosDialogState();
}

class _SelectPhotosDialogState extends State<SelectPhotosDialog> {
  final double headingFontSize = 15.sp;
  final double smallHeadingFontSize = 13.sp;
  final double normalTextFontSize = 11.sp;
  final double smallerTextFontSize = 10.sp;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _newUrlController = TextEditingController();

    return Dialog(
      backgroundColor: Consts.background,
      alignment: Alignment.center,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10.r),
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.67,
        minWidth: MediaQuery.of(context).size.width * 0.7,
        maxWidth: MediaQuery.of(context).size.width * 0.7,
        maxHeight: MediaQuery.of(context).size.height * 0.67,
      ),

      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Edit photos of work",
                style: TextStyle(
                  fontSize: headingFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                "Number of photos: ${widget.photosUrls.length}",
                style: TextStyle(fontSize: smallHeadingFontSize),
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.37,
                child: CarouselSlider.builder(
                  itemCount: widget.photosUrls.length,
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.35,
                    viewportFraction: 0.2,
                    initialPage: 1,
                    autoPlay: false,
                    enableInfiniteScroll: false,
                    padEnds:
                        false, //? Toto dělá to, že se to zasekne u krajních fotek
                  ),
                  itemBuilder:
                      (BuildContext context, int itemIndex, int pageViewIndex) {
                        String urlPhoto = widget.photosUrls[itemIndex];
                        return Column(
                          children: [
                            CarouselPhoto(
                              url: urlPhoto,
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: MediaQuery.of(context).size.width * 0.2,
                            ),
                            SizedBox(height: 10.h),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  widget.photosUrls.removeAt(itemIndex);
                                  widget.updateCallback(widget.photosUrls);
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Consts.secondary,
                                ),
                              ),
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  fontSize: smallerTextFontSize,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                ),
              ),
              InformationTextbox(
                context: context,
                verticalPadding: 5.h,
                horizontalPadding: 0,
                textInFront: "New Photo URL: ",
                controller: _newUrlController,
                spacingGap: 5.w,
                textBoxWidth: 400.w,
                fontSize: normalTextFontSize,
              ),
              SizedBox(height: 10.h),
              ElevatedButton(
                onPressed: () async {
                  String urlInput = _newUrlController.text.trim();

                  if (urlInput.isEmpty) {
                    ToastClass.showToastSnackbar(
                      message: "Please enter a URL.",
                    );
                    return;
                  }

                  try {
                    final uri = Uri.parse(urlInput);
                    var response = await http.head(
                      uri,
                      headers: Consts.httpHeaders,
                    );
                    if (response.statusCode == 200) {
                      //? Kontrola, zda se skutečně jedná o obrázek
                      String? contentType = response.headers['content-type'];

                      if (contentType != null &&
                          contentType.startsWith('image/')) {
                        setState(() {
                          widget.photosUrls.add(urlInput);
                          widget.updateCallback(widget.photosUrls);
                          _newUrlController.clear();
                        });
                        ToastClass.showToastSnackbar(message: "Photo added.");
                      } else {
                        ToastClass.showToastSnackbar(
                          message: "URL is not a valid image file.",
                        );
                      }
                    } else {
                      ToastClass.showToastSnackbar(
                        message:
                            "Image not found (Error ${response.statusCode})",
                      );
                    }
                  } catch (e) {
                    ToastClass.showToastSnackbar(
                      message: "Invalid URL format.",
                    );
                    print(e.toString());
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Consts.secondary),
                ),
                child: Text(
                  "Add Photo",
                  style: TextStyle(
                    fontSize: normalTextFontSize,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
