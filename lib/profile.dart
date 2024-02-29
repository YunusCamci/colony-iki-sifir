import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  final String? username; // username should be a String

  const ProfilePage({Key? key, this.username}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  String? _storedUsername;

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _storedUsername = prefs.getString('username');

    if (_storedUsername != null) {
      // URL'yi username ile değiştir
      final String url =
          'http://192.168.1.111/colony/userlist.php?username=$_storedUsername';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        try {
          setState(() {
            userData = jsonDecode(response.body);
          });
        } on FormatException catch (e) {
          // Handle parsing error here, e.g., display an error message
          print("Error parsing JSON: ${e.message}");
        }
      } else {
        // Handle other errors based on status code
      }
    } else {
      // Handle the case where the username is not found in Shared Preferences
      print("Username not found in Shared Preferences");
    }
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Oturum kapatıldığını bildir
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Oturum kapatıldı'),
        padding: EdgeInsets.all(10.0),
      ),
    );

    // Giriş sayfasına yönlendir
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Profil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: userData != null
          ? Container(
              child: Center(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: <Widget>[
                    const SizedBox(height: 150),
                    Center(
                      child: Text(
                        '${userData!['name']} ${userData!['surname']}',
                        style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(color: Colors.white70),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '@${userData!['username']}',
                        style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(color: Colors.white70),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.settings,
                          color: Colors.white70,
                        ),
                        title: Text(
                          'Ayarlar',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Profil Düzenle',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : _storedUsername != null
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Loading indicator while fetching data
              : const Center(
                  child: Text(
                      'Username not found'), // Show message if username not found
                ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data on first build
  }
}
