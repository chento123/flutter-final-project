import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({Key? key}) : super(key: key);

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final phonenumber = TextEditingController();
  final OtpCodeController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIDRecived = "";
  bool otpCodeVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Number Authentication'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      'Phone Number Authentication',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: phonenumber,
                      decoration: const InputDecoration(
                        label: Text('Phone Number'),
                        border: OutlineInputBorder(),
                        hintText: 'Phone Number login',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: otpCodeVisible,
                      child:  TextField(
                        controller: OtpCodeController,
                        decoration: const InputDecoration(
                            label: Text('Phone Number'),
                            border: OutlineInputBorder(),
                            hintText: 'Phone Number login'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      child: Container(
                        height: 50,
                        width: 150,
                        child: Center(
                          child: Text(otpCodeVisible ? 'Login' : 'Verify'),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onTap: () {
                        if (otpCodeVisible) {
                          verifyOTP();
                        } else {
                          VerifyNumber();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void VerifyNumber() {
    auth.verifyPhoneNumber(
        phoneNumber: phonenumber.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) {
            print('You are logged in suceessfully');
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationID, int? resentTaken) {
          verificationIDRecived = verificationID;
          otpCodeVisible = true;
          setState(() {});
        },
        codeAutoRetrievalTimeout: (String verificationID) {});
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDRecived, smsCode: OtpCodeController.text);

    await auth.signInWithCredential(credential).then((value) {
      print("You are logged in successfully");
      Fluttertoast.showToast(
          msg: "You are logged in successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
}
