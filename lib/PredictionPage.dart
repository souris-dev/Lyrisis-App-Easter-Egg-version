import 'dart:convert';

import 'package:flutter_tags/flutter_tags.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class PredictionPage extends StatefulWidget {
  PredictionPage(
      {Key key,
      this.seed = '',
      this.nwords,
      this.temp,
      this.artist,
      this.onChipPressed})
      : super(key: key);

  final String seed;
  final double temp;
  final String artist;
  final int nwords;
  final Function onChipPressed;

  @override
  _PredictionPageState createState() => _PredictionPageState(
      seed: seed,
      temp: temp,
      artist: artist,
      nwords: nwords,
      onChipPressed: onChipPressed);
}

class _PredictionPageState extends State<PredictionPage> {
  String seed;
  double temp;
  String artist;
  int nwords;
  List<String> predictions;
  Function onChipPressed;

  _PredictionPageState(
      {this.seed, this.temp, this.artist, this.nwords, this.onChipPressed});

  Future<void> getPredictions() async {
    var client = http.Client();

    var url = "http://somthingsomething.com/predict";
    var response = await client.post(url, body: {
      'seed': seed,
      'temperature': temp,
      'nwords': nwords,
      'artist': artist
    });

    predictions = json.decode(response.body)['words'];

    var logger = Logger();
    logger.d('Response: ' + response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: double.infinity,
      color: Colors.deepOrange,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Wrap(
              children: <Widget>[
                FutureBuilder(
                  future: getPredictions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Tags(
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
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
