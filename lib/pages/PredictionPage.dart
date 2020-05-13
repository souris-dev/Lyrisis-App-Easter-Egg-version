import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lyricyst_app/controllers/PredictionController.dart';

class PredictionPage extends StatefulWidget {
  PredictionPage({
    Key key,
    this.predictionController,
    this.onChipPressed,
    this.onCloseRequested,
  }) : super(key: key);

  final predictionController;
  final Function onChipPressed;
  final Function onCloseRequested;

  @override
  PredictionPageState createState() {
    var logr = Logger();
    logr.d('In createState(), predDem: ' +
        predictionController.predictionDemanded.toString());
    return PredictionPageState(
      predictionController: predictionController,
      onChipPressed: onChipPressed,
      onCloseRequested: onCloseRequested,
    );
  }
}

class PredictionPageState extends State<PredictionPage> {
  PredictionController predictionController;
  List<String> predictions;
  Function onChipPressed;
  Function onCloseRequested;

  PredictionPageState({
    this.predictionController,
    this.onChipPressed,
    this.onCloseRequested,
  });

  Future<void> getPredictions() async {
    if (predictionController.predictionDemanded &&
        predictionController.newPredsNeeded) {
      predictions = await predictionController.getPredictionsFromServer();
      predictionController.newPredsNeeded = false;
    }

    /*if (newPredsNeeded) {
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
    }*/
  }

  @override
  Widget build(BuildContext context) {
    Widget innerChildNoPrediction = Text(predictionController.noPredText);

    var loggr = Logger();
    loggr.d(predictionController.seedController.text +
        " " +
        predictionController.artistName +
        " " +
        predictionController.nWords.toString() +
        " " +
        predictionController.temperature.toString());

    Widget innerChildWithPrediction = predictionController.predictionDemanded
        ? FutureBuilder(
            future: getPredictions(),
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              if (snapshot.connectionState == ConnectionState.done) {
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

    Widget innerChild = predictionController.predictionDemanded
        ? innerChildWithPrediction
        : innerChildNoPrediction;

    var logger = Logger();
    logger.d(predictionController.predictionDemanded);

    return Container(
      height: predictionController.predictionDemanded
          ? MediaQuery.of(context).size.height / 3
          : 1,
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
