import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/config/utils/animation.dart';
import 'package:flutter_top_receit/config/utils/text_utils.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_top_receit/presentation/functions/backgraund_sharedPref.dart';
import 'package:flutter_top_receit/presentation/widgets/data/bg_data.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int selectedIndex = 0;
  bool showOption = false;
  bool _obscureText = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? currentBackground;

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
  }

  Future<void> _loadBackgroundImage() async {
    final prefs = PreferencesService();
    final bgImage = await prefs.getBackgroundImage();
    setState(() {
      currentBackground = bgImage ?? bgList[0];
      selectedIndex = bgList.indexOf(currentBackground!);
    });
  }

  Future<void> _saveBackgroundImage(String bgImage) async {
    final prefs = PreferencesService();
    await prefs.saveBackgroundImage(bgImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 49,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: showOption
                  ? ShowUpAnimation(
                      delay: 100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: bgList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                currentBackground = bgList[index];
                              });
                              _saveBackgroundImage(bgList[index]);
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: selectedIndex == index
                                  ? Colors.white
                                  : Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(
                                    bgList[index],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(width: 20),
            showOption
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        showOption = false;
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        showOption = true;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(bgList[selectedIndex]),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          } else if (state.email != null && state.email != "NO_USER") {
            context.go('/home', extra: state.email);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(currentBackground ?? bgList[0]),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              height: 400,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(15),
                color: Colors.black.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Center(
                            child: TextUtil(
                                text: "Login", weight: true, size: 30)),
                        const Spacer(),
                        TextUtil(text: "Email"),
                        Container(
                          height: 35,
                          decoration: const BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.white)),
                          ),
                          child: TextFormField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.mail, color: Colors.white),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const Spacer(),
                        TextUtil(text: "Password"),
                        Container(
                          height: 35,
                          decoration: const BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.white)),
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                            obscureText: _obscureText,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            context.read<AuthBloc>().add(
                                  SignInEvent(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ),
                                );
                          },
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child:
                                TextUtil(text: "Log In", color: Colors.black),
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              print("REGISTER");
                              context.go('/login/register');
                            },
                            child: TextUtil(
                                text: "Don't have an account? REGISTER",
                                size: 12,
                                weight: true),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
