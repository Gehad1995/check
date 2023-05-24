import 'dart:async';
import 'dart:math';

import 'package:alqgp/Src/Models/chapter_model.dart';
import 'package:alqgp/Src/Models/quiz_model.dart';
import 'package:alqgp/Src/Services/database_repo.dart';
import 'package:get/get.dart';

class QuizController extends GetxController {
  static QuizController get instance => Get.find();

  final _databaseRepo = Get.put(DatabaseRepository());

  final Chapter chapter = Get.arguments;

  RxList<Quiz> questionsList = RxList<Quiz>();
  List<Quiz> get questions => questionsList;
  RxInt currentQuestionIndex = 0.obs;

  RxList<int> selectedAnswers = RxList<int>.filled(10, -1, growable: true);
  List<int> get answers => selectedAnswers;

  RxList<int> scoreList = RxList<int>.filled(10, -1, growable: true);
  List<int> get scores => scoreList;

  List<int> indexs = List<int>.filled(2, -1, growable: true);
  RxBool delete = true.obs;

  bool deleted = false;
  bool incremented = false;

  // RxInt timeer2 = 3.obs;

  RxDouble presentage = 0.0.obs;
  RxString photo = "".obs;
  RxString what2do = "somthing went wrong".obs;
  RxString title = "".obs;

  Timer? _timer;
  Timer? _timer2;
  int remainingSeconds = 1;
  final time = '00.00'.obs;

  @override
  void onReady() {
    _startTimer(600);
    super.onReady();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    // stream the questions from database to keep track of the changes
    questionsList.bindStream(_databaseRepo.getQuestions(chapter.chapNum!));
  }

  _startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainingSeconds = seconds;
    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainingSeconds == -1) {
        timer.cancel();
        currentQuestionIndex.value = questions.length - 1;
        delete.value = true;
        update();
      } else {
        int minutes = remainingSeconds ~/ 60;
        int seconds = (remainingSeconds % 60);
        time.value =
            "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
        remainingSeconds--;
      }
    });
  }

  startTimer2() {
    const duration = Duration(seconds: 1);
    int remainingSeconds2 = 1;
    _timer2 = Timer.periodic(duration, (Timer timer2) {
      if (remainingSeconds2 == 0) {
        timer2.cancel();
        if (Get.isDialogOpen ?? false) Get.back();
      } else {
        remainingSeconds2--;
      }
    });
  }

  incrementTime() {
    remainingSeconds = remainingSeconds + 10;
    incremented = true;
  }

  updateScore() {
    int sum = 0;
    for (int i = 0; i < scores.length; i++) {
      if (scores[i] != -1) {
        sum += scores[i];
      }
    }
    presentage.value = sum / questions.length;
    _databaseRepo.updateChapterScore(sum, chapter.chapNum!);
    update();
    return sum;
  }

// defines the grade of the user and what too write in the UI
  ABC() {
    if (presentage.value >= 0.8) {
      photo.value = "images/rating.png";
      what2do.value = " WoW you nailed it";
      title.value = "Perfect";
      return title.value;
    } else if (presentage.value >= 0.5) {
      photo.value = "images/star.png";
      what2do.value = "oh yeah, you got that";
      title.value = "Good";
      return title.value;
    } else {
      photo.value = "images/sad.png";
      what2do.value = "oooh, you can do better";
      title.value = "Oh No";
      return title.value;
    }
  }

// updatets the achievemnets in the database
  updateAchievements() {
    _databaseRepo.updateAchievement((presentage * questions.length).toInt(),
        chapter.chapterName!, photo.value, title.value);
  }

// keeps track on the selected answers by the user to change its color
  setSelectedAnswer(int index) {
    selectedAnswers[currentQuestionIndex.value] = index;
    print("the sssss selectd : $selectedAnswers");
  }

// moves the quiz ti hte next quetion
  next() {
    currentQuestionIndex.value = currentQuestionIndex.value + 1;
    delete.value = true;
    update();
  }

// keeps track on the user's score
  isCorrect(int score) {
    scoreList[currentQuestionIndex.value] = score;
    print("the kkkkk scores : $scores");
  }

// a counter for the question numbers
  questionNumber() {
    return currentQuestionIndex.value + 1;
  }

// get the length based on the the delete 2 answers hint
  getlength(bool NotdeleteAnswers) {
    if (NotdeleteAnswers) {
      return questions[currentQuestionIndex.value].answers!.length;
    } else {
      for (int i = 0;
          i < questionsList[currentQuestionIndex.value].answers!.length;
          i++) {
        if (questionsList[currentQuestionIndex.value].answers![i] ==
            questionsList[currentQuestionIndex.value].correct) {
          indexs[0] = i;
        }
      }

      late int rng;
      bool notIt = true;
      while (notIt) {
        rng = Random()
            .nextInt(questionsList[currentQuestionIndex.value].answers!.length);
        if (rng != indexs[0]) {
          notIt = false;
        }
      }
      indexs[1] = rng;
      indexs.shuffle();
      return indexs.length;
    }
  }
}
