import 'package:flutter/material.dart';
import 'package:world_time_app/services/search_bar.dart';
import 'package:world_time_app/services/world_time.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  List<WorldTime> locations = [
    WorldTime(url: 'Islamabad, Pakistan', location: 'Pakistan', flag: 'pakistan.png'),
    WorldTime(url: 'Delhi, India', location: 'India', flag: 'india.png'),
    WorldTime(url: 'London, UK', location: 'England', flag: 'england.png'),
    WorldTime(url: 'Cairo, Egypt', location: 'Egypt', flag: 'egypt.png'),
    WorldTime(url: 'Beijing, China', location: 'China', flag: 'china.png'),
    WorldTime(url: 'Athens, Greece', location: 'Greece', flag: 'greece.png'),
    WorldTime(url: 'Washington, USA', location: 'America', flag: 'america.png'),
    WorldTime(url: 'Ankara, Turkey', location: 'Turkey', flag: 'turkey.png'),
    WorldTime(url: 'Berlin, Germany', location: 'Germany', flag: 'germany.png'),
  ];

  void updateTime(index) async {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose location'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchBar(locations: locations));
            }
          ),
        ],
        centerTitle: false,
        elevation: 2.0,
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
            child: Card(
              child: ListTile(
                onTap: () {
                  updateTime(index);
                },
                title: Text(locations[index].location),
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/countries/${locations[index].flag}'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}