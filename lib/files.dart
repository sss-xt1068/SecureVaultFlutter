import 'package:flutter/material.dart';

class Files extends StatelessWidget {
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

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(children: [
          DrawerHeader(
            child: Text(
              'MENU',
            ),
          ),
          ListTile(
              title: Text(
                'Unauthorized Attempts',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                'All unauthorized log-in attempts',
              )),
          ListTile(
            title: Text(
              'Your Files',
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text('All you files easily accessible'),
          )
        ]),
      ),
      appBar: AppBar(
        title: Text('Your files'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
              child: Center(
                child: Text(
                  names[0],
                  style: TextStyle(fontSize: 22),
                ),
              ),
              color: Colors.orange[200],
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
              child: Center(
                child: Text(
                  names[1],
                  style: TextStyle(fontSize: 22),
                ),
              ),
              color: Colors.orange[200],
            ),
            Container(
                padding: EdgeInsets.all(20),
                height: 100,
                child: Center(
                  child: Text(
                    names[2],
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                color: Colors.orange[200]),
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
              child: Center(
                child: Text(
                  names[3],
                  style: TextStyle(fontSize: 22),
                ),
              ),
              color: Colors.orange[200],
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
              child: Center(
                child: Text(
                  names[4],
                  style: TextStyle(fontSize: 22),
                ),
              ),
              color: Colors.orange[200],
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
              child: Center(
                child: Text(
                  names[5],
                  style: TextStyle(fontSize: 22),
                ),
              ),
              color: Colors.orange[200],
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
              child: Center(
                child: Text(
                  names[6],
                  style: TextStyle(fontSize: 22),
                ),
              ),
              color: Colors.orange[200],
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
              child: Center(
                child: Text(
                  names[7],
                  style: TextStyle(fontSize: 22),
                ),
              ),
              color: Colors.orange[200],
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
              child: Center(
                child: Text(
                  names[8],
                  style: TextStyle(fontSize: 22),
                ),
              ),
              color: Colors.orange[200],
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
              child: Center(
                child: Text(
                  names[9],
                  style: TextStyle(fontSize: 22),
                ),
              ),
              color: Colors.orange[200],
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
              child: Center(
                child: Text(
                  names[10],
                  style: TextStyle(fontSize: 22),
                ),
              ),
              color: Colors.orange[200],
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
              child: Center(
                child: Text(
                  names[11],
                  style: TextStyle(fontSize: 22),
                ),
              ),
              color: Colors.orange[200],
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
              child: Center(
                child: Text(
                  names[12],
                  style: TextStyle(fontSize: 22),
                ),
              ),
              color: Colors.orange[200],
            ),
          ],
        ),
      ),
    );
  }
}
