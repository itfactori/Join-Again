

import 'package:flutter/cupertino.dart';

import '../models/events_model.dart';

class EventsProvider extends ChangeNotifier{
  List<EventsModel> events=[];

  List<EventsModel> eventsInRange=[];

  updateEvents(List<EventsModel> list){
    events=list;
    notifyListeners();
  }

  updateRange(List<EventsModel> events){
    eventsInRange=events;
    notifyListeners();
  }

}