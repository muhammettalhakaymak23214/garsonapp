import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garsonapp/apiler/giris_yap.dart';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({Key? key}) : super(key: key);

  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controllerIp = TextEditingController();
  String kullaniciAdi = "";
  String parola = "";
  String secilenIp = "";
  String apiUrl = "";
  String apiUrlMasaGetir = "";
  String apiUrlMenuGetir = "";
  bool isChecked = false;
  bool secilenOturum = false;
  Color butonColor = Colors.white;
  Color butonYaziRengi = Colors.black;

  Future<void> _kaydetSecilenIp(String secilenIp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('secilenIp', secilenIp);
    secilenIp = prefs.getString('secilenIp') ?? "100";
  }

  Future<void> _getirSecilenIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    secilenIp = prefs.getString('secilenIp') ?? "100";
    apiUrl = "http://192.168.1.${secilenIp}:8080/login";
    apiUrlMasaGetir = 'http://192.168.1.${secilenIp}:8080/tables';
    apiUrlMenuGetir = 'http://192.168.1.${secilenIp}:8080/categories';

    if (secilenIp != "100") {
      _getirKullaniciAdi();
    }
  }

  Future<void> _kaydetKullaniciAdi(String kullaniciAdi) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('kullaniciAdi', kullaniciAdi);
    kullaniciAdi = prefs.getString('kullaniciAdi') ?? "";
  }

  Future<void> _getirKullaniciAdi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kullaniciAdi = prefs.getString('kullaniciAdi') ?? "";
    controller.text = kullaniciAdi;
    _getirParola();
  }

  Future<void> _kaydetParola(String parola) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('parola', parola);
    parola = prefs.getString('parola') ?? "";
  }

  Future<void> _getirParola() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    parola = prefs.getString('parola') ?? "";
    controller2.text = parola;
    _getirSecilenOturum();
  }

  Future<void> _kaydetSecilenOturum(bool secilenOturum) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('secilenOturum', secilenOturum);
    secilenOturum = prefs.getBool('secilenOturum') ?? false;
  }

  Future<void> _getirSecilenOturum() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    secilenOturum = prefs.getBool('secilenOturum') ?? false;
    if (secilenOturum == true) {
      debugPrint("girdigiddsgfdgfdgggggggggggggggggggggggggggg");

      _login();
    }
  }

  Future<void> _login() async {
    await GirisYap.login(context, controller, controller2, apiUrl);
  }

  Future<void> _ipGirisEkrani(BuildContext context) async {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Color.fromARGB(255, 0, 0, 0).withOpacity(0.80),
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: arkaPlanRengi, width: 2.0),
          ),
          backgroundColor: Colors.black,
          title: Text(
            'Ip Giriş Ekranı',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: (screenHeight / 100) * 3),
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Divider(color: Colors.white),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    setState(
                      () {},
                    );
                  },
                  controller: controllerIp,
                  decoration: InputDecoration(
                    hintText: "Ip adresinin son 3 basamağı",
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final String seciliIpAdresi = controllerIp.text;
                    _kaydetSecilenIp(seciliIpAdresi);

                    _getirSecilenIp();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: butonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Container(
                    width: 150, // Genişlik değeri
                    height: 50, // Yükseklik değeri
                    child: Center(
                      child: Text(
                        "Kaydet",
                        style: TextStyle(
                            color: butonYaziRengi,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _getirSecilenIp();
    // TODO: implement initState
    super.initState();
  }

//_istatistikler(context);
  @override
  Widget build(BuildContext context) {
    bool isFilled1 = controller.text.isNotEmpty;
    bool isFilled2 = controller2.text.isNotEmpty;

    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında giriş sayfasına yönlendir
        SystemNavigator.pop();
        // Geri tuşunun işlenmesini durdur
        return false;
      },
      child: Scaffold(
        backgroundColor: girisEkraniArkaPlanRengi,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _ipGirisEkrani(context);
          }, // Butona basıldığında sayaçı artır
          tooltip: 'Artır',
          child: Icon(Icons.network_wifi_2_bar_sharp),
          backgroundColor: Colors.white,
          mini: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Image.asset('assets/garson_logo.png', height: 300),
                SizedBox(
                  width: 350,
                  child: TextField(
                    onChanged: (value) {
                      setState(
                        () {
                          butonColor = isFilled1 && isFilled2
                              ? yesilButonRengi
                              : beyazButonRengi;
                          butonYaziRengi = isFilled1 && isFilled2
                              ? beyazYaziRengi
                              : siyahYaziRengi;
                        },
                      );
                    },
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Kullanıcı Adı",
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: controller2,
                    onChanged: (value) {
                      setState(
                        () {
                          butonColor = isFilled1 && isFilled2
                              ? yesilButonRengi
                              : beyazButonRengi;
                          butonYaziRengi = isFilled1 && isFilled2
                              ? beyazYaziRengi
                              : siyahYaziRengi;
                        },
                      );
                    },
                    decoration: InputDecoration(
                      hintText: "Parola",
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Oturumu Açık Tut",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Checkbox(
                          activeColor: Colors.green,
                          value: secilenOturum,
                          onChanged: (bool? value) {
                            setState(() {
                              secilenOturum = value!;
                              _kaydetSecilenOturum(secilenOturum);

                              if (secilenOturum == true) {
                                _kaydetKullaniciAdi(controller.text);
                                _kaydetParola(controller2.text);
                              }
                            });
                          }),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 200,
                ),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  onPressed: _login,

                  ///butonColor == yesilButonRengi ? _login : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: butonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Container(
                    width: 150, // Genişlik değeri
                    height: 50, // Yükseklik değeri

                    child: Center(
                      child: Text(
                        "Giriş Yap",
                        style: TextStyle(
                            color: butonYaziRengi,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
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
