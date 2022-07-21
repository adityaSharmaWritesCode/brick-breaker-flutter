import 'package:brick_breaker/gamepage.dart';
import 'package:brick_breaker/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
                kIsWeb
                    ? 'B R I C K - B R E A K E R'
                    : 'B R I C K \n\nB R E A K E R',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: kIsWeb
                        ? mediaQueryObject.size.width * 0.035
                        : mediaQueryObject.size.height * 0.025),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: mediaQueryObject.size.height * 0.07,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: mediaQueryObject.size.width * 0.02,
                          vertical: kIsWeb
                              ? mediaQueryObject.size.height * 0.02
                              : mediaQueryObject.size.height * 0.015,
                        )),
                    onPressed: () {
                      Navigator.of(context).pushNamed(GameScreen.route);
                    },
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: kIsWeb ? 20 : mediaQueryObject.size.height * 0.03,
                    ),
                  ),
                  SizedBox(
                    width: mediaQueryObject.size.width * 0.03,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: mediaQueryObject.size.width * 0.02,
                          vertical: kIsWeb
                              ? mediaQueryObject.size.height * 0.02
                              : mediaQueryObject.size.height * 0.015,
                        )),
                    onPressed: () {
                      Navigator.of(context).pushNamed(SettingScreen.route);
                    },
                    child: Icon(
                      Icons.settings_rounded,
                      size: kIsWeb ? 20 : mediaQueryObject.size.height * 0.03,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: mediaQueryObject.size.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
