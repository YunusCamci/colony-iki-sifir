import 'package:colonyikisifir/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
  }

  // Oturumun açık olup olmadığını kontrol eder
  void _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    String? savedPassword = prefs.getString('password');

    // ignore: unrelated_type_equality_checks
    if (_login != true) {
      if (savedUsername != null && savedPassword != null) {
        _yonlendirme();
      }
    }
  }

  // Giriş yapar
  void _login() async {
    // ignore: unused_local_variable
    final formData = {
      'username': _usernameController.text,
      'password': _passwordController.text
    };

    // ignore: unused_local_variable
    final client = http.Client();

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // Collect form data
      final formData = {
        'username': _usernameController.text,
        'password': _passwordController.text,
      };

      // Create a client instance (optional, reuse for multiple requests)
      final client = http.Client();

      try {
        // Make HTTP POST request
        final uri = Uri.http('192.168.1.111', '/colony/login.php');
        final response = await client.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(formData),
        );

        // Check if request was successful (status code 200)
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          if (jsonResponse['success']) {
            // Registration successful, show alert
            // ignore: use_build_context_synchronously


            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('username', _usernameController.text);
            await prefs.setString('password', _passwordController.text);
            _yonlendirme();

          } else {
            // Registration failed, show error message
            // ignore: use_build_context_synchronously
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 55, 55, 55),
                  title: const Text('Hata',
                      style: TextStyle(color: Colors.white70)),
                  content: Text(jsonResponse['message'],
                      style: const TextStyle(color: Colors.white70)),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Tamam',
                          style: TextStyle(color: Colors.white70)),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          // Registration failed, handle error if needed
          //print('Failed to register. Status code: ${response.statusCode}');
          //print('Response: ${response.body}');
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 55, 55, 55),
                title:
                    const Text('Hata', style: TextStyle(color: Colors.white70)),
                content: const Text('Kayıt Olurken Hata Oluştu!',
                    style: TextStyle(color: Colors.white70)),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Tamam',
                        style: TextStyle(color: Colors.white70)),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        // Exception occurred, handle error if needed
        //print('Error occurred: $e');
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 55, 55, 55),
              title:
                  const Text('Hata', style: TextStyle(color: Colors.white70)),
              content: const Text('Hata Oluştu!',
                  style: TextStyle(color: Colors.white70)),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Tamam',
                      style: TextStyle(color: Colors.white70)),
                ),
              ],
            );
          },
        );
      } finally {
        // Close the client if necessary (optional)
        client.close();
      }
    }
  }

  void _yonlendirme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

// ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage(username: username)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login-background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Giriş',
                  style: GoogleFonts.spaceMono(
                    textStyle: TextStyle(color: Colors.white70),
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: "Kullanıcı Adı",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen kullanıcı adınızı girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: "Şifre",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen şifrenizi girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!
                            .save(); // Form bilgilerini kaydet
                        _login(); // Giriş yap
                      }
                    },
                    color: Colors.black,
                    // Buton rengi
                    textColor: Colors.white, // Buton metin rengi
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Border radiusu
                      side: const BorderSide(
                          color: Colors.white70), // Border rengi
                    ),
                    child: const Text('Giriş'),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    // Kayıt sayfasına geçiş yap
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: const Text(
                    "Kayıt Ol",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
