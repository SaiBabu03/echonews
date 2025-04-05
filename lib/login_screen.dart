import 'package:echonews/homescreen.dart';
import 'package:echonews/providers/auth_provider.dart';
import 'package:echonews/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Form Key
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController resetcontroller = TextEditingController();
  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Homescreen()),
      );
    }
  }

  String? _validateEmail(String? value) {
    if(value==null){
      return "Email is required";
    }
    else if(!EmailValidator.validate(value)){
      return "Enter a valid Email";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    } else if (value.length < 8) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SvgPicture.asset(
                  "assets/images/login1.svg",
                  height: size.height * 0.40,
                ),
                Center(
                    child: Text("Sign In",
                        style: GoogleFonts.merriweather(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ))),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Enter E-mail",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    validator: _validateEmail



                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Enter Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
  validator: _validatePassword,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text(
                                'Reset and check your email.',
                                style: TextStyle(fontSize: 18),
                              ),
                              actions: <Widget>[
                                TextField(
                                  controller: resetcontroller,
                                  decoration: const InputDecoration(
                                      hintText: "Enter E-mail",
                                      border: OutlineInputBorder()),
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'Reset');
                                      },
                                      child: const Text('Reset'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
                SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        onPressed: () {
                          authProvider.login(emailcontroller.text, passwordcontroller.text);
                          _login();

                        },
                        child: Text("Sign In",
                            style: GoogleFonts.pacifico(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            )))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign Up to stay informed!',
                      style: GoogleFonts.bebasNeue(color: Colors.black),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SignupScreen()));
                        },
                        child: Text(
                          "Sign up",
                          style: GoogleFonts.bebasNeue(
                              color: const Color(0xFF00A2FD)),
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                          child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      )),
                      Text("or",
                          style: GoogleFonts.oswald(
                            color: Colors.black,
                          )),
                      const Expanded(
                          child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      )),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {},
                        child: Container(
                          constraints:
                              BoxConstraints.tight(const Size.square(63)),
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child: Image.asset(
                            'assets/images/googleicon.png',
                          ),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const FaIcon(
                          FontAwesomeIcons.facebook,
                          color: Color(0xFF006cfa),
                          size: 40,
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
