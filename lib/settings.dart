import 'package:brick_breaker/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingScreen extends StatefulWidget {
  static const route = '/settings';
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  double ballSpeed = 1.0;
  double plSpeed = 1.0;
  @override
  Widget build(BuildContext context) {
    final mediaQueryObject = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Container(
          width: mediaQueryObject.size.width * 0.5,
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
                  style: GoogleFonts.amaranth(
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
                        label: ballSpeed.toString() + 'x',
                        value: ballSpeed,
                        onChanged: (val) {
                          setState(() {
                            ballSpeed = val;
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
                SizedBox(height: mediaQueryObject.size.height * 0.015),
                Text(
                  'Player Speed',
                  style: GoogleFonts.amaranth(
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
                        label: plSpeed.toString() + 'x',
                        value: plSpeed,
                        onChanged: (val) {
                          setState(() {
                            plSpeed = val;
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
                    Navigator.of(context).popAndPushNamed(HomeScreen.route);
                  },
                  child: Text(
                    'Save Changes',
                    style: GoogleFonts.amaranth(
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
