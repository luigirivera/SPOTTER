import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
        decoration: BoxDecoration(color: Colors.brown[300]),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: const [
            SizedBox(
                height: 30,
                child: Text('Task Completed Per Week',
                    style: TextStyle(fontSize: 20))),
            TaskCompletionGraph(),
            SizedBox(height: 20),
            SizedBox(
                height: 30,
                child: Text('Study Sessions Time Per Week',
                    style: TextStyle(fontSize: 20))),
            StudySessionTimeGraph(),
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
  List<double> sampleTaskCompletionData = [7, 3, 6, 9, 5, 2, 1];
  int touchedIndex = -1;

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
                    weekDay = 'Monday';
                    break;
                  case 1:
                    weekDay = 'Tuesday';
                    break;
                  case 2:
                    weekDay = 'Wednesday';
                    break;
                  case 3:
                    weekDay = 'Thursday';
                    break;
                  case 4:
                    weekDay = 'Friday';
                    break;
                  case 5:
                    weekDay = 'Saturday';
                    break;
                  case 6:
                    weekDay = 'Sunday';
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
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(
            'Mon\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 1:
        text = Text(
            'Tue\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 2:
        text = Text(
            'Wed\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 3:
        text = Text(
            'Thu\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 4:
        text = Text(
            'Fri\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 5:
        text = Text(
            'Sat\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 6:
        text = Text(
            'Sun\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
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
    return Container(
      height: MediaQuery.of(context).size.height / 2 - 130,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.green[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
          padding: const EdgeInsets.all(15),
          child: BarChart(taskCompletedData())),
    );
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
          color: isTouched ? Colors.blue[500] : Colors.blue[100],
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
                    weekDay = 'Monday';
                    break;
                  case 1:
                    weekDay = 'Tuesday';
                    break;
                  case 2:
                    weekDay = 'Wednesday';
                    break;
                  case 3:
                    weekDay = 'Thursday';
                    break;
                  case 4:
                    weekDay = 'Friday';
                    break;
                  case 5:
                    weekDay = 'Saturday';
                    break;
                  case 6:
                    weekDay = 'Sunday';
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
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(
            'Mon\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 1:
        text = Text(
            'Tue\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 2:
        text = Text(
            'Wed\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 3:
        text = Text(
            'Thu\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 4:
        text = Text(
            'Fri\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 5:
        text = Text(
            'Sat\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
            style: style);
        break;
      case 6:
        text = Text(
            'Sun\n ${sampleTaskCompletionData[value.toInt()].toStringAsPrecision(1)}',
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
    return Container(
      height: MediaQuery.of(context).size.height / 2 - 130,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.orange[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
          padding: const EdgeInsets.all(15),
          child: BarChart(taskCompletedData())),
    );
  }
}
