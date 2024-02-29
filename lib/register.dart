import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _index = 0;

  String _selectedPlanet = '';

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  List<String> planets = [
    'Merkür',
    'Venüs',
    'Dünya',
    'Mars',
    'Jüpiter',
    'Satürn',
    'Uranüs',
    'Neptün'
  ];

  Map<String, String> planetImages = {
    'Merkür': 'assets/planets/mercury-3d.gif',
    'Venüs': 'assets/planets/venus-3d.gif',
    'Dünya': 'assets/planets/earth-3d.gif',
    'Mars': 'assets/planets/mars-3d.gif',
    'Jüpiter': 'assets/planets/jupiter-3d.gif',
    'Satürn': 'assets/planets/saturn-3d.gif',
    'Uranüs': 'assets/planets/uranus-3d.gif',
    'Neptün': 'assets/planets/neptune-3d.gif'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white70, //change your color here
        ),
        backgroundColor: Colors.black,
        title: const Text('Kayıt Ol', style: TextStyle(color: Colors.white70)),
      ),
      body: Theme(
        data: ThemeData(
          canvasColor: Colors.black,
          primarySwatch: Colors.orange,
          colorScheme: const ColorScheme.dark(
            primary: Color.fromARGB(255, 45, 45, 45),
            secondary: Colors.blue,
          ),
        ),
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _index,
          onStepCancel: () {
            if (_index > 0) {
              setState(() {
                _index -= 1;
              });
            }
          },
          onStepContinue: () {
            if (_index == 0) {
              if (_formKey1.currentState!.validate()) {
                setState(() {
                  _index += 1;
                });
              }
            } else if (_index == 1) {
              if (_formKey2.currentState!.validate()) {
                setState(() {
                  _index += 1;
                });
              }
            } else if (_index == 2) {
              _submit();
            }
          },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Eğer şu anki adım 0'dan büyükse geri butonu görünsün
                  MaterialButton(
                    // ignore: prefer_if_null_operators
                    onPressed: details.onStepCancel != null
                        ? details.onStepCancel
                        : null, // Null olmasını sağla
                    minWidth: 100,
                    height: 50,
                    disabledTextColor: Colors.red,
                    disabledColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: Colors.white70),
                    ),
                    child: const Text(
                      'Geri',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  if (_index < 1) // Son adımda değilse ileri butonu göster
                    MaterialButton(
                      onPressed: details.onStepContinue,
                      minWidth: 100,
                      height: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: Colors.white70),
                      ),
                      child: const Text(
                        'İleri',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  if (_index >= 1) // Son adımdaysa Kayıt Ol butonu göster
                    MaterialButton(
                      onPressed: _submit,
                      minWidth: 100,
                      height: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: Colors.white70),
                      ),
                      child: const Text(
                        'Kayıt Ol',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          steps: <Step>[
            Step(
              state: _index > 0 ? StepState.complete : StepState.indexed,
              isActive: _index >= 0,
              title: const Text('Kişisel Bilgiler',
                  style: TextStyle(color: Colors.white70)),
              content: Form(
                key: _formKey1,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: "Kullanıcı Adınız",
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
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _nameController,
                      
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: "Adınız",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                    
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen adınızı girin.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _surnameController,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: "Soyadınız",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen soyadınızı girin.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: "E-Posta",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen E-Posta adresinizi girin.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: "Şifreniz",
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
                  ],
                ),
              ),
            ),
            Step(
              state: _index > 1 ? StepState.complete : StepState.indexed,
              isActive: _index >= 1,
              title: const Text('Colony Tercihi',
                  style: TextStyle(color: Colors.white70)),
              content: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 400,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _selectedPlanet = planets[index];
                        });
                      },
                    ),
                    items: planets.map((planet) {
                      return Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPlanet = planet;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selectedPlanet == planet
                                      ? Colors.white70
                                      : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    planetImages[planet]!,
                                    width: 300,
                                    height: 300,
                                  ),
                                  Text(
                                    planet.toUpperCase(),
                                    style: GoogleFonts.spaceMono(
                                      textStyle:
                                          const TextStyle(color: Colors.white70),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey1.currentState != null && _formKey1.currentState!.validate()) {
      // Collect form data
      final formData = {
        'username': _usernameController.text,
        'name': _nameController.text,
        'surname': _surnameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'selectedPlanet': _selectedPlanet,
      };

      // Create a client instance (optional, reuse for multiple requests)
      final client = http.Client();

      try {
        // Make HTTP POST request
        final uri = Uri.http('192.168.1.111', '/colony/register.php');
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
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 55, 55, 55),
                  title: const Text('Kayıt Başarılı',
                      style: TextStyle(color: Colors.white70)),
                  content: const Text('Kaydınız başarıyla tamamlandı.',
                      style: TextStyle(color: Colors.white70)),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        // Navigate to login page
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text('Tamam',
                          style: TextStyle(color: Colors.white70)),
                    ),
                  ],
                );
              },
            );
          } else {
            // Registration failed, show error message
            // ignore: use_build_context_synchronously
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 55, 55, 55),
                  title: const Text('Hata', style: TextStyle(color: Colors.white70)),
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
                title: const Text('Hata', style: TextStyle(color: Colors.white70)),
                content: const Text('Kayıt Olurken Hata Oluştu!',
                    style: TextStyle(color: Colors.white70)),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        const Text('Tamam', style: TextStyle(color: Colors.white70)),
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
                title: const Text('Hata', style: TextStyle(color: Colors.white70)),
                content: const Text('Hata Oluştu!',
                    style: TextStyle(color: Colors.white70)),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        const Text('Tamam', style: TextStyle(color: Colors.white70)),
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
}
