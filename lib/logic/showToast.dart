import 'package:fluttertoast/fluttertoast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';

const int shortToastMaxLength = 16;

class ToastClass {
  static void showToastSnackbar({required String message}) {
    int messageLength = message.length;

    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Consts.colorScheme.error,
      gravity: ToastGravity.SNACKBAR,
      toastLength: messageLength > shortToastMaxLength
          ? Toast.LENGTH_LONG
          : Toast.LENGTH_SHORT,
    );
  }
}
