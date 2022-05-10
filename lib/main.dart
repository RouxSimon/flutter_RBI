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
    home: Connexion(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class Connexion extends StatefulWidget {
  const Connexion({Key? key}) : super(key: key);

  @override
  State<Connexion> createState() => _ConnexionState();
}



class _ConnexionState extends State<Connexion> {

  String? _selectMatricule;
  //String? _deviceId;

  //final AsyncMemoizer _memoizerConnexion = AsyncMemoizer();

/*  _fetchData() {
    return _memoizerConnexion.runOnce(() async {
      await Future.delayed(Duration(seconds: 2));
      return 'REMOTE DATA';
    });
  }*/
  @override
  Widget build(BuildContext context) {
    //String? deviceId = _getId().toString();
    /*return Scaffold(
      appBar: AppBar(
        title: const Text('Identifiez vous !'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Entrer votre matricule',
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                child: const Text('Go !')
            ),
          ],
        ),
      ),
    );*/

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

            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                child: const Text('Go !')
            ),

          ],
        ),
      ),
    );

  }

/*Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    String? deviceId;
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = await iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = await androidDeviceInfo.androidId; // unique ID on Android
    }
    //return deviceId;
    setState(() => _deviceId = deviceId);
  }*/

/*  Future<List> getData(maReq, maData) async {
      final url = Uri.parse('http://fdvrbi.000webhostapp.com/SelectTest.php')
          .replace(queryParameters: {
        'req': maReq,
        'data': maData,
      });
      http.Response response = await http.get(url);
      var data = jsonDecode(response.body);
      return data;
  }*/
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
  String? _deviceId;
  TextEditingController textController = TextEditingController();
  int Note = 0;

/*  final AsyncMemoizer _memoizerHome = AsyncMemoizer();
  _fetchData() {
    return _memoizerHome.runOnce(() async {
      await Future.delayed(Duration(seconds: 2));
      return 'REMOTE DATA';
    });
  }*/
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
                    DropdownButton<String>(
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
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData && snapshot.data != null) {
                  List<String> listeThemes = [];
                  for (var i = 0; i < snapshot.data.length; i++) {
                    listeThemes.add(snapshot.data[i].replaceAll("[", "")
                        .replaceAll("]", "")
                    );
                  }
                  return
                    DropdownButton<String>(
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
                    );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),


            if(tmpFile != null)
              Container(
                width: 640,
                height: 400,
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
                height: 400,
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
              // any number you need (It works as the rows for the textarea)
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
                      onPressed: () => getImage(source: ImageSource.camera),
                      child: const Text(
                          'Appareil photo', style: TextStyle(fontSize: 18))
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: ElevatedButton(
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
    String monMag = _selectMagasin!.substring(1, 6);
    String monMotif = _selectTheme!.replaceAll('"', '');
    String monComm = textController.text;
    int maNote = Note;
    _getId();
    print("INSERT INTO fiche_visite_autre2 (Code_CM, Motif_Visite, Matricule_creation, Rapport_Visite, IMAGE_1, NOTE_1) VALUES ('$monMag', '$monMotif', '$_deviceId', '$monComm', '$monImage', '$maNote')");
    final url = Uri.parse('http://fdvrbi.000webhostapp.com/insert.php')
        .replace(queryParameters: {
      'req': "INSERT INTO fiche_visite_autre2 (Code_CM, Motif_Visite, Matricule_creation, Rapport_Visite, IMAGE_1, NOTE_1) VALUES ('$monMag', '$monMotif', '$_deviceId', '$monComm', '$monImage', '$maNote')",
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
    print(deviceId);
    setState(() => _deviceId = deviceId!);
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