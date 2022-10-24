import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotter/main.dart';

import '../../models/task_model.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<String> sampleStats = [
    'Study Session Time',
    'Tasks Completed',
    'Good Mood',
    'Bad Mood',
    'Diaries written'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg2.png'), fit: BoxFit.cover)),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
                height: 25,
                width: 400,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/banner.png'),
                        fit: BoxFit.fill)),
                child: const Center(
                    child: Text('7-Day Task Completed',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)))),
            const SizedBox(height: 5),
            const TaskCompletionGraph(),
            const SizedBox(height: 10),
            Container(
                height: 25,
                width: 400,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/banner.png'),
                        fit: BoxFit.fill)),
                child: const Center(
                    child: Text('Study Sessions Time',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)))),
            const SizedBox(height: 5),
            const StudySessionTimeGraph(),
            const SizedBox(height: 20),
          ],
        ));
  }
}

class TaskCompletionGraph extends StatefulWidget {
  const TaskCompletionGraph({Key? key}) : super(key: key);

  @override
  State<TaskCompletionGraph> createState() => _TaskCompletionGraphState();
}

class _TaskCompletionGraphState extends State<TaskCompletionGraph> {
  List<double> sampleTaskCompletionData = [7, 3, 6, 9, 0, 0, 0];
  int touchedIndex = -1;

  double completedTaskCountForDay(DateTime date) {
    return objectbox.findTaskDate(date) == null
        ? 0
        : objectbox
            .getTaskListByDate(date)
            .where((element) => element.completed == true)
            .length
            .toDouble();
  }

  @override
  void initState() {
    super.initState();

    sampleTaskCompletionData = [
      completedTaskCountForDay(
          DateTime.now().subtract(const Duration(days: 6))),
      completedTaskCountForDay(
          DateTime.now().subtract(const Duration(days: 5))),
      completedTaskCountForDay(
          DateTime.now().subtract(const Duration(days: 4))),
      completedTaskCountForDay(
          DateTime.now().subtract(const Duration(days: 3))),
      completedTaskCountForDay(
          DateTime.now().subtract(const Duration(days: 2))),
      completedTaskCountForDay(
          DateTime.now().subtract(const Duration(days: 1))),
      completedTaskCountForDay(DateTime.now()),
    ];
  }

  BarChartGroupData taskCompletedDataGroup(
    int weekday,
    double height, {
    bool isTouched = false,
    Color barColor = Colors.yellow,
    double width = 25,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: weekday,
      barRods: [
        BarChartRodData(
          toY: isTouched ? height + 1 : height,
          color: isTouched ? Colors.orange : barColor,
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Colors.white, width: 5)
              : const BorderSide(color: Colors.white, width: 2),
          //This is the background of the bar graph tubes idk why it's called 'back'
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10,
            color: Colors.green[400],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showData() => List.generate(7, (index) {
        return taskCompletedDataGroup(index, sampleTaskCompletionData[index],
            isTouched: index == touchedIndex);
      });

  BarChartData taskCompletedData() {
    return BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.black,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String weekDay;
                switch (group.x.toInt()) {
                  case 0:
                    weekDay = DateFormat("MMMd")
                        .format(DateTime.now().subtract(Duration(days: 6)));
                    break;
                  case 1:
                    weekDay = DateFormat("MMMd")
                        .format(DateTime.now().subtract(Duration(days: 5)));
                    break;
                  case 2:
                    weekDay = DateFormat("MMMd")
                        .format(DateTime.now().subtract(Duration(days: 4)));
                    break;
                  case 3:
                    weekDay = DateFormat("MMMd")
                        .format(DateTime.now().subtract(Duration(days: 3)));
                    break;
                  case 4:
                    weekDay = DateFormat("MMMd")
                        .format(DateTime.now().subtract(Duration(days: 2)));
                    break;
                  case 5:
                    weekDay = DateFormat("MMMd")
                        .format(DateTime.now().subtract(Duration(days: 1)));
                    break;
                  case 6:
                    weekDay = DateFormat("MMMd").format(DateTime.now());
                    break;
                  default:
                    throw Error();
                }
                return BarTooltipItem(
                  '$weekDay  ',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: (rod.toY - 1).toString(),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                );
              }),
          touchCallback: (FlTouchEvent event, barTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  barTouchResponse == null ||
                  barTouchResponse.spot == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            });
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: weekdayAbbreviation,
              reservedSize: 38,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: showData(),
        gridData: FlGridData(show: false));
  }

  Widget weekdayAbbreviation(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(
            '${DateTime.now().subtract(Duration(days: 6)).month}/${DateTime.now().subtract(Duration(days: 6)).day}\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 1:
        text = Text(
            '${DateTime.now().subtract(Duration(days: 5)).month}/${DateTime.now().subtract(Duration(days: 5)).day}\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 2:
        text = Text(
            '${DateTime.now().subtract(Duration(days: 4)).month}/${DateTime.now().subtract(Duration(days: 4)).day}\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 3:
        text = Text(
            '${DateTime.now().subtract(Duration(days: 3)).month}/${DateTime.now().subtract(Duration(days: 3)).day}\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 4:
        text = Text(
            '${DateTime.now().subtract(Duration(days: 2)).month}/${DateTime.now().subtract(Duration(days: 2)).day}\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 5:
        text = Text(
            '${DateTime.now().subtract(Duration(days: 1)).month}/${DateTime.now().subtract(Duration(days: 1)).day}\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 6:
        text = Text(
            '${DateTime.now().month}/${DateTime.now().day}\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                  padding: const EdgeInsets.all(15),
                  child: BarChart(taskCompletedData())),
            )));
  }
}

class StudySessionTimeGraph extends StatefulWidget {
  const StudySessionTimeGraph({Key? key}) : super(key: key);

  @override
  State<StudySessionTimeGraph> createState() => _StudySessionTimeGraphState();
}

class _StudySessionTimeGraphState extends State<StudySessionTimeGraph> {
  List<double> sampleTaskCompletionData = [7, 3, 6, 9, 5, 2, 1];
  int touchedIndex = -1;

  BarChartGroupData taskCompletedDataGroup(
    int weekday,
    double height, {
    bool isTouched = false,
    double width = 25,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: weekday,
      barRods: [
        BarChartRodData(
          toY: isTouched ? height + 1 : height,
          color: isTouched ? Colors.blue[600] : Colors.blue[300],
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Colors.yellow, width: 5)
              : const BorderSide(color: Colors.yellow, width: 2),
          //This is the background of the bar graph tubes idk why it's called 'back'
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10,
            color: Colors.orange[700],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showData() => List.generate(7, (index) {
        return taskCompletedDataGroup(index, sampleTaskCompletionData[index],
            isTouched: index == touchedIndex);
      });

  BarChartData taskCompletedData() {
    return BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.black,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String weekDay;
                switch (group.x.toInt()) {
                  case 0:
                    weekDay = DateFormat("MMMd")
                        .format(DateTime.now().subtract(Duration(days: 6)));
                    break;
                  case 1:
                    weekDay = DateFormat("MMMd")
                        .format(DateTime.now().subtract(Duration(days: 5)));
                    break;
                  case 2:
                    weekDay = DateFormat("MMMd")
                        .format(DateTime.now().subtract(Duration(days: 4)));
                    break;
                  case 3:
                    weekDay = DateFormat("MMMd")
                        .format(DateTime.now().subtract(Duration(days: 3)));
                    break;
                  case 4:
                    weekDay = DateFormat("MMMd")
                        .format(DateTime.now().subtract(Duration(days: 2)));
                    break;
                  case 5:
                    weekDay = DateFormat("MMMd")
                        .format(DateTime.now().subtract(Duration(days: 1)));
                    break;
                  case 6:
                    weekDay = DateFormat("MMMd").format(DateTime.now());
                    break;
                  default:
                    throw Error();
                }
                return BarTooltipItem(
                  '$weekDay  ',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: (rod.toY - 1).toString(),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                );
              }),
          touchCallback: (FlTouchEvent event, barTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  barTouchResponse == null ||
                  barTouchResponse.spot == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            });
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: weekdayAbbreviation,
              reservedSize: 38,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: showData(),
        gridData: FlGridData(show: false));
  }

  Widget weekdayAbbreviation(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(
            '${DateTime.now().subtract(Duration(days: 6)).month}/${DateTime.now().subtract(Duration(days: 6)).day}\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 1:
        text = Text(
            '${DateTime.now().subtract(Duration(days: 5)).month}/${DateTime.now().subtract(Duration(days: 5)).day}\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 2:
        text = Text(
            '${DateTime.now().subtract(Duration(days: 4)).month}/${DateTime.now().subtract(Duration(days: 4)).day}\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 3:
        text = Text(
            '${DateTime.now().subtract(Duration(days: 3)).month}/${DateTime.now().subtract(Duration(days: 3)).day}\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 4:
        text = Text(
            '${DateTime.now().subtract(Duration(days: 2)).month}/${DateTime.now().subtract(Duration(days: 2)).day}\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 5:
        text = Text(
            '${DateTime.now().subtract(Duration(days: 1)).month}/${DateTime.now().subtract(Duration(days: 1)).day}\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 6:
        text = Text(
            '${DateTime.now().month}/${DateTime.now().day}\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
            decoration: BoxDecoration(
              color: Colors.orange[700],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                  padding: const EdgeInsets.all(15),
                  child: BarChart(taskCompletedData())),
            )));
  }
}
