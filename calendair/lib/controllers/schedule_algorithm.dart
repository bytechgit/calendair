import 'dart:math';

class ScheduleAlgorithm {
  ScheduleAlgorithm();

  List<int> startScheduling(
      {required List<int> initTimes,
      required int newClassDuration,
      List<int>? startTimes}) {
    double avg = initTimes.fold<int>(newClassDuration,
            (int previousValue, int element) => previousValue + element) /
        initTimes.length;
    List<int> times = List.from(initTimes);
    List<int> addedTimes =
        startTimes ?? List.generate(times.length, (index) => 0);

    int restTime = newClassDuration;

    while (restTime > 0) {
      List<List<int>> p =
          _generateStates(addedTimes, restTime, newClassDuration, avg);
      List<int> bestTemp = _getBestState(initTimes, p, avg);
      restTime -= (_getSumOfList(bestTemp) - _getSumOfList(addedTimes));
      addedTimes = bestTemp;
    }
    initTimes = _sumList(times, addedTimes);
    return addedTimes;
  }

  double _evaluate(List<int> times, double avg) {
    return times.fold<double>(
        0,
        (double previousValue, int element) =>
            (previousValue + pow((element - avg), 2)));
  }

  double _roundDouble(double value, int places) {
    double mod = pow(10.0, places).toDouble();
    return ((value * mod).round().toDouble() / mod);
  }

  List<int> _getBestState(
      List<int> times, List<List<int>> addedTimes, double avg) {
    double bestEvl = double.infinity;
    int bestIndex = 0;

    for (int i = 0; i < addedTimes.length; i++) {
      double evl =
          _roundDouble(_evaluate(_sumList(times, addedTimes[i]), avg), 3);
      if (evl < bestEvl) {
        bestEvl = evl;
        bestIndex = i;
      }
    }
    return addedTimes[bestIndex];
  }

  List<int> _sumList(List<int> list1, List<int> list2) {
    List<int> temp = List.from(list1);
    for (var i = 0; i < list1.length; i++) {
      temp[i] += list2[i];
    }
    return temp;
  }

  int _getSumOfList(List<int> list) {
    int sum = 0;
    for (var el in list) {
      sum += el;
    }
    return sum;
  }

  List<List<int>> _generateStates(
      List<int> addedTimes, int restTime, int newClassDuration, double avg) {
    List<List<int>> retList = [];

    for (int i = 0; i < addedTimes.length; i++) {
      int incrTime = 0;

      if (addedTimes[i] > 0) {
        if (restTime >= 5) {
          incrTime += 5;
        } else {
          incrTime = restTime;
        }
      } else {
        if (restTime >= 15) {
          incrTime = 15;
        } else {
          if (newClassDuration < 15) {
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
}
