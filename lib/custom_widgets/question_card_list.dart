import 'package:flutter/material.dart';
import 'package:flutterapp/custom_widgets/question_card.dart';

class QuestionCardList {
  List<QuestionCard> _questionCardList;
  bool areQuestionsLoaded;

  QuestionCardList(this.areQuestionsLoaded, this._questionCardList);


  Widget getCardsListWidget() {
    return areQuestionsLoaded == true
        ? getList() : Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getList() {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: _questionCardList.length,
      itemBuilder: (context, index) {
        return _questionCardList[index];
      },
    );
  }
}