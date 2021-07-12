import 'package:flutter/material.dart';

import 'pages/pagina_inicial.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[200],
          primaryColor: Colors.black),
      home: MenuMaterias(title: 'SuperNova FM'),
    );
  }
}
