import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class TextEditorPage extends StatefulWidget {
  TextEditorPage({Key key}) : super(key: key);

  @override
  _TextEditorPageState createState() => _TextEditorPageState();
}

class _TextEditorPageState extends State<TextEditorPage> {
    final seedTextController = TextEditingController();
    final seedTextFocusNode = FocusNode();

    @override
    void initState() {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarColor: Color.fromARGB(255, 36, 44, 70),
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: Color.fromRGBO(249, 249, 227, 30),
              systemNavigationBarIconBrightness: Brightness.dark
        ));

        super.initState();
    }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(
          elevation: 3,
          child: Column(
            children: <Widget>[
              DrawerHeader(
                child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('OPTIONS', style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              )
            ],
          ),
        ),
        body: Builder( // we need to do this to get a new BuildContext inside to call Scaffold.of()
            builder: (context) {
                return Stack(
                    children: <Widget>[
                        Positioned.fill(
                              child: Image.asset('assets/screen2_bg.png', fit: BoxFit.fill,)// The BG
                        ),

                         Column(

                                children: <Widget>[
                                    Align(
                                        alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 5, bottom: 12),
                                            child: GestureDetector(
                                                  child: Image.asset('assets/drawer_open_arrow.png', height: MediaQuery.of(context).size.height / 14),
                                                  onTap: () {
                                                      Scaffold.of(context).openDrawer();
                                                  }
                                            ),
                                        )),

                                    Expanded(child: Center(
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                  Padding(
                                                        padding: EdgeInsets.all(20),
                                                        child: Wrap(children: <Widget>[
                                                            TextField(
                                                                style:
                                                                TextStyle(fontFamily: 'RhodiumLibre', fontSize: 20),
                                                                decoration: InputDecoration(
                                                                    hintText: 'Title',
                                                                    hintStyle: TextStyle(
                                                                          fontFamily: 'RhodiumLibre',
                                                                          fontSize: 20,
                                                                          color: Color.fromRGBO(229, 235, 194, 1)),
                                                                    contentPadding: EdgeInsets.only(bottom: 10),
                                                                    border: UnderlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                                color: Color.fromRGBO(234, 244, 205, 1),
                                                                                width: 2)),
                                                                    enabledBorder: UnderlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                                color: Color.fromRGBO(234, 244, 205, 1),
                                                                                width: 2)),
                                                                    disabledBorder: UnderlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                                color: Color.fromRGBO(234, 244, 205, 1),
                                                                                width: 2)),
                                                                    focusedBorder: UnderlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                                color: Color.fromRGBO(234, 244, 205, 1),
                                                                                width: 2)),
                                                                ),
                                                                cursorColor: Color.fromRGBO(220, 220, 220, 1),
                                                                enabled: true,
                                                            )
                                                        ])),
                                                  Padding(
                                                    padding: EdgeInsets.all(20),
                                                    child: GestureDetector(child: LimitedBox(
                                                        maxWidth: double.infinity,
                                                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                                                            child: Scrollbar(
                                                                child: SingleChildScrollView(
                                                                    scrollDirection: Axis.vertical,
                                                                    child: TextField(
                                                                        controller: seedTextController,
                                                                        focusNode: seedTextFocusNode,
                                                                        style: TextStyle(fontFamily: 'RhodiumLibre', fontSize: 15),
                                                                        decoration: null,
                                                                        maxLines: null,
                                                                    ),
                                                                ),
                                                            ),
                                                    ),
                                                    onTap: () {
                                                        seedTextFocusNode.requestFocus();
                                                        print('Tap');
                                                    }
                                                  )),
                                              ],
                                          ))),

                                    Center(

                                        child: Row(
                                              children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 5),
                                                    child: Image.asset(
                                                          'assets/need_help_label_editor.png' ,
                                                          height: MediaQuery.of(context).size.height / 35)
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(left: 32, bottom: 0),
                                                      child: GestureDetector(
                                                            child: Image.asset('assets/popup_arrow_editor.png', height: MediaQuery.of(context).size.height / 15),
                                                            onTap: () {
                                                                Scaffold.of(context).openDrawer();
                                                            }
                                                      ),

                                                  )
                                              ]
                                        )
                                    )
                                ],
                            ),

                        /*Positioned(
                            left: 0,
                            top: MediaQuery.of(context).padding.top + 5,
                            child: GestureDetector(
                                  child: Image.asset('assets/drawer_open_arrow.png', height: MediaQuery.of(context).size.height / 14),
                                  onTap: () {
                                      Scaffold.of(context).openDrawer();
                                  }
                            ),
                        ),

                        Positioned(
                              top: MediaQuery.of(context).padding.top + MediaQuery.of(context).size.height / 14 + 15,
                              width: MediaQuery.of(context).size.width,
                              left: 0,
                              child: Center(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                            Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Wrap(children: <Widget>[
                                                      TextField(
                                                          style:
                                                          TextStyle(fontFamily: 'RhodiumLibre', fontSize: 20),
                                                          decoration: InputDecoration(
                                                              hintText: 'Title',
                                                              hintStyle: TextStyle(
                                                                    fontFamily: 'RhodiumLibre',
                                                                    fontSize: 20,
                                                                    color: Color.fromRGBO(229, 235, 194, 1)),
                                                              contentPadding: EdgeInsets.only(bottom: 10),
                                                              border: UnderlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                          color: Color.fromRGBO(234, 244, 205, 1),
                                                                          width: 2)),
                                                              enabledBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                          color: Color.fromRGBO(234, 244, 205, 1),
                                                                          width: 2)),
                                                              disabledBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                          color: Color.fromRGBO(234, 244, 205, 1),
                                                                          width: 2)),
                                                              focusedBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                          color: Color.fromRGBO(234, 244, 205, 1),
                                                                          width: 2)),
                                                          ),
                                                          cursorColor: Color.fromRGBO(220, 220, 220, 1),
                                                          enabled: true,
                                                      )
                                                  ]))
                                        ],
                                    ))
                        ),*/
                    ],
                );
            },
            
        ) 
    );
  }

  @override
    void dispose() {
        seedTextFocusNode.dispose();
        seedTextController.dispose();
        super.dispose();
  }
}
