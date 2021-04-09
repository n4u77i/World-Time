import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    // If data is empty, the 'ModalRoute' will initialize the data
    // If data is not empty, we need updated data from 'Choose Location Screen'
    data = data.isEmpty ? ModalRoute.of(context).settings.arguments : data;
    print(data);

    String bgImage;
    Color bgColor;
    bool isValidData; // To check if API is returning time and date

    try {
      bgImage = data['isDayTime'] ? 'day.png' : 'night.png';
      bgColor = data['isDayTime'] ? Colors.blue : Colors.indigo;
      isValidData = true;
    } catch (e) {
      bgImage = 'day.png';
      bgColor = Colors.blue;
      isValidData = false;
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/$bgImage'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 120.0, 0.0, 0.0),
            child: Column(
              children: [
                FlatButton.icon(
                  onPressed: () async {
                    // It's a big async task, we'll store result in 'dynamic' because we don't know what we get
                    // 'Dynamic' is pretty much same as 'Var'
                    dynamic result = await Navigator.pushNamed(context, '/location');

                    // Updates the data
                    setState(() {
                      data = {
                        'location': result['location'],
                        'time': result['time'],
                        'flag': result['flag'],
                        'date': result['date'],
                        'isDayTime': result['isDayTime'],
                      };
                    });
                  },
                  icon: Icon(
                    Icons.edit_location,
                    color: Colors.grey[300],
                  ),
                  label: Text(
                    'Edit location',
                    style: TextStyle(
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['location'],
                      style: TextStyle(
                        fontSize: 28.0,
                        letterSpacing: 2.0,
                        color: Colors.grey[300]
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),
                isValidData ?
                Column(
                  children: [
                    Text(
                      data['time'],
                      style: TextStyle(
                          fontSize: 66.0,
                          color: Colors.grey[300]
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Text(
                      data['date'],
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey[300],
                      ),
                    )
                  ],
                )
                : Text(
                  'Sorry! Could not get data from API',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.grey[300],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
