import 'package:shared_preferences/shared_preferences.dart';

class Speed {
  double? _ballSpeed = 0.01;
  double? _playerSpeed = 0.2;

  double? getBallSpeed() {
    setBallSpeed();
    return _ballSpeed;
  }

  double? getPlayerSpeed() {
    setPlayerSpeed();
    return _playerSpeed;
  }

  void setBallSpeed() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('bSpeed')) {
      prefs.setDouble('bSpeed', _ballSpeed!);
    }
  }

  void setPlayerSpeed() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('pSpeed')) {
      prefs.setDouble('pSpeed', _playerSpeed!);
    }
  }

  void updateBallSpeed(double val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('bSpeed', val);
    _ballSpeed = prefs.getDouble('bSpeed');
  }

  void updatePlayerSpeed(double val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('pSpeed', val);
    _playerSpeed = val;
  }

  void removeBallSpeed() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('bSpeed');
  }

  void removePlayerSpeed() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('pSpeed');
  }
}
