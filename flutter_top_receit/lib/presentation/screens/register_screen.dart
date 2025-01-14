import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/config/utils/text_utils.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_top_receit/presentation/functions/valodators_function.dart';
import 'package:flutter_top_receit/presentation/widgets/data/bg_data.dart';
import 'package:flutter_top_receit/presentation/functions/backgraund_sharedPref.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController avatarController = TextEditingController();
  final TextEditingController preferencesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? currentBackground;
  bool _obscureText = true;
  bool _obscureConfirmText = true;
  String? selectedPreference;

  final List<String> preferences = [
    'Carne',
    'Pescado',
    'Verduras',
    'Dulce',
    'Salado',
  ];

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        child: Container(
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
            height: 600,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Center(
                            child: TextUtil(
                                text: "Register", weight: true, size: 30)),
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
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'El email es obligatorio';
                              }
                              if (!isEmailValid(value)) {
                                return 'El correo electrónico no es válido';
                              }
                              final isEmailUsed = authBloc.state.isEmailUsed;
                              if (isEmailUsed != null && isEmailUsed) {
                                return 'El email ya está en uso.';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Spacer(),
                        TextUtil(text: "Username"),
                        Container(
                          height: 35,
                          decoration: const BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.white)),
                          ),
                          child: TextFormField(
                            controller: usernameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              suffixIcon:
                                  Icon(Icons.person, color: Colors.white),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'El nombre es obligatorio';
                              }
                              final isNameUsed = authBloc.state.isNameUsed;
                              if (isNameUsed != null && isNameUsed) {
                                return 'El nombre ya está en uso.';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Spacer(),
                        TextUtil(text: "Preferences"),
                        // Dropdown selector
                        DropdownButtonFormField<String>(
                          value: selectedPreference,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.white),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                          items: preferences
                              .map((preference) => DropdownMenuItem<String>(
                                    value: preference,
                                    child: Text(preference),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPreference = value;
                              preferencesController.text = value ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a preference';
                            }
                            return null;
                          },
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'La contraseña es obligatoria';
                              }
                              if (value.length < 8) {
                                return 'La contraseña debe tener al menos 8 caracteres';
                              }
                              if (!hasNumber(value)) {
                                return 'La contraseña debe contener al menos un número';
                              }
                              if (!hasUppercaseLetter(value)) {
                                return 'La contraseña debe contener al menos una letra mayúscula';
                              }
                              if (!hasLowercaseLetter(value)) {
                                return 'La contraseña debe contener al menos una letra minúscula';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Spacer(),
                        TextUtil(text: "Confirm Password"),
                        Container(
                          height: 35,
                          decoration: const BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.white)),
                          ),
                          child: TextFormField(
                            controller: confirmPasswordController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmText = !_obscureConfirmText;
                                  });
                                },
                              ),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                            obscureText: _obscureConfirmText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<AuthBloc>().add(
                                    SignUpEvent(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      username: usernameController.text,
                                      avatar: avatarController.text,
                                      preferences:
                                          preferencesController.text.split(','),
                                    ),
                                  );
                              context.go('/login');
                            }
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
                                TextUtil(text: "Register", color: Colors.black),
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              context.go('/login');
                            },
                            child: TextUtil(
                                text: "Already have an account? Login",
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
          ),
        ),
      ),
    );
  }
}
