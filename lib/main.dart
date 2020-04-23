import 'dart:typed_data';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import './permission.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import './files.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<CameraDescription> cameras;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

int atcount = 0;

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secure Vault',
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.amber,
          primaryColor: Colors.amber),
      home: MyHomePage(title: 'Secure Vault'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _canCheckBiometric = false;
  String _authorizedOrNot = "Not Authorized";
  List<BiometricType> _availableBiometricTypes = List<BiometricType>();
  Future<void> _initializeControllerFuture;
  CameraController _controller;

  @override
  void initState() {
    super.initState();
    // To display the current output from the camera,
    // create a CameraController.

    CameraDescription _currentSelectedCamera = cameras.last;

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      _currentSelectedCamera,
      // Define the resolution to use - from low - max (highest resolution available).
      ResolutionPreset.max,
      enableAudio: true,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  void _capture() async {
    try {
      await _initializeControllerFuture;

      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      await _controller.takePicture(path);

      bool hasPermission =
          await PermissionsService().hasGalleryWritePermission();
      if (!hasPermission) {
        bool isGranted =
            await PermissionsService().requestPermissionToGallery();
        if (!isGranted) {
          print('Not granted');
          return;
        }
      }

      var image = await File(path).readAsBytes();
      var y = Uint8List.fromList(image);
      await ImageGallerySaver.saveImage(y);
    } catch (e) {
      print(e);
    }
  }

  bool isAuthorized = false;
  Future<void> _authorizeNow() async {
    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate to complete your transaction",
        useErrorDialogs: true,
        stickyAuth: false,
      );
      //return;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      if (isAuthorized && atcount <= 2) {
        print(atcount.toString() + ' Still trying');
        //atcount = 0;
        _authorizedOrNot = "Authorized";
      } else if (atcount == 2 || atcount == 3) {
        print('Should change string ' + atcount.toString());
        _capture();
        _authorizedOrNot = ' 3 invalid attempts!\nAttempt logged!';
        //atcount=0;
      } else {
        print('Else case: ' + atcount.toString());
        atcount += 1;
        _authorizedOrNot = "Not Authorized";
      }
    });
  }

  var montStyle = TextStyle(fontSize: 20, fontFamily: 'Montserrat');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: montStyle,
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  "https://media3.giphy.com/media/P6zj1j9OMinzW/source.gif"),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //direction: Axis.vertical,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: isAuthorized
                  ? Text('')
                  : Text(
                      'Please authenticate first',
                      style: TextStyle(
                          fontSize: 26,
                          color: isAuthorized ? Colors.green[400] : Colors.red,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
            ),
            Text(
              "$_authorizedOrNot",
              style: TextStyle(
                  fontSize: 26,
                  color: isAuthorized ? Colors.green[400] : Colors.red,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xAFFF4535), Color(0XFFFF7F2D)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight),
              ),
              height: 100,
              width: 100,
              //color: Colors.lightBlue[100],
              margin: EdgeInsets.all(20),
              child: Icon(
                Icons.fingerprint,
                size: 50,
                color: Colors.white,
              ),
            ),
            RaisedButton(
              elevation: 20,
              hoverElevation: 50,
              //animationDuration: Duration(milliseconds: 2000),
              onPressed: _authorizeNow,
              child: Text(
                "Authenticate",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: Colors.orange[400],
              colorBrightness: Brightness.light,
            ),
            RaisedButton(
              color: Colors.yellow,
              onPressed: isAuthorized
                  ? () {
                      //Scaffold.of(context).showSnackBar(snackBar);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => Files(atcount: atcount),
                        ),
                      );
                    }
                  : null,
              child: Text(
                'Continue',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
