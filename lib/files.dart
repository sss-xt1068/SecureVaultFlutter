import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import './firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';

final List names = [
  '.estrongs',
  '.DataStorage',
  'Android',
  'AnyDesk',
  'Bluetooth',
  'cache',
  'CamScanner',
  'Documents',
  'Downloads',
  'Music',
  'Paytm',
  'SHAREit',
  'WhatsApp',
];

class Files extends StatelessWidget {
  final int atcount;
  //default constructor for maintaining count variable

  Files({@required this.atcount});
  var style1 = TextStyle(fontSize: 18, fontFamily: 'Montserrat');
  var style2 = TextStyle(fontFamily: 'Montserrat');
  var style3 =
      TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'Montserrat');
  Widget build(BuildContext context) {
    print('Atcount received is' + atcount.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your files',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: Wrap(
          runSpacing: 20,
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              height: 60,
              color: Colors.orangeAccent,
              child: Text(
                'Unauthorized Attempts',
                style: style3,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new Database(atcount: atcount),
                  ),
                );
              },
            ),
            MaterialButton(
              height: 60,
              color: Colors.orangeAccent,
              child: Text(
                'Your Files',
                style: style3,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => MyFiles(),
                  ),
                );
              },
            ),
          ],
        ),
        //child: MyFiles(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchURL,
        child: ClipOval(
          child: Image.asset(
            'assets/github.png',
            colorBlendMode: BlendMode.overlay,
            fit: BoxFit.fill,
          ),
        ),
      ),
      bottomSheet: Container(
        height: 13,
        width: double.infinity,
        alignment: Alignment.center,
        child: Row(children: [
          Text(
            'Made with ',
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
          Image.asset('assets/heart.png', height: 40),
          Text(
            ' using Flutter',
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
        ]),
      ),
    );
  }

  _launchURL() async {
    const url = 'https://github.com/sss-xt1068/SecureVaultFlutter';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e);
    }
  }
}

class MyFiles extends StatefulWidget {
  @override
  _MyFilesState createState() => _MyFilesState();
}

String actualDir;
List filevar = List();
io.Directory _downloadsDirectory;

class _MyFilesState extends State<MyFiles> {
// class MyFiles extends StatelessWidget {
  var style2 = TextStyle(fontFamily: 'Montserrat');
  var style1 = TextStyle(fontSize: 18, fontFamily: 'Montserrat');
  void initState() {
    super.initState();
    // initDownloadsDirectoryState();
  }

  // void initDownloadsDirectoryState() {
  // getDir();
  // }

  // getDir() async {
  //   try {
  //     io.Directory _downloadsDirectory =
  //         await DownloadsPathProvider.downloadsDirectory;
  //   } catch (PlatformException) {
  //     print('Couldn\'t find downloads :(');
  //     io.Directory _downloadsDirectory =
  //         await getApplicationDocumentsDirectory();
  //   }
  //   if (!mounted) return;

  //   String myPath = _downloadsDirectory.path;
  //   setState(() {
  //     actualDir = myPath;
  //     print(actualDir);
  //     filevar = io.Directory("$actualDir/").listSync(recursive: false);
  //     print(filevar[0].path);
  //   });
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your files', style: style2),
      ),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[100],
                    Colors.cyan[100],
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    spreadRadius: 2,
                    offset: Offset(2, 4),
                  ),
                ]),
            child: ListTile(
              title: Text(
                names[index].toString(),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: names[index].toString().startsWith('.')
                      ? Colors.grey[500]
                      : Colors.black,
                  fontSize: 16,
                ),
              ),
              leading: Icon(
                Icons.folder,
                color: names[index].toString().startsWith('.')
                    ? Colors.grey[500]
                    : Colors.black54,
              ),
              trailing: Icon(Icons.arrow_right),
            ),
          );
        },
      ),
    );
  }
}
