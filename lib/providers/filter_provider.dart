

import 'package:flutter/cupertino.dart';

class FilterProvider extends ChangeNotifier{
  bool showMyLocation=true;
  bool showUsers=false;
  bool showEvents=false;
  int mapRangeInMetersHolder = 100;
  int dayValueHolder=5;

  updateShowMyLocation(bool value){
    showMyLocation=value;
    notifyListeners();
  }
  updateShowUsers(bool value){
    showUsers=value;
    notifyListeners();
  }

  updateShowEvents(bool value){
    showEvents=value;
    notifyListeners();
  }

  updateMapRange(int value){
    mapRangeInMetersHolder=value;
    notifyListeners();
  }

  updateDays(int value){
    dayValueHolder=value;
    notifyListeners();
  }

}