import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() {
  runApp(const MaterialApp(
    home: FirstScreen(),
  ));
}

class Connexion extends StatefulWidget {
  const Connexion({Key? key}) : super(key: key);

  @override
  State<Connexion> createState() => _ConnexionState();
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  TextEditingController textController = TextEditingController();
  String? _deviceIdMatricule;
  String? _deviceId2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 600,
              height: 700,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/Splash_screen.PNG"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.red; // Use the component's default.
                    },
                  ),
                ),
                onPressed: () {
                  _getId();
                },
                child: const Text('Connexion')
            ),

          ],
        ),
      ),
    );
  }
  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    String? deviceId;

    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = await iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = await androidDeviceInfo.androidId; // unique ID on Android
    }
    setState(() => _deviceId2 = deviceId);
  }
}

class _ConnexionState extends State<Connexion> {
  TextEditingController textController = TextEditingController();
  String? _deviceIdMatricule;
  String? _deviceId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 43, 43, 1),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Bienvenu !'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              style: TextStyle(color: Colors.white),
              controller: textController,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                    color: Colors.white
                ),
                labelText: 'Première connexion ? Entrer votre matricule :',
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.red;
                      return Colors.red; // Use the component's default.
                    },
                  ),
                ),
                onPressed: () {
                  _getId();
                },
                child: const Text('Go !')
            ),

          ],
        ),
      ),
    );
  }
  Future<List> getData(maReq, maData) async {
    final url = Uri.parse('http://fdvrbi.000webhostapp.com/SelectTest.php')
        .replace(queryParameters: {
      'req': maReq,
      'data': maData,
    });
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    return data;
  }



  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    String? deviceId;

    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = await iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = await androidDeviceInfo.androidId; // unique ID on Android
    }
    List ListIdPhone = (await getData("SELECT DISTINCT id_tel FROM users", 'id_tel'));
    setState(() => _deviceId = deviceId);

    if(ListIdPhone.contains(deviceId)) {
      String matric = (await getData("SELECT DISTINCT matricule FROM users WHERE id_tel='$deviceId'", 'matricule')).first.replaceAll('"', '');
      setState(() => _deviceIdMatricule = matric);
      Navigator.push(
        this.context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      insertUser();
    }
  }

  Future insertUser() async {
    String monMatricule = textController.text;
    if(monMatricule!='' && monMatricule.length==7) {
      final url = Uri.parse('http://fdvrbi.000webhostapp.com/insert.php')
          .replace(queryParameters: {
        'req': "UPDATE users SET id_tel = '$_deviceId' WHERE matricule='$monMatricule'",
      });
      http.Response response = await http.post(url);
      _getId();
    }
  }

}


class _HomeState extends State<Home> {

  String uploadEndPoint = 'https://files.000webhost.com/image_upload.php';
  Future<File>? file;
  String status = '';
  String? base64Image;
  File? tmpFile;
  String errMessage = 'Error Uploading Image';
  String? _selectMagasin;
  String? _selectTheme;
  String? _deviceIdMatricule;
  String? _deviceId;
  TextEditingController textController = TextEditingController();
  int Note = 5;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 43, 43, 1),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Photo de visite'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: getData(
                  'SELECT DISTINCT "test" as Code_CM, CONCAT(Code_CM," - ",nom_mag) as Code_CM FROM magasin WHERE Code_CM LIKE "%CM%" ORDER BY Code_CM',
                  'Code_CM'),
              builder: (BuildContext context,
                  AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData && snapshot.data != null) {
                  List<String> listeMagasins = [];
                  for (var i = 0; i < snapshot.data.length; i++) {
                    listeMagasins.add(snapshot.data[i].replaceAll("[", "")
                        .replaceAll("]", "")
                    );
                  }
                  return
                    Container(
                      height: 30,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectMagasin,
                        onChanged: (String? magasin) {
                          setState(() {
                            _selectMagasin = magasin!;
                          });
                        },
                        style: const TextStyle(color: Colors.blue),
                        items: listeMagasins.map((String value) {
                          return
                            DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.replaceAll('"', '')),
                            );
                        }).toSet().toList(),
                      )
                    );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),

            FutureBuilder(
              future: getData('SELECT DISTINCT theme FROM themes', 'theme'),
              builder: (BuildContext context,
                  AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
                  List<String> listeThemes = [];
                  for (var i = 0; i < snapshot.data.length; i++) {
                    listeThemes.add(snapshot.data[i].replaceAll("[", "")
                        .replaceAll("]", "")
                    );
                  }
                  return
                    Container(
                      height: 40,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectTheme,
                        onChanged: (String? theme) {
                          setState(() {
                            _selectTheme = theme!;
                          });
                        },
                        style: const TextStyle(color: Colors.blue),
                        items: listeThemes.map((String value) {
                          return
                            DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.replaceAll('"', '').replaceAll(
                                  "_", " ")),
                            );
                        }).toSet().toList(),
                      )
                    );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),


            if(tmpFile != null)
              Container(
                width: 640,
                height: 350,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(tmpFile!),
                  ),
                ),
              )
            else
              Container(
                width: 640,
                height: 350,
                alignment: Alignment.center,
                child: const Text(
                  'Votre photo',
                  style: TextStyle(color: Colors.white, fontSize: 26),),
              ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: textController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.lightBlue,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true
              ),
              minLines: 5,
              keyboardType: TextInputType.multiline,
              maxLines: 20,
            ),

            SizedBox(
              width: 120,
              child: Card(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => _itemCountDecrease(),
                    ),
                    Text(Note.toString()),
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _itemCountIncrease(),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.red;
                            return Colors.red; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: () => getImage(source: ImageSource.camera),
                      child: const Text(
                          'Appareil photo', style: TextStyle(fontSize: 18))
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.red;
                            return Colors.red; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: () => getImage(source: ImageSource.gallery),
                      child: const Text(
                          'Galerie', style: TextStyle(fontSize: 18))
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.red;
                            return Colors.red; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: () => uploadFile(tmpFile),
                      child: const Text(
                          'Enregistrer', style: TextStyle(fontSize: 18))
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(
      source: source,
    );
    setState(() {
      tmpFile = File(file!.path);
    });
  }

  Future insertData(monImage) async {
    _getId();
    String monMag = _selectMagasin!.substring(0, 5);
    String monMotif = _selectTheme!.replaceAll('"', '');
    String monComm = textController.text;
    int maNote = Note;

    print(_deviceIdMatricule);
    final url = Uri.parse('http://fdvrbi.000webhostapp.com/insert.php')
        .replace(queryParameters: {
      'req': "INSERT INTO fiche_visite_autre2 (Code_CM, Motif_Visite, Matricule_creation, Rapport_Visite, IMAGE_1, NOTE_1) VALUES ('$monMag', '$monMotif', '$_deviceIdMatricule', '$monComm', '$monImage', '$maNote')",
    });
    http.Response response = await http.post(url);
  }

  void uploadFile(filePath) async {
    String fileName = basename(filePath.path);
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
            filePath.path, filename: fileName),
      });
      Response response = await Dio().post(
          "http://fdvrbi.000webhostapp.com/image_upload.php", data: formData
      );
      insertData(fileName);
      showDialog(
        context: this.context,
        builder: (context) =>
          AlertDialog(
            title: Text('Chargement...'),
            content: Text(response.toString().replaceAll('"', ' ')),
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.red;
                        return Colors.red; // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Ok')
              )
            ],
          ),
      );
    } catch (e) {
      print("expectation caught: $e");
    }

  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    String? deviceId;

    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = await iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = await androidDeviceInfo.androidId; // unique ID on Android
    }
    String matric = (await getData("SELECT DISTINCT matricule FROM users WHERE id_tel='$deviceId'", 'matricule')).first.replaceAll('"', '');
    print(matric);
    print(deviceId);
    setState(() => _deviceIdMatricule = matric);
    setState(() => _deviceId = deviceId);
  }

  Future<List> getData(maReq, maData) async {
    final url = Uri.parse('http://fdvrbi.000webhostapp.com/SelectTest.php')
        .replace(queryParameters: {
      'req': maReq,
      'data': maData,
    });
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    return data;
  }

  _itemCountIncrease() {
    setState(() {
      if (Note < 10) {
        Note += 1;
      }
    });
  }

  _itemCountDecrease() {
    setState(() {
      if (Note > 0) {
        Note -= 1;
      }
    });
  }
}