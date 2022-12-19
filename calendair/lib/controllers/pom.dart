import 'dart:math';

class Scheduletime {
  Scheduletime();

  List<int> startScheduling(List<int> initTimes, int newClassDuration) {
    double avg = initTimes.fold<int>(newClassDuration,
            (int previousValue, int element) => previousValue + element) /
        initTimes.length;
    List<int> times = List.from(initTimes);
    List<int> addedTimes = List.generate(times.length, (index) => 0);

    int restTime = newClassDuration;

    while (restTime > 0) {
      List<List<int>> p =
          generateStates(addedTimes, restTime, newClassDuration, avg);
      //  print("object");
      //   print(p);
      //  print("object");
      List<int> bestTemp = getBestState(initTimes, p, avg);

      //    print("-------------------------");
      // print(bestTemp);
      //    print("*****");

      restTime -= (getSumOfList(bestTemp) - getSumOfList(addedTimes));
      //  print(restTime);
      addedTimes = bestTemp;
    }

    //  print(times);
    //  print(addedTimes);
    initTimes = sumList(times, addedTimes);
    return addedTimes;
  }

  double evaluate(List<int> times, double avg) {
    return times.fold<double>(
        0,
        (double previousValue, int element) =>
            (previousValue + pow((element - avg), 2)));
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places).toDouble();
    return ((value * mod).round().toDouble() / mod);
  }

  List<int> getBestState(
      List<int> times, List<List<int>> addedTimes, double avg) {
    double bestEvl = double.infinity;
    int bestIndex = 0;

    for (int i = 0; i < addedTimes.length; i++) {
      double evl = roundDouble(evaluate(sumList(times, addedTimes[i]), avg), 3);
      if (evl < bestEvl) {
        bestEvl = evl;
        bestIndex = i;
      }
    }
    return addedTimes[bestIndex];
  }

  List<int> sumList(List<int> list1, List<int> list2) {
    List<int> temp = List.from(list1);
    for (var i = 0; i < list1.length; i++) {
      temp[i] += list2[i];
    }
    return temp;
  }

  int getSumOfList(List<int> list) {
    int sum = 0;
    for (var el in list) {
      sum += el;
    }
    return sum;
  }

  List<List<int>> generateStates(
      List<int> addedTimes, int restTime, int newClassDuration, double avg) {
    List<List<int>> retList = [];

    for (int i = 0; i < addedTimes.length; i++) {
      int incrTime = 0;

      if (addedTimes[i] > 0) {
        if (restTime >= 5) {
          // if (addedTimes[i] > avg && restTime >= 10) {
          //    continue;
          // }
          incrTime += 5;
        } else {
          incrTime = restTime;
        }
      } else {
        if (restTime >= 10) {
          incrTime = 10;
        } else {
          if (newClassDuration < 10) {
            incrTime = restTime;
          } else {
            continue;
          }
        }
      }
      addedTimes[i] += incrTime;
      retList.add(List.from(addedTimes));
      addedTimes[i] -= incrTime;
    }
    return retList;
  }

/*
  List<int> startScheduling(List<int> times, int newClassDuration) {
    double avg = times.fold<int>(newClassDuration,
            (int previousValue, int element) => previousValue + element) /
        times.length;

    print(generateBestState(times, List.generate(times.length, (index) => 0),
        newClassDuration, newClassDuration, avg));

    return [];
  }

  double evaluate(List<int> times, double avg) {
//    double avg = times.fold<int>(newClassDuration,
    //           (int previousValue, int element) => previousValue + element) /
    //       times.length;
    return times.fold<double>(
        0,
        (double previousValue, int element) =>
            (previousValue + pow((element - avg), 2)));
  }

  List<int> generateBestState(List<int> times, List<int> addedTimes,
      int restTime, int newClassDuration, double avg) {
    while (restTime > 0) {
      //  List<int> bestState = [];
      double bestEvaluate = double.infinity;
      int bestIncrTime = 0;
      int incrTime = 0;
      int bestIndex = 0;
      // List<int> oldTimes = List.from(times);
      for (int i = 0; i < addedTimes.length; i++) {
        if (addedTimes[i] > 0) {
          if (restTime >= 2) {
            incrTime += 2;
          } else {
            incrTime = restTime;
          }
        } else {
          if (restTime >= 10) {
            incrTime = 10;
          } else {
            if (newClassDuration < 10) {
              incrTime = restTime;
            } else {
              continue;
            }
          }
        }

        addedTimes[i] += incrTime;
        times[i] += incrTime;

        double newEvl = evaluate(times, avg);

        if (bestEvaluate > newEvl) {
          bestEvaluate = newEvl;
          //bestState = List.from(times);
          bestIndex = i;
          bestIncrTime = incrTime;
        }

        times[i] -= incrTime;
        addedTimes[i] -= incrTime;
      } //for

      //  times = List.from(bestState);
      restTime -= bestIncrTime;
      times[bestIndex] += bestIncrTime;
      addedTimes[bestIndex] += bestIncrTime;
      print(addedTimes);
    } //while
    print(addedTimes);
    return times;
    //  return {"list": bestState, "incrTime": bestIncrTime};
  }*/
}
