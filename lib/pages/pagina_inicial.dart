import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:projeto_radio/models/Materia.dart';
import 'package:projeto_radio/models/Materia_repository.dart';
import 'package:projeto_radio/models/MenuItens.dart';
import 'materia.dart';

class MenuMaterias extends StatefulWidget {
  MenuMaterias({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MenuMateriasState createState() => _MenuMateriasState();
}

class _MenuMateriasState extends State<MenuMaterias>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  bool isPlaying = false;

  static const streamUrl = "https://paineldj6.com.br:13895/live";
  List<Materia> materias = [];
  List<String> tiposMaterias = [
    'Todos',
    'Cotidiano',
    'Viver',
    'Pessoas',
    'MundoPop'
  ];

  @override
  void initState() {
    super.initState();
    this.getMaterias();
    this.audioStart();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Container(
              child: Row(
            children: [
              Text("SuperNova FM"),
              Spacer(),
              Text(
                " Ouça a Rádio",
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
        drawer: Container(
            width: 120,
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: 50.0,
                    child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                        child: Text(
                          'Categorias',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        margin: EdgeInsets.all(0.0),
                        padding: EdgeInsets.all(0.0)),
                  ),
                  Container(
                      height: double.maxFinite,
                      child: ListView.builder(
                          itemCount: tiposMaterias.length,
                          itemBuilder: (BuildContext context, index) {
                            return InkWell(
                              onTap: () => {
                                choiceAction(tiposMaterias[index]),
                                Navigator.pop(context)
                              },
                              child: Container(
                                  padding: EdgeInsets.all(05),
                                  child: new Text(
                                    tiposMaterias[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black),
                                  )),
                            );
                          }))
                ],
              ),
            )),
        body: Center(
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.red[500], Colors.blue[100]])),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(0),
                        child: Column(
                          children: [
                            Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Image.asset(
                                  'assets/logo_supernova.png',
                                  width: 175,
                                ),
                              ],
                            )),
                            Padding(padding: EdgeInsets.all(5)),
                            ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: materias.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                    onTap: () =>
                                        {navigateMateriaPage(materias[index])},
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              colorFilter: ColorFilter.mode(
                                                  Colors.grey[300],
                                                  BlendMode.darken),
                                              fit: BoxFit.cover,
                                              image: MemoryImage(
                                                Base64Decoder().convert(
                                                    materias[index].imagem),
                                              ))),
                                      alignment: Alignment(-0.90, 0.70),
                                      padding: EdgeInsets.all(5),
                                      height: 150,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${materias[index].titulo}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 7.0,
                                                    color: Colors.grey[900],
                                                    offset: Offset(1, 1),
                                                  ),
                                                  Shadow(
                                                    blurRadius: 7.0,
                                                    color: Colors.grey[900],
                                                    offset: Offset(1, 1),
                                                  ),
                                                  Shadow(
                                                    blurRadius: 7.0,
                                                    color: Colors.grey[900],
                                                    offset: Offset(1, 1),
                                                  ),
                                                  Shadow(
                                                    blurRadius: 7.0,
                                                    color: Colors.grey[900],
                                                    offset: Offset(1, 1),
                                                  )
                                                ]),
                                            textAlign: TextAlign.start,
                                          )
                                        ],
                                      ),
                                    ));
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                            )
                          ],
                        ))))));
  }

  void navigateMateriaPage(Materia materia) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetalharMateria(
                title: '${materia.titulo}',
                materia: materia,
              )),
    );
    this.isPlaying = await FlutterRadio.isPlaying();
    setState(() {
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    this.isPlaying = await FlutterRadio.isPlaying();
    setState(() {
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  void _playerRadio() async {
    await FlutterRadio.playOrPause(url: streamUrl);

    isPlaying = !isPlaying;
    setState(() {
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  void choiceAction(String choice) async {
    this.materias = await MateriaRepository().getMaterias();
    if (choice == MenuItems.Todos) {
      setState(() {});
      return;
    }
    setState(() {
      this.materias.removeWhere((materia) => materia.tipo != choice);
    });
  }

  void getMaterias() async {
    this.materias = await MateriaRepository().getMaterias();
    setState(() {});
  }
}
