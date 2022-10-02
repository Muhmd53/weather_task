import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/services/weather_service.dart';
import 'package:weather/weather_screen.dart';

class SelectCity extends StatefulWidget {
  const SelectCity({Key? key}) : super(key: key);

  @override
  _SelectCityState createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> with WidgetsBindingObserver {
  List<String> history = [];
  TextEditingController city = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  GlobalKey renderKey = LabeledGlobalKey('TextField');
  double? height, width, xPosition, yPosition;
  FocusNode _focus = FocusNode();
  OverlayEntry? floatingHistory;
  bool getting = false;
  Future<bool> get keyboardHidden async {
    final check = () => (WidgetsBinding.instance?.window.viewInsets.bottom ?? 0) <= 0;
    if (!check()) return false;
    return await Future.delayed(const Duration(milliseconds: 100), () => check());
  }
  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    keyboardHidden.then((value) async {
      if(floatingHistory != null)
        {
          floatingHistory!.remove();
          floatingHistory = null;
          await Future.delayed(const Duration(milliseconds: 200), (){
            findRenderObject();
            floatingHistory = _createHistory();
            Overlay.of(context)!.insert(floatingHistory!);
          });
        }
    });
  }
  void findRenderObject()
  {
    RenderBox renderBox = renderKey.currentContext!.findRenderObject() as RenderBox;
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
  }
  void getHistory() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString("History");
    if(json != null)
      {
        history = List<String>.from(jsonDecode(json));
      }
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _focus.addListener(_onFocusChange);
    getHistory();
  }
  void _onFocusChange() async {
    if(_focus.hasFocus && floatingHistory == null)
      {
        if(history.isNotEmpty)
          {
            await Future.delayed(const Duration(milliseconds: 200), (){
              findRenderObject();
              floatingHistory = _createHistory();
              Overlay.of(context)!.insert(floatingHistory!);
            });
          }
      }
    else
      {
        if(floatingHistory != null)
          {
            floatingHistory!.remove();
            floatingHistory = null;
          }
      }
    setState(() {

    });
  }
  OverlayEntry _createHistory() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition!,
        width: width!,
        top: yPosition! + height! + 10,
        height: 3 * height!,
        child: Material(
          color: Colors.black12,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          child: Container(

            decoration: BoxDecoration(
                color: Colors.black87,
              borderRadius: BorderRadius.circular(10)
            ),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: history.length,
              itemBuilder: (context, index)
              {
                return GestureDetector(
                  onTap: ()
                  {
                    setState(() {
                      city.text = history[index];
                      floatingHistory!.remove();
                      floatingHistory = null;
                      WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();

                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: const BoxDecoration(),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.white, size: MediaQuery.of(context).size.height * 0.025,),
                        const SizedBox(width: 10),
                        Expanded(child: Text(history[index], style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.height * 0.02),)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: ()
        {
          WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
          if(floatingHistory != null)
            {
              floatingHistory!.remove();
              floatingHistory = null;
            }
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.fitWidth
            )
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 25,
            bottom: MediaQuery.of(context).padding.bottom + 25,
            right: 20,
            left: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Weather App', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),)),
                const Spacer(),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        key: renderKey,
                        focusNode: _focus,
                        textInputAction: TextInputAction.go,
                        controller: city,
                        validator: (val) {
                          RegExp regex = RegExp(r"^[a-zA-Z]+$");
                          if (!regex.hasMatch(val!.trim())) {
                            return 'Enter Valid City';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (_)
                        {
                          _formKey.currentState!.validate();
                        },
                        decoration: InputDecoration(

                            hintText: "Enter City..",
                            prefixIcon: Container(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                margin: const EdgeInsets.only(right: 10.0),
                                decoration: const BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6.0),
                                        bottomLeft: Radius.circular(6.0),
                                        topRight: Radius.circular(0),
                                        bottomRight: Radius.circular(0))),
                                child: const Icon(
                                  CupertinoIcons.building_2_fill,
                                  color: Colors.white,
                                )),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 13)),


                      ),
                      const SizedBox(height: 15),
                      getting ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Getting Info', style: TextStyle(color: Colors.white, fontSize: 16),)
                        ],
                      ) : ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12.5, horizontal: 17.5)),
                          ),
                          onPressed: () async {
                            if(_formKey.currentState!.validate())
                              {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                if(!history.contains(city.text.trim()))
                                  {
                                    history.add(city.text.trim());
                                  }
                                prefs.setString('History', jsonEncode(history));
                                setState(() {
                                  getting = true;
                                });
                                String resultWeather = await WeatherService().getWeather(city.text.trim());
                                String resultForecast = "-1";
                                if(resultWeather != "-1")
                                  {
                                    var temp = jsonDecode(resultWeather);
                                    resultForecast = await WeatherService().getForecast(temp['coord']['lat'].toString(), temp['coord']['lon'].toString());
                                  }
                                setState(() {
                                  getting = false;
                                });
                                if(resultWeather == "-1" || resultForecast == "-1")
                                  {
                                    Fluttertoast.showToast(
                                        msg: "An Error Occurred",
                                        toastLength: Toast.LENGTH_SHORT,
                                    );
                                  }
                                else
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherScreen(info: resultWeather, forecast: resultForecast,)));
                                  }
                              }
                          }, child: const Text('Get Weather', style: TextStyle(color: Colors.white),)),

                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
