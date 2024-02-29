import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Post {
  final String text;
  final String username;
  final String planet;

  Post({required this.text, required this.username, required this.planet});
}

class KesifPage extends StatelessWidget {
  final String? username;
  const KesifPage({Key? key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Keşif",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: KesifPageContent(),
    );
  }
}

class KesifPageContent extends StatefulWidget {
  const KesifPageContent({Key? key}) : super(key: key);

  @override
  _KesifPageContentState createState() => _KesifPageContentState();
}

class _KesifPageContentState extends State<KesifPageContent> {
  TextEditingController _inputController = TextEditingController();
  // ignore: unused_field
  String? _storedUsername;

  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    // JSON API'dan verileri almak için bir fonksiyonu çağırın
    _fetchData();
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
    String? storedUsername = prefs.getString('username');

    var url = Uri.parse('http://192.168.1.111/colony/kesifget.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      dynamic jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        List<dynamic> data = jsonData['data'];
        setState(() {
          posts = data
              .map((item) => Post(
                    text: item['kesif_metin'],
                    username: item['kesif_username'],
                    planet: item['planet'],
                  ))
              .toList();
        });
      } else {
        print('Veri alınamadı: ${jsonData['message']}');
      }
    } else {
      print('İstek başarısız: ${response.reasonPhrase}');
    }
  }

  Future<void> _sendRequest(String inputValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    var url = Uri.parse('http://192.168.1.111/colony/kesifpost.php');
    var body =
        jsonEncode({'inputValue': inputValue, 'username': storedUsername});

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['success']) {
        print('Başarılı istek');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veri başarıyla gönderildi'),
          ),
        );
        // Sayfayı yenilemek için setState kullanabiliriz
        setState(() {
          _fetchData(); // Verileri yeniden çekmek için _fetchData() fonksiyonunu çağırın
        });
      } else {
        print('İstek başarısız: ${responseData['message']}');
      }
    } else {
      print('İstek başarısız: ${response.reasonPhrase}');
    }
  }

  Future<void> _refreshData() async {
    // Yeniden veri almak için _fetchData() fonksiyonunu çağırın
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Column(
        children: [
          const SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _inputController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Düşünceni Paylaş",
                    labelStyle: TextStyle(color: Colors.white70),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white70, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white70, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen boş bırakmayınız.';
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  String inputValue = _inputController.text;
                  _sendRequest(inputValue);
                },
                icon: const Icon(
                  Icons.send, // Change this to the desired icon
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return _gonderiKutusu(posts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _gonderiKutusu(Post post) {
    // JSON API'dan gelen 'planet' değerine göre resmi seç
    AssetImage image;
    switch (post.planet) {
      case 'Merkür':
        image = const AssetImage("assets/kesifimage/mercury.png");
        break;
      case 'Venüs':
        image = const AssetImage("assets/kesifimage/venus.png");
        break;
      case 'Dünya':
        image = const AssetImage("assets/kesifimage/earth.png");
        break;
      case 'Mars':
        image = const AssetImage("assets/kesifimage/mars.png");
        break;
      case 'Jüpiter':
        image = const AssetImage("assets/kesifimage/jupiter.png");
        break;
      case 'Satürn':
        image = const AssetImage("assets/kesifimage/saturn.png");
        break;
      case 'Uranüs':
        image = const AssetImage("assets/kesifimage/uranus.png");
        break;
      case 'Neptün':
        image = const AssetImage("assets/kesifimage/neptune.png");
        break;
      default:
        image = const AssetImage("assets/kesifimage/default.png");
    }

    return Container(
      margin: const EdgeInsets.all(10),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white70,
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: image,
              fit: BoxFit.contain,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 10,
                child: Text(post.text),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Row(
                  children: [
                    Text(
                      "@${post.username}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      " • ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      post.planet,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
