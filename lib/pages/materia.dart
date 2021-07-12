import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:projeto_radio/models/Materia.dart';

class DetalharMateria extends StatefulWidget {
  DetalharMateria({Key key, this.title, this.materia}) : super(key: key);

  final String title;
  final Materia materia;

  @override
  _DetalharMateria createState() => _DetalharMateria();
}

class _DetalharMateria extends State<DetalharMateria>
    with TickerProviderStateMixin {
  bool isPlaying = false;
  AnimationController _animationController;

  static const streamUrl = "https://paineldj6.com.br:13895/live";

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));

    this._initializeComponents();
  }

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: Container(
              child: Row(
            children: [
              Text("SuperNova FM"),
              Spacer(),
              Text(
                "Ouça a Rádio",
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white),
              ),
              IconButton(
                iconSize: 30,
                splashColor: Colors.grey,
                icon: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  color: Colors.white,
                  progress: _animationController,
                ),
                onPressed: () => _playerRadio(),
              ),
            ],
          )),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.grey[800]])),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                width: cWidth,
                child: new Column(
                  children: <Widget>[
                    Text(
                      '${widget.materia.titulo}',
                      style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Row(children: <Widget>[
                      Expanded(
                          child: Divider(
                        thickness: 2,
                        color: Colors.black,
                      )),
                    ]),
                    Text(
                      '${widget.materia.dataMateria}',
                      style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    new Image.memory(
                      Base64Decoder().convert(widget.materia.imagem),
                      width: 500,
                      height: 250,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '${widget.materia.descricao}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _initializeComponents() async {
    this.isPlaying = await FlutterRadio.isPlaying();

    setState(() {
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  void _playerRadio() async {
    await FlutterRadio.playOrPause(url: streamUrl);
    this.isPlaying = !this.isPlaying;
    setState(() {
      this.isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }
}
