import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garsonapp/apiler/giris_yap.dart';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart'; //

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({Key? key}) : super(key: key);

  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  //Kullanıcı Adı ve Parola bu controllerler ile textFieldlerden alınıyor <-------Başladı-------
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  String kullaniciAdi = "";
  String parola = "";
  //Kullanıcı Adı ve Parola bu controllerler ile textFieldlerden alınıyor  -------Bitti------->
  //IP Adresi bu controller ile textFielddan alınıyor <-------Başladı-------
  TextEditingController controllerIp = TextEditingController();
  String secilenIp = "";
  //IP Adresi bu controller ile textFieldlerden alınıyor -------Bitti------->
  String apiUrl = ""; //Login Api url
  bool isChecked =
      false; //Kullanıcı Adı ve Parola girildiğinde buton rengi değişir
  bool secilenOturum = false;
  bool sesDurumu = true;

  Color butonColor = Colors.white;
  Color butonYaziRengi = Colors.black;
  bool titresimDurumu = true;

  void sesCal() {
    if (sesDurumu == true) {
      final player = AudioPlayer();
      player.play(AssetSource('pokemon-a-button.wav'));
      titresimCal();
    }
  }

  void titresimCal() async {
    // Telefonun titreşim özelliğinin bulunup bulunmadığını kontrol et
    bool? hasVibrator = await Vibration.hasVibrator();

    // hasVibrator değeri null değilse ve true ise, titreşimi başlat
    if ((hasVibrator == true) && (titresimDurumu == true)) {
      Vibration.vibrate(duration: 75);
    }
  }

  /*  
    ! Kullanıcı Adı , Şifre , Ip Adresleri ve Oturum Açma Seçeneği Telefona Kaydediliyor. <-------Başladı-------
  */

  Future<void> _kaydetKullaniciAdi(String kullaniciAdi) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('kullaniciAdi', kullaniciAdi);
    kullaniciAdi = prefs.getString('kullaniciAdi') ?? "";
  }

  Future<void> _kaydetParola(String parola) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('parola', parola);
    parola = prefs.getString('parola') ?? "";
  }

  Future<void> _kaydetSecilenIp(String secilenIp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('secilenIp', secilenIp);
    secilenIp = prefs.getString('secilenIp') ?? "192.168.1.100";
    // Default IP Adresi : 192.168.1.100
  }

  Future<void> _kaydetSecilenOturum(bool secilenOturum) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('secilenOturum', secilenOturum);
    secilenOturum = prefs.getBool('secilenOturum') ?? false;
  }

  /*  
    ! Kullanıcı Adı , Şifre ve Ip Adresleri Telefona Kaydediliyor. -------Bitti------->
  */

  /*  
    ! Kullanıcı Adı , Şifre , Ip Adresleri ve Oturum Açma Seçeneği Telefondan Getiriliyor. <-------Başladı-------
  */

  Future<void> _getirKullaniciAdi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kullaniciAdi = prefs.getString('kullaniciAdi') ?? "";
    controller.text = kullaniciAdi;
    _getirParola();
  }

  Future<void> _getirParola() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    parola = prefs.getString('parola') ?? "";
    controller2.text = parola;
    _getirSecilenOturum();
  }

  Future<void> _getirSecilenIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    secilenIp = prefs.getString('secilenIp') ?? "192.168.1.100";
    apiUrl = "http://${secilenIp}:8080/login";
    // Default IP Adresi : 192.168.1.100
    _getirKullaniciAdi();
  }

  Future<void> _getirSecilenOturum() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    secilenOturum = prefs.getBool('secilenOturum') ?? false;
    if (secilenOturum == true) {
      _login();
    }
  }

  /*  
    ! Kullanıcı Adı , Şifre , Ip Adresleri ve Oturum Açma Seçeneği Telefondan Getiriliyor. -------Bitti------->
  */

  /*  
    ? Login Api. -------Başladı------->
  */

  Future<void> _login() async {
    await GirisYap.login(context, controller, controller2, apiUrl);
  }

  /*  
    ? Login Api. <-------Bitti-------
  */

  /*  
    TODO: IP Giriş Alerti. <-------Başladı-------
  */

  Future<void> _ipGirisEkrani(BuildContext context, double ekranGenisligi,
      double ekranYuksekligi) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.80),
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: arkaPlanRengi, width: 2.0),
          ),
          backgroundColor: alertArkaPlanRengi,
          title: Text(
            'Ip Giriş Ekranı',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: (ekranYuksekligi / 100) * 2.5),
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Divider(color: Colors.white),
                SizedBox(height: (ekranYuksekligi / 100) * 2.0),
                SizedBox(
                  width: (ekranGenisligi / 100) * 80,
                  height: (ekranYuksekligi / 100) * 10,
                  child: TextField(
                    style: TextStyle(fontSize: (ekranYuksekligi / 100) * 2.5),
                    onChanged: (value) {
                      setState(
                        () {},
                      );
                    },
                    controller: controllerIp,
                    decoration: InputDecoration(
                      hintText: "192.168.1.100",
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: (ekranYuksekligi / 100) * 2.0),
                //Ip Kaydet Butonu -----------------------------------
                GestureDetector(
                  onTap: () {
                    final String seciliIpAdresi = controllerIp.text;
                    _kaydetSecilenIp(seciliIpAdresi);
                    _getirSecilenIp();
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: (ekranGenisligi / 100) * 40, // Genişlik değeri
                    height: (ekranYuksekligi / 100) * 6,
                    decoration: BoxDecoration(
                        color: butonColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "Kaydet",
                      style: TextStyle(
                          color: butonYaziRengi,
                          fontWeight: FontWeight.bold,
                          fontSize: (ekranYuksekligi / 100) * 2.5),
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

  /*  
    TODO: IP Giriş Alerti. -------Bitti------->
  */

  @override
  void initState() {
    _getirSecilenIp();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isFilled1 = controller.text.isNotEmpty;
    bool isFilled2 = controller2.text.isNotEmpty;
    double ekranGenisligi =
        MediaQuery.of(context).size.width; // Ekran genişliğini al
    double ekranYuksekligi =
        MediaQuery.of(context).size.height; // Ekran yüksekliğini al

    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında giriş sayfasına yönlendir
        SystemNavigator.pop();
        // Geri tuşunun işlenmesini durdur
        return false;
      },
      child: Scaffold(
        backgroundColor: girisEkraniArkaPlanRengi, //girisEkraniArkaPlanRengi
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _ipGirisEkrani(context, ekranGenisligi, ekranYuksekligi);
          }, // Butona basıldığında sayaçı artır
          tooltip: 'Artır',
          backgroundColor: Colors.white,
          mini: true,
          child: const Icon(Icons.network_wifi_2_bar_sharp),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: (ekranYuksekligi / 100) * 5,
                ),
                Image.asset('assets/garson_logo.png',
                    height: (ekranYuksekligi / 100) * 35),
                SizedBox(
                  height: (ekranYuksekligi / 100) * 2.5,
                ),
                SizedBox(
                  width: (ekranGenisligi / 100) * 85,
                  height: (ekranYuksekligi / 100) * 10,
                  child: TextField(
                    style: TextStyle(fontSize: (ekranYuksekligi / 100) * 2.5),
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
                SizedBox(
                  height: (ekranYuksekligi / 100) * 1.5,
                ),
                SizedBox(
                  width: (ekranGenisligi / 100) * 85,
                  height: (ekranYuksekligi / 100) * 10,
                  child: TextField(
                    controller: controller2,
                    style: TextStyle(fontSize: (ekranYuksekligi / 100) * 2.5),
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
                SizedBox(
                  height: (ekranYuksekligi / 100) * 1.5,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Oturumu Açık Tut: ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: (ekranYuksekligi / 100) * 2.5),
                      ),
                      Checkbox(
                          activeColor: Colors.green,
                          value: secilenOturum,
                          onChanged: (bool? value) {
                            setState(() {
                              sesCal();
                              if (value == true) {
                                secilenOturum = true;
                              } else if (value == false) {
                                secilenOturum = false;
                              }
                              // secilenOturum = value;
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
                SizedBox(
                  height: (ekranYuksekligi / 100) * 2.5,
                ),
                GestureDetector(
                  onTap: () {
                    sesCal();

                    _login();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: (ekranGenisligi / 100) * 40, // Genişlik değeri
                    height: (ekranYuksekligi / 100) * 6,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      color: butonColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Giriş Yap",
                      style: TextStyle(
                          color: butonYaziRengi,
                          fontWeight: FontWeight.bold,
                          fontSize: (ekranYuksekligi / 100) * 2.5),
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
