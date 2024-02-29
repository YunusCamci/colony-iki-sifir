import 'package:colonyikisifir/iss.dart';
import 'package:colonyikisifir/kesif.dart';
import 'package:colonyikisifir/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String? username; // username değişkeni String türünde olmalıdır

  const HomePage({Key? key, this.username}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    // Sayfalarınızı buraya ekleyin
    HomeScreen(),
    ISSPage(),
    KesifPage(),
    ProfilePage(),
  ];

  void _handleTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: GNav(
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Color.fromRGBO(66, 66, 66, 1),
          gap: 8,
          padding: EdgeInsets.all(10),
          iconSize: 24,
          selectedIndex: _selectedIndex,
          onTabChange: _handleTabChange,
          tabs: const [
            GButton(
              icon: Icons.home_filled,
              text: 'Anasayfa',
            ),
            GButton(
              icon: Icons.satellite_alt_outlined,
              text: 'IIS',
            ),
            GButton(
              icon: Icons.search,
              text: 'Keşif',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profil',
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  List<String> imageUrls = [];
  List<String> textData = [];

  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _pageController.addListener(() => setState(() {}));
  }

  Future<void> _fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.111/colony/newslist.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        for (var item in data) {
          // Her bir öğe için resim ve metin değerlerini alabilirsiniz
          imageUrls.add(item['resim']);
          textData.add(item['metin']);
        }
      });
      print(imageUrls);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Colony 2.0",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
          ),
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              _currentIndex = index;
              return Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.zero,
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                    ),
                    child: Image.network(
                      "${imageUrls[index]}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 20.0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _displayBottomSheet(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                        ),
                        child: const Text("Devamını Oku"),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future _displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              textData[_currentIndex],
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
