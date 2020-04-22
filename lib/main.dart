import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import './permission.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
//import 'package:camera_app/camera_controls.dart';
//import 'package:camera_app/permission.dart';
import './files.dart';
import './camera_controls.dart';

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
      title: 'Flutter Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
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

  // CameraControls _cameraControls(BuildContext context) {
  //   return CameraControls(
  //     //toggleCameraMode: _toggleCameraMode,
  //     takePicture: () => _capture(),
  //     //switchCameras: _switchCamera,
  //   );
  // }

  void _capture() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      await _controller.takePicture(path);

      // attempt to save to gallery
      bool hasPermission =
          await PermissionsService().hasGalleryWritePermission();

      // request for permision if not given
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
  // Future<void> _checkBiometric() async {
  //   bool canCheckBiometric = false;
  //   try {
  //     canCheckBiometric = await _localAuthentication.canCheckBiometrics;
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     _canCheckBiometric = canCheckBiometric;
  //   });
  // }

  // Future<void> _getListOfBiometricTypes() async {
  //   List<BiometricType> listofBiometrics;
  //   try {
  //     listofBiometrics = await _localAuthentication.getAvailableBiometrics();
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     _availableBiometricTypes = listofBiometrics;
  //   });
  // }

  bool isAuthorized = false;
  Future<void> _authorizeNow() async {
    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate to complete your transaction",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      if (atcount == 0) {
        if (isAuthorized) {
          _capture();
          atcount = 0;
          _authorizedOrNot = "Authorized";
        }
      }
      if (atcount == 3) {
        _authorizedOrNot = ' 3 invalid attempts!\nAttempt logged!';
      } else {
        atcount += 1;
        _authorizedOrNot = "Not Authorized";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //direction: Axis.vertical,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text("Can we check Biometric : $_canCheckBiometric"),
            // RaisedButton(
            //   onPressed: _checkBiometric,
            //   child: Text("Check Biometric"),
            //   color: Colors.red,
            //   colorBrightness: Brightness.light,
            // ),
            // Text("List Of Biometric : ${_availableBiometricTypes.toString()}"),
            // RaisedButton(
            //   onPressed: _getListOfBiometricTypes,
            //   child: Text("List of Biometric Types"),
            //   color: Colors.red,
            //   colorBrightness: Brightness.light,
            // ),
            //Icon(icon:),
            Text(
              "Authorized : $_authorizedOrNot",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Icon(
                Icons.fingerprint,
                size: 50,
              ),
            ),
            RaisedButton(
              onPressed: _authorizeNow,
              child: Text(
                "Authorize now",
                style: TextStyle(fontSize: 18),
              ),
              color: Colors.orange[700],
              colorBrightness: Brightness.light,
            ),
            MaterialButton(
              onPressed: isAuthorized
                  ? () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => Files(),
                        ),
                      );
                    }
                  : null,
              child: Text(
                'Continue',
              ),
            )
          ],
        ),
      ),
    );
  }
}
