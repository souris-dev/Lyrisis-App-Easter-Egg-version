import 'dart:convert';

import 'package:flutter_tags/flutter_tags.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class PredictionPage extends StatefulWidget {
  PredictionPage(
      {Key key,
      this.seedController,
      this.nwords,
      this.temp,
      this.artist,
      this.onChipPressed,
      this.onCloseRequested,
      this.predictionDemanded})
      : super(key: key);

  TextEditingController seedController;
  final double temp;
  final String artist;
  final int nwords;
  final Function onChipPressed;
  final Function onCloseRequested;
  final bool predictionDemanded;

  @override
  PredictionPageState createState() {
    var logr = Logger();
    logr.d('In createState(), predDem: ' + predictionDemanded.toString());
    return PredictionPageState(
        seedController: seedController,
        temp: temp,
        artist: artist,
        nwords: nwords,
        onChipPressed: onChipPressed,
        onCloseRequested: onCloseRequested,
        predictionDemanded: predictionDemanded);
  }
}

class PredictionPageState extends State<PredictionPage> {
  TextEditingController seedController;
  double temp;
  String artist;
  int nwords;
  List<String> predictions;
  Function onChipPressed;
  Function onCloseRequested;
  bool predictionDemanded;

  bool newPredsNeeded = true;

  PredictionPageState(
      {this.seedController,
      this.temp,
      this.artist,
      this.nwords,
      this.onChipPressed,
      this.onCloseRequested,
      this.predictionDemanded});

  Future<void> getPredictions() async {
    /*
    var client = http.Client();

    var url = "http://lyrisis-server.herokuapp.com/predict";

    var logger = Logger();
    try {
      var response = await client.post(url, body: {
        'seed': seedController.text,
        'temperature': temp,
        'nwords': nwords,
        'artist': artist
      });

      setState(() => predictions = json.decode(response.body)['words']);

      logger.d('Response: ' + response.body);
    } catch (e) {
      logger.e('Error while retrieveing predictions from server!');
      logger.e(e.toString());
    } finally {
      client.close();
    }*/
    if (newPredsNeeded) {
      Future.delayed(Duration(milliseconds: 750), () {
        setState(() => predictions = [
              'Hello',
              'I am',
              'good',
              ',',
              "how",
              "are",
              "you?",
              "I",
              "am",
              "fine",
              "thank",
              "you",
              "Okk",
              "Haha",
              "yeahh",
              "Good",
              "one"
            ]);
        var logger = Logger();
        logger.d('getPreds done!');
        newPredsNeeded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget innerChildNoPrediction = Text('No predictions right now!');

    var loggr = Logger();
    loggr.d(seedController.text);
    Widget innerChildWithPrediction = predictionDemanded
        ? FutureBuilder(
            future: getPredictions(),
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              if (snapshot.connectionState == ConnectionState.done) {
                /*return Tags(
                  itemCount: predictions.length,
                  itemBuilder: (index) {
                    String pred = predictions[index];

                    return ItemTags(
                      key: Key(pred.toString()),
                      image: null,
                      index: index,
                      icon: null,
                      title: pred,
                      active: true,
                      removeButton: null,
                      onPressed: onChipPressed(pred),
                    );
                  },
                );*/
                return Wrap(
                  children: predictions.map<Padding>((str) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: RaisedButton(
                        textColor: Colors.white,
                        child: Text(str),
                        color: Color.fromRGBO(191, 23, 87, 1),
                        elevation: 2,
                        onPressed: () {
                          onChipPressed(' ' + str);
                        },
                      ),
                    );
                  }).toList(),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        : null;

    Widget innerChild =
        predictionDemanded ? innerChildWithPrediction : innerChildNoPrediction;

    var logger = Logger();
    logger.d(predictionDemanded);

    return Container(
      height: predictionDemanded ? MediaQuery.of(context).size.height / 3 : 1,
      width: double.infinity,
      //color: Colors.white, //.fromRGBO(125, 12, 44, 1),

      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black87, width: 0.15),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.close, size: 24),
                    color: Color.fromRGBO(181, 13, 77, 1),
                    onPressed: onCloseRequested),
              ],
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Wrap(
                    children: <Widget>[
                      innerChild,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
