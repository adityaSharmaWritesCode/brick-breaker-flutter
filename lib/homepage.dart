import 'package:brick_breaker/gamepage.dart';
import 'package:brick_breaker/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQueryObject = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.teal,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'B R I C K - B R E A K E R',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontSize: mediaQueryObject.size.width * 0.03,
                    ),
              ),
              SizedBox(
                height: mediaQueryObject.size.height * 0.07,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: mediaQueryObject.size.width * 0.015,
                      vertical: mediaQueryObject.size.height * 0.015,
                    )),
                onPressed: () {
                  Navigator.of(context).popAndPushNamed(GameScreen.route);
                },
                child: Text(
                  'Start Game',
                  style: GoogleFonts.amaranth(
                    color: Colors.green.shade700,
                    fontSize: 17.0,
                  ),
                ),
              ),
              SizedBox(
                height: mediaQueryObject.size.height * 0.02,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: mediaQueryObject.size.width * 0.015,
                        vertical: mediaQueryObject.size.height * 0.015,
                      )),
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed(SettingScreen.route);
                  },
                  child: Text(
                    'Settings',
                    style: GoogleFonts.amaranth(
                        color: Colors.green.shade700, fontSize: 17.0),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
