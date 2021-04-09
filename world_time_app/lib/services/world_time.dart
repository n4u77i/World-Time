import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class WorldTime {
  String location; // Location time for UI
  String time; // Time for that location
  String date; // Date for that location
  String flag; // URL to asset flag icon
  String url; // Location URL for API endpoint
  bool isDayTime; // Time to check whether day or night

  WorldTime({ this.location, this.flag, this.url });

  Future<void> getTime() async {
    try {
      // Making the request
      Response response = await get('https://timezone.abstractapi.com/v1/current_time?api_key=326c6676ef714739a4008498ad01c50e&location=$url');
      //print(response.body);

      if(response.statusCode == 200) {
        Map data = jsonDecode(response.body);

        //Getting 'data' properties
        String datetime = data['datetime'];
        int offset = data['gmt_offset'];

        // print(datetime);
        // print(offset);

        DateTime now = DateTime.parse(datetime);
        now.add(Duration(hours: offset));
        time = DateFormat.jm().format(now);
        date = DateFormat.yMMMMd().format(now);

        isDayTime = now.hour > 6 && now.hour < 19 ? true : false;
      }
      else {
        time = 'Could not get time from API';
        date = 'Could not get date from API';
      }
    } catch (e) {
      time = 'Could not get time data';
      date = 'Could not get data data';
    }
  }
}