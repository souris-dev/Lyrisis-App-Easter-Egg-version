import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lyricyst_app/pages/PredictionPage.dart';
import 'package:spinner_input/spinner_input.dart';

// ignore: must_be_immutable
class TextEditorPage extends StatefulWidget {
  TextEditorPage({Key key}) : super(key: key);

  @override
  _TextEditorPageState createState() => _TextEditorPageState();
}

class _TextEditorPageState extends State<TextEditorPage> {
  final seedTextController = TextEditingController();
  final seedTextFocusNode = FocusNode();
  final List<String> artists = <String>['Taylor Swift', 'Eminem'];
  String currentArtist = 'Taylor Swift';
  double temperature = 0.1;
  int nWords = 3;

  GlobalKey<PredictionPageState> predictionKey;
  bool predictionsDemanded = false;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Color.fromARGB(255, 36, 44, 70),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color.fromRGBO(249, 249, 227, 30),
        systemNavigationBarIconBrightness: Brightness.dark));

    super.initState();
  }

  void onPredictionChosen(String item) {
    setState(() {
      seedTextController.text += ' ' + item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        elevation: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            DrawerHeader(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'OPTIONS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 50), child: Text('Artist: ')),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: DropdownButton<String>(
                value: currentArtist,
                icon: Icon(Icons.arrow_downward),
                iconSize: 20,
                elevation: 8,
                onChanged: (newVal) => setState(() => currentArtist = newVal),
                items: artists.map<DropdownMenuItem<String>>((String name) {
                  return DropdownMenuItem<String>(
                      child: Padding(
                          child: Text(name),
                          padding: EdgeInsets.only(right: 10)),
                      value: name);
                }).toList(),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text('Temperature: ')),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: SpinnerInput(
                  step: 0.1,
                  minValue: 0.1,
                  fractionDigits: 1,
                  maxValue: 1.0,
                  middleNumberPadding: EdgeInsets.symmetric(horizontal: 10),
                  spinnerValue: temperature,
                  onChange: (newVal) => setState(() => temperature = newVal),
                )),
            Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text('Number of words: ')),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: SpinnerInput(
                  step: 1,
                  minValue: 1,
                  maxValue: 600,
                  spinnerValue: nWords.toDouble(),
                  middleNumberPadding: EdgeInsets.symmetric(horizontal: 17),
                  fractionDigits: 0,
                  onChange: (newVal) => setState(() => nWords = newVal.toInt()),
                )),
          ],
        ),
      ),
      body: Builder(
        // we need to do this to get a new BuildContext inside to call Scaffold.of()
        builder: (context) {
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.asset(
                  'assets/screen2_bg.png',
                  fit: BoxFit.fill,
                ), // The BG
              ),
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 5,
                          bottom: 12),
                      child: GestureDetector(
                          child: Image.asset('assets/drawer_open_arrow.png',
                              height: MediaQuery.of(context).size.height / 14),
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          }),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Wrap(
                              children: <Widget>[
                                TextField(
                                  style: TextStyle(
                                      fontFamily: 'RhodiumLibre', fontSize: 20),
                                  decoration: InputDecoration(
                                    hintText: 'Title',
                                    hintStyle: TextStyle(
                                        fontFamily: 'RhodiumLibre',
                                        fontSize: 20,
                                        color:
                                            Color.fromRGBO(229, 235, 194, 1)),
                                    contentPadding: EdgeInsets.only(bottom: 10),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                234, 244, 205, 1),
                                            width: 2)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                234, 244, 205, 1),
                                            width: 2)),
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                234, 244, 205, 1),
                                            width: 2)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                234, 244, 205, 1),
                                            width: 2)),
                                  ),
                                  cursorColor: Color.fromRGBO(234, 244, 205, 1),
                                  enabled: true,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: GestureDetector(
                              child: LimitedBox(
                                maxWidth: double.infinity,
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: Scrollbar(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: TextField(
                                      controller: seedTextController,
                                      focusNode: seedTextFocusNode,
                                      style: TextStyle(
                                          fontFamily: 'RhodiumLibre',
                                          fontSize: 15),
                                      decoration: InputDecoration(
                                        hintText: 'Type here',
                                        hintStyle: TextStyle(
                                            fontFamily: 'RhodiumLibre',
                                            fontSize: 15,
                                            color: Color.fromRGBO(
                                                229, 235, 194, 1)),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                      cursorColor:
                                          Color.fromRGBO(229, 235, 194, 1),
                                      maxLines: null,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                seedTextFocusNode.requestFocus();
                                print('Tap');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width / 5),
                            child: Image.asset(
                                'assets/need_help_label_editor.png',
                                height:
                                    MediaQuery.of(context).size.height / 35)),
                        Padding(
                          padding: EdgeInsets.only(left: 32, bottom: 0),
                          child: GestureDetector(
                              child: Image.asset(
                                  'assets/popup_arrow_editor.png',
                                  height:
                                      MediaQuery.of(context).size.height / 15),
                              onTap: () {
                                setState(() {
                                  //predictionKey
                                  //.currentState.predictionDemanded = true;
                                  predictionsDemanded = true;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AnimatedPositioned(
                top: predictionsDemanded
                    ? MediaQuery.of(context).size.height * 2 / 3
                    : MediaQuery.of(context).size.height,
                bottom: 0,
                left: 0,
                right: 0,
                duration: Duration(milliseconds: 700),
                child: PredictionPage(
                  key: predictionKey,
                  seedController: seedTextController,
                  artist: currentArtist,
                  nwords: nWords,
                  temp: temperature,
                  predictionDemanded: true,
                  onCloseRequested: () {
                    setState(() {
                      predictionsDemanded = false;
                    });
                  },
                  onChipPressed: (chipText) {
                    setState(() {
                      seedTextController.text += chipText;
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    seedTextFocusNode.dispose();
    seedTextController.dispose();
    super.dispose();
  }
}
