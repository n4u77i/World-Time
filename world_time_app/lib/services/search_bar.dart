import 'package:flutter/material.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:world_time_app/services/world_time.dart';
import 'package:speech_recognition/speech_recognition.dart';

class SearchBar extends SearchDelegate {
  List<WorldTime> locations = [];
  WorldTime instance;
  //VoiceSearch voiceSearch = VoiceSearch();

  SearchBar({ this.locations });

  void updateTime(context, index) async {
    WorldTime instance = locations[index];
    await instance.getTime();

    // Navigate back to Home screen
    Navigator.pop(context, {
      'location': instance.location,
      'time': instance.time,
      'flag': instance.flag,
      'date': instance.date,
      'isDayTime': instance.isDayTime,
    });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }
      ),
      // TODO: Voice search module
      VoiceSearch()
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      child: Card(
        child: ListTile(
          onTap: () {
            //updateTime(context, instance);
            print(instance.location);
            this.close(context, this.query);
          },
          title: Text(instance.location),
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/countries/${instance.flag}'),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions of search bar text
    final suggestions = query.isEmpty ? locations.sublist(0, 4)
        : locations.where((country) => country.location.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            instance = suggestions[index];
            showResults(context);
          },
          leading: Icon(Icons.location_city),
          title: RichText(
            text: TextSpan(
                text: suggestions[index].location.substring(0, query.length),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black54,
                ),
                children: [
                  TextSpan(
                    text: suggestions[index].location.substring(query.length),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ]
            ),
          ),
        );
      },
    );
  }
}

class VoiceSearch extends StatefulWidget {
  @override
  _VoiceSearchState createState() => _VoiceSearchState();
}

class _VoiceSearchState extends State<VoiceSearch> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
          (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
          () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
          (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
          () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HoldDetector(
      onHold: () {
        print('Hold detected');
        if (_isAvailable && !_isListening)
          _speechRecognition
              .listen(locale: "en_US")
              .then((result) => print('$result'));
      },
      child: IconButton(
        icon: Icon(Icons.mic),
        onPressed: () {
          print('Tap Detected');
          if (_isListening)
            _speechRecognition.cancel().then(
              (result) => setState(() {
              _isListening = result;
              resultText = "";
            }),
          );
        },
      ),
      onCancel: () {
        print('Cancel detected');
        if (_isListening)
          _speechRecognition.stop().then(
            (result) => setState(() => _isListening = result),
          );
      },
    );
  }
}