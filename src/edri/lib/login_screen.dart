import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'util.dart';

class BackgroundCustomPainter extends CustomPainter {
  Color primaryColor;

  BackgroundCustomPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    double baseline = size.height * 0.45;
    double unit = size.height * 0.01;

    // bottom-most curve
    Path curve1 = Path()
      ..moveTo(0, baseline)
      ..cubicTo(size.width * 0.33, baseline + unit * 5, size.width * 0.66, baseline - unit * 12, size.width,
          baseline - unit * 7)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0);
    Paint paint1 = Paint()
      ..color = changeBrightness(primaryColor, 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawPath(curve1, paint1);

    // middle curve
    baseline -= unit * 5;
    Path curve2 = Path()
      ..moveTo(0, baseline)
      ..cubicTo(size.width * 0.33, baseline + unit * 5, size.width * 0.66, baseline - unit * 12, size.width,
          baseline - unit * 7)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0);
    // redDB(primaryColor.toString());
    // redDB(changeBrightness(primaryColor, 0.2).toString());
    Paint paint2 = Paint()
      ..color = changeBrightness(primaryColor, 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawPath(curve2, paint2);

    // top-most curve
    baseline -= unit * 5;
    Path curve3 = Path()
      ..moveTo(0, baseline)
      ..cubicTo(size.width * 0.33, baseline + unit * 5, size.width * 0.66, baseline - unit * 12, size.width,
          baseline - unit * 7)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0);
    // redDB(primaryColor.toString());
    // redDB(changeBrightness(primaryColor, 0.2).toString());
    Paint paint3 = Paint()
      ..color = changeBrightness(primaryColor, 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawPath(curve3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool sentOTP = false;
  FocusNode focusNode = FocusNode();
  FirebaseAuth auth = FirebaseAuth.instance;
  var phFieldKey = UniqueKey();
  var otpFieldKey = UniqueKey();
  TextEditingController numberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String verID = "";

  void sendOTP() async {
    if (kIsWeb) {
      ConfirmationResult confirmationResult =
          await auth.signInWithPhoneNumber("+91${numberController.text}").catchError(
        (err, stackTrace) {
          Fluttertoast.showToast(msg: "Something went wrong!");
          setState(() {
            sentOTP = false;
            isLoading = false;
          });
        },
      );
      setState(() {
        sentOTP = true;
        isLoading = false;
      });
      verID = confirmationResult.verificationId;
    } else {
      await auth.verifyPhoneNumber(
        phoneNumber: "+91${numberController.text}",
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(msg: "Something went wrong!");
          setState(() {
            isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          verID = verificationId;
          Fluttertoast.showToast(msg: "OTP sent!");
          setState(() {
            sentOTP = true;
            isLoading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  void verifyOTP() async {
    setState(() {
      isLoading = true;
    });
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verID, smsCode: otpController.text);
    await auth.signInWithCredential(credential).then((value) {
      Fluttertoast.showToast(msg: "Signed In");
      Navigator.pushReplacementNamed(context, "/survey_selection");
    }).catchError((err) {
      redDBG(err);
      Fluttertoast.showToast(msg: "Something went wrong!");
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double? hlSmallSize = Theme.of(context).textTheme.headlineSmall?.fontSize;

    Widget phoneNumberField() {
      return Padding(
        key: phFieldKey,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: (hlSmallSize! - 6)),
                ),
              ),
            ),
            TextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                floatingLabelAlignment: FloatingLabelAlignment.start,
                hintText: "Phone Number",
                prefixText: "+91   ",
                prefixStyle: TextStyle(fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
              ),
              controller: numberController,
            ),
          ],
        ),
      );
    }

    Widget otpField() {
      var focusedBorderColor = changeBrightness(Theme.of(context).colorScheme.primary, 1);
      var fillColor = Colors.transparent;
      var borderColor = changeBrightness(Theme.of(context).colorScheme.primary, 1);

      final defaultPinTheme = PinTheme(
        width: 56,
        height: 56,
        textStyle: TextStyle(
          fontSize: 22,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: borderColor),
        ),
      );

      return Padding(
        key: otpFieldKey,
        padding: const EdgeInsets.fromLTRB(38.0, 68.0, 38.0, 8.0),
        child: Pinput(
          length: 6,
          controller: otpController,
          focusNode: focusNode,
          // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
          // listenForMultipleSmsOnAndroid: true,
          defaultPinTheme: defaultPinTheme,
          // onClipboardFound: (value) {
          //   debugPrint('onClipboardFound: $value');
          //   otpController.setText(value);
          // },
          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 9),
                width: 22,
                height: 1,
                color: focusedBorderColor,
              ),
            ],
          ),
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: focusedBorderColor),
            ),
          ),
          submittedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              color: fillColor,
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: focusedBorderColor),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Stack(
          children: [
            // background
            RepaintBoundary(
              child: Container(
                color: Colors.transparent,
                height: screenHeight,
                width: screenWidth,
                child: CustomPaint(
                  painter: BackgroundCustomPainter(primaryColor: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(36),
                child: Column(
                  children: [
                    Text(
                      "Welcome to EDRI",
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontFamily: "Arvo",
                            color: Colors.white,
                          ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.18,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 1000),
                      transitionBuilder: (child, animation) {
                        Offset begin;
                        Offset end;
                        if (child.key == phFieldKey) {
                          // redDBG("phField Animated");
                          begin = const Offset(-1.5, 0.0);
                          end = const Offset(0.0, 0.0);
                        } else {
                          // redDBG("otpField Animated");
                          begin = const Offset(1.5, 0.0);
                          end = const Offset(0.0, 0.0);
                        }
                        var switcherOffsetAnimation = Tween(
                          begin: begin,
                          end: end,
                        ).animate(animation);
                        return SlideTransition(
                          position: switcherOffsetAnimation,
                          child: child,
                        );
                      },
                      switchInCurve: Curves.easeInOutCubic,
                      switchOutCurve: Curves.easeInOutCubic,
                      child: (sentOTP) ? otpField() : phoneNumberField(),
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!sentOTP) {
                            setState(() {
                              isLoading = true;
                            });
                            sendOTP();
                          } else {
                            verifyOTP();
                          }
                        },
                        child: (isLoading)
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                child: SizedBox(
                                  height: Theme.of(context).textTheme.labelLarge?.fontSize,
                                  width: Theme.of(context).textTheme.labelLarge?.fontSize,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: (!isDarkTheme(context)) ? Colors.white : Colors.black,
                                  ),
                                ),
                              )
                            : const Text("Submit"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
