
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class SurveyModel {
  String title;
  String available;
  String dueDate;
  List<List<String>> options;
  Map rawMap;
  String prizeKey;


  SurveyModel(String title, Map rawMap) {
    this.title = title;
    this.rawMap = rawMap;
    options = new List();
    prizeKey = 'none';

    Map<dynamic, dynamic> contentMap = rawMap;
    contentMap.forEach((key, value) {
      if(key == 'Available') {
        available = value.toString();
      }
      else if(key == 'Date') {
        dueDate = value.toString();
      }
      else if(key == 'Prize') {
        prizeKey = value.toString();
      }
      else if(key == 'Questions') {
        Map<dynamic, dynamic> questionsMap = value;
        questionsMap.forEach((key1, value1) {
          List<String> optionsList = new List();
          optionsList.add('question: ' + key1);
          Map<dynamic, dynamic> eachOptionMap = value1;
          eachOptionMap.forEach((key2, value2) {
            if(key2.toString() == 'type') {
              optionsList.add('type: ' + value2.toString());
            } else {
              optionsList.add(value2.toString());
            }
          });
          options.add(optionsList);
        });
      }
    });
  }

  String getPrize() {
    return prizeKey;
  }

  List<List<String>> getOptions() {
    return options;
  }

  String getDate() {
    return dueDate;
  }

  String getTitle() {
    return title;
  }


  String getAvailable() {
    return available;
  }
}