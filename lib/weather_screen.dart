import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  final String info;
  final String forecast;
  const WeatherScreen({Key? key, required this.info, required this.forecast}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  var map;
  List<dynamic> list = [];
  @override
  void initState() {
    map = jsonDecode(widget.info);
    list = (jsonDecode(widget.forecast))['daily'];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(map['name'], style: const TextStyle(color: Colors.white),),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.fitWidth
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 25,
            bottom: MediaQuery.of(context).padding.bottom + 25,
            right: 20,
            left: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network('https://openweathermap.org/img/wn/${map['weather'][0]['icon']}@2x.png', height: MediaQuery.of(context).size.height * 0.125, width: MediaQuery.of(context).size.height * 0.125, fit: BoxFit.fill, color: Colors.white,),

                  Text(
                    '${map['main']['temp'].round()}°',

                    style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.1, color: map['main']['temp'].round() < 10 ? Colors.lightBlue : map['main']['temp'].round() >= 10 && map['main']['temp'].round() <= 20 ? Colors.black : Colors.red),
                  ),
                  const SizedBox(width: 5,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${map['main']['temp_max'].round()}°',
                        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02, color: Colors.white),
                      ),
                      const SizedBox(height: 7.5,),
                      Text(
                        '${map['main']['temp_min'].round()}°',
                        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02, color: Colors.grey[300]),
                      ),
                    ],
                  )
                ],
              ),


              Text(map['weather'][0]['main'], style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.0275, color: Colors.white),),
              const SizedBox(height: 10),
              Text(
                'Real Feel ${map['main']['feels_like'].round()}°',
                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.0225, color: Colors.grey[300]),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.droplet, size: MediaQuery.of(context).size.height * 0.02, color: Colors.white,),
                      const SizedBox(height: 7.5),
                      Text(
                        '${map['main']['humidity'].round()}°',
                        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02, color: Colors.white),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 40,
                    child: VerticalDivider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.wind, size: MediaQuery.of(context).size.height * 0.02, color: Colors.white,),
                      const SizedBox(height: 7.5),
                      Text(
                        '${map['wind']['speed'].round()} m/s',
                        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02, color: Colors.white),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 40,
                    child: VerticalDivider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),

                  Expanded(
                      flex: 3,
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(FontAwesomeIcons.arrowDown, size: MediaQuery.of(context).size.height * 0.016, color: Colors.white,),
                          const SizedBox(width: 2.5,),
                          Icon(FontAwesomeIcons.sun, size: MediaQuery.of(context).size.height * 0.02, color: Colors.white,),
                          const SizedBox(width: 2.5,),
                          Icon(FontAwesomeIcons.arrowUp, size: MediaQuery.of(context).size.height * 0.016, color: Colors.white,),
                        ],
                      ),
                      const SizedBox(height: 7.5),

                      Text(
                        '${DateFormat('hh:mm').format(DateTime.fromMillisecondsSinceEpoch(map['sys']['sunset'] * 1000))}  ${DateFormat('hh:mm').format(DateTime.fromMillisecondsSinceEpoch(map['sys']['sunrise'] * 1000))}',
                        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02, color: Colors.white),
                      ),
                    ],
                  ))
                ],
              ),
              const SizedBox(height: 15,),
              Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: list.length,
                    itemBuilder: (context, index)
                    {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: const BoxDecoration(
                          color: Colors.black12
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Text(DateFormat('EEEE').format(DateTime.fromMillisecondsSinceEpoch(list[index]['dt'] * 1000)), style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.0225, color: Colors.white),),),
                            Image.network('https://openweathermap.org/img/wn/${list[index]['weather'][0]['icon']}@2x.png', height: MediaQuery.of(context).size.height * 0.06, width: MediaQuery.of(context).size.height * 0.06, fit: BoxFit.fill, color: Colors.white,),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${list[index]['temp']['max'].round()}°', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02, color: Colors.white),),
                                const SizedBox(width: 2.5,),
                                Text('/', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02, color: Colors.white),),
                                const SizedBox(width: 2.5,),
                                Text('${list[index]['temp']['min'].round()}°', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02, color: Colors.grey[300]),),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
