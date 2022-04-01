import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_facebook/pages/sign_up.dart';
import 'package:login_facebook/service/facebook_login.dart';
import '../service/google_sign_in.dart';
import '../service/phone_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final navigatorKey = GlobalKey<NavigatorState>();
  final phonenumber = TextEditingController();
  final OtpCodeController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIDRecived = "";
  bool otpCodeVisible = false;
  @override
  void initState() {
    super.initState();
    email.addListener(onListen);
    password.addListener(onListen);
  }

  @override
  void dispose() {
    super.dispose();
    email.removeListener(onListen);
    password.removeListener(onListen);
  }

  void onListen() => setState(() {});
  bool isPassword = true;
  String userEmail = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Text(
                    'Login ',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: email,
                    decoration: const InputDecoration(
                      label: Text(
                        'Email or phone number',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      hintText: ('Enter your email or phone number'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: password,
                    decoration: const InputDecoration(
                      label: Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      hintText: ('Enter your password'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 170),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forget Password ?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    child: Center(
                      child: Container(
                        height: 50,
                        width: 150,
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(color: Colors.black),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Dont have account yet ?',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()),
                          );
                        },
                        child: const Text(
                          'Create New Account',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: const SizedBox(
                          child: SizedBox(
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                ),
                                radius: 40.0,
                                backgroundImage:
                                    AssetImage('lib/assets/google.png'),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          GoogleSigninService().siginWithGoogle();
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      InkWell(
                        child: const SizedBox(
                          child: SizedBox(
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 45.0,
                                backgroundImage:
                                    AssetImage('lib/assets/facebook.png'),
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          await FacebookLog().signInWithFacebook();
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      InkWell(
                        child: const SizedBox(
                          child: SizedBox(
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage:
                                    AssetImage('lib/assets/phone.jpg'),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PhoneNumberPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
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
