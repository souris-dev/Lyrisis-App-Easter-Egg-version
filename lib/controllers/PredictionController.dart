import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PredictionController {
  TextEditingController seedController;
  String prevSeedText;
  String artist;
  double temperature;
  int nWords;
  bool predictionDemanded;
  bool newPredsNeeded;
  String noPredText = 'Ask me when you need!';

  PredictionController(
      {this.seedController,
      this.artist,
      this.temperature,
      this.nWords,
      this.predictionDemanded = false,
      this.newPredsNeeded = true});

  get seed => seedController.text;
  set seed(String text) => seedController.text = text;
  void addToSeed(String text) => seedController.text += text;

  get artistName => artist.replaceAll(' ', '_');

  Future<List<String>> getPredictionsFromServer() async {
    var client = http.Client();
    List<String> predictions = <String>[];

    var url = "http://lyrisis-server.herokuapp.com/predict";

    var logger = Logger();
    try {
      var response = await client.post(url, body: {
        'seed': seedController.text,
        'temp': temperature.toString(),
        'nwords': nWords.toString(),
        'artist': artistName
      });

      print(response.body);

      predictions =
          json.decode(response.body)['words'].map<String>((dynamic str) {
        String word = str.toString();

        // recall that the server strips off \n in the words
        // so if there are any "" in the predictions
        // they are probably newlines

        if (word != "") {
          return word;
        } else {
          return '(newline)';
        }
      }).toList();

      logger.d('Response: ' + response.body);
    } catch (e) {
      logger.e('Error while retrieving predictions from server!');
      Fluttertoast.showToast(
        msg: "Sorry, couldn't get predictions!",
        backgroundColor: Color.fromRGBO(150, 62, 84, 1),
        textColor: Colors.white,
      );
      predictionDemanded = false;
      print(e.toString());
    } finally {
      client.close();
    }

    return predictions;
  }
}
