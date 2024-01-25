import 'package:flutter/material.dart';
import 'package:loginapp/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nomController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign up user
  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password do no match"),
        ),
      );
      return;
    }
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailandPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue.shade500, Colors.green.shade700],
                    ),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)),
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.white, width: 5)),
                      child: const Icon(
                        Icons.done,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),
                    //Create account message
                    const Text(
                      "Let's create an account for you !",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      height: 100,
                      width: 350,
                      child: MyTextField(
                        controller: nomController,
                        hintText: 'Nom',
                        obscureText: false,
                      ),
                    ),
                    //email textfield
                    SizedBox(
                      height: 100,
                      width: 350,
                      child: MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),
                    ),

                    const SizedBox(height: 0),
                    //password
                    SizedBox(
                      height: 100,
                      width: 350,
                      child: MyTextField(
                        controller: passwordController,
                        hintText: 'password',
                        obscureText: true,
                      ),
                    ),

                    //confirm password textfield
                    SizedBox(
                      height: 100,
                      width: 350,
                      child: MyTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm password',
                        obscureText: true,
                      ),
                    ),

                    const SizedBox(height: 0),
                    // sign in button
                    MyButton(
                      onTap: signUp,
                      text: "S'INSCRIRE",
                    ),

                    const SizedBox(height: 10),

                    // not a nember register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Déjà membre?',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Connectez-vous',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
