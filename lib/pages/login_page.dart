import 'package:flutter/material.dart';
import 'package:loginapp/components/my_button.dart';
import 'package:loginapp/components/my_text_field.dart';
import 'package:loginapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign in user
  signIn() async {
    // get the auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailandPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
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
                    //welcom back message

                    const Text(
                      "CONNEXION A SIR-TechApp",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 35),
                    //email textfield
                    SizedBox(
                      height: 100,
                      width: 350,
                      child: MyTextField(
                        controller: emailController,
                        hintText: 'Exemple@gmail.com',
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
                        hintText: 'Entrez votre password',
                        obscureText: true,
                      ),
                    ),

                    const SizedBox(height: 20),
                    // sign in button
                    MyButton(
                      onTap: signIn,
                      text: "SE CONNECTER",
                    ),

                    const SizedBox(height: 100),

                    // not a nomber register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Vous êtes pas membre ?",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Inscrive-vous',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
