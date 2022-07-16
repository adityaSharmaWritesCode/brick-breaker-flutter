import 'package:brick_breaker/homepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  static const route = '/settings';
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  double _ballSpeed = 1.0;
  double _plWidth = 1.0;

  void loadSpeeds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ballSpeed = prefs.getDouble('bs') ?? 1.0;
      _plWidth = prefs.getDouble('pw') ?? 1.0;
    });
  }

  void saveSpeeds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble('bs', _ballSpeed);
      prefs.setDouble('pw', _plWidth);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSpeeds();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryObject = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Container(
          width: mediaQueryObject.size.width * 0.7,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'S E T T I N G S',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: mediaQueryObject.size.width * 0.03,
                      ),
                ),
                SizedBox(
                  height: mediaQueryObject.size.height * 0.08,
                ),
                Text(
                  'Ball Speed',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.slow_motion_video,
                        color: Colors.tealAccent,
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Slider(
                        activeColor: Colors.tealAccent,
                        inactiveColor: Colors.grey.shade300,
                        label: _ballSpeed.toString() + 'x',
                        value: _ballSpeed,
                        onChanged: (val) {
                          setState(() {
                            _ballSpeed = val;
                          });
                        },
                        min: 0.5,
                        max: 1.5,
                        divisions: 2,
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.fast_forward,
                        color: Colors.tealAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: mediaQueryObject.size.height * 0.025),
                Text(
                  'Player Width',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.slow_motion_video,
                        color: Colors.tealAccent,
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Slider(
                        activeColor: Colors.tealAccent,
                        inactiveColor: Colors.grey.shade300,
                        label: '${_plWidth}x',
                        value: _plWidth,
                        onChanged: (val) {
                          setState(() {
                            _plWidth = val;
                          });
                        },
                        min: 0.5,
                        max: 1.5,
                        divisions: 2,
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.fast_forward,
                        color: Colors.tealAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: mediaQueryObject.size.height * 0.04),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: mediaQueryObject.size.width * 0.015,
                        vertical: mediaQueryObject.size.height * 0.015,
                      )),
                  onPressed: () {
                    saveSpeeds();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Save Changes',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Colors.green.shade700,
                          fontSize: 17.0,
                        ),
                  ),
                ),
              ]),
        ),
      ),
    ));
  }
}
