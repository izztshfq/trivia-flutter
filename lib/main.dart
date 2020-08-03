import 'package:flutter/material.dart';
import 'package:trivia/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = new QuizBrain();
void main() => runApp(Trivia());

class Trivia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Widget> scoreKeeper = [
    Icon(Icons.star, color: Colors.orangeAccent),
    // Icon(Icons.close, color: Colors.red),
  ];

  int score = 0;
  int totalQuestion = quizBrain.totalQuestionNumber();

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getQuestionAnswer();

    setState(() {
      if (quizBrain.isFinished() == true) {
//        //Basic alert from rFlutter
//        Alert(
//          context: context,
//          title: 'Finished!',
//          desc: 'You\'ve reached the end of the quiz.',
//        ).show();
        scoreKeeper.add(Icon(Icons.flag, color: Colors.green));

        var alertStyle = AlertStyle(
          animationType: AnimationType.fromRight,
          isCloseButton: false,
          isOverlayTapDismiss: false,
          descStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          animationDuration: Duration(milliseconds: 400),
          backgroundColor: Colors.grey.shade800,
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: Colors.grey.shade900,
            ),
          ),
          titleStyle: TextStyle(
            color: Colors.white,
          ),
        );

        Alert(
          context: context,
          style: alertStyle,
          type: AlertType.none,
          title: "Finished!",
          desc: "You\'ve scored : $score / $totalQuestion ",
          buttons: [
            DialogButton(
              child: Text(
                "Cool!",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();

        //reset the question number
        quizBrain.reset();

        // reset scorekeeper list
        scoreKeeper = [
          Icon(Icons.star, color: Colors.orangeAccent),
        ];

        score = 0;
      }
      // Else question is not finished
      else {
        if (userPickedAnswer == correctAnswer) {
          score++;
          scoreKeeper.add(Icon(Icons.check, color: Colors.green));
        } else {
          scoreKeeper.add(Icon(Icons.close, color: Colors.red));
        }
      }

      quizBrain.nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
