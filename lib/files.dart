import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterlocalauth/main.dart';
import './firestore.dart';

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
    print('Atcount received is'+atcount.toString());
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
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
                      builder: (context) => new Database(atcount:atcount),
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
                    builder: (context) => new Files(atcount: atcount,),
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
    );
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
        return Container(
          height: 50,
          color: Colors.orange[200],
          child: Center(
            child: Text(
              '${names[index]}',
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        color: Colors.blue,
        thickness: 2,
      ),
    );
  }
}
