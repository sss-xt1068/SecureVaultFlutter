import 'package:flutter/material.dart';
import './firestore.dart';
import 'package:url_launcher/url_launcher.dart';

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
  int atcount;
  Files({
    @required this.atcount,
  });
  var style1 = TextStyle(fontSize: 18, fontFamily: 'Montserrat');
  var style2 = TextStyle(fontFamily: 'Montserrat');
  Widget build(BuildContext context) {
    print('Atcount received is' + atcount.toString());
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              curve: Curves.bounceInOut,
              //duration: Duration(milliseconds: 2000),
              child: Text(
                'MENU',
                style: style1,
              ),
            ),
            ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new Database(atcount: atcount),
                    ),
                  );
                },
                title: Text(
                  'Unauthorized Attempts',
                  style: style1,
                ),
                subtitle: Text(
                  'All unauthorized log-in attempts',
                  style: style2,
                )),
            ListTile(
              title: Text(
                'Your Files',
                style: style1,
              ),
              subtitle: Text(
                'All your files easily accessible',
                style: style2,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new Files(
                      atcount: atcount,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
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
        child: MyFiles(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchURL,
        child: Icon(Icons.open_in_browser),
      ),
      bottomSheet: Container(
          height: 12,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text('Made with love in Flutter')),
    );
  }

  _launchURL() async {
    const url = 'https://www.github.com/sss-xt1068/';
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

class MyFiles extends StatelessWidget {
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(
        top: 5,
      ),
      itemCount: names.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Icon(Icons.folder, size: 35),
            //tera symbol
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.deepOrange[200]),
                height: 50,
                //color: Colors.orange[200],
                child: Center(
                  child: Text(
                    '${names[index]}',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ),
            //Align(alignment: Alignment.topRight, child: Icon(Icons.arrow_right)),
            Icon(Icons.arrow_right, size: 40)
            //tera second symbol..
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        color: Colors.red,
        thickness: 2,
      ),
    );
  }
}
