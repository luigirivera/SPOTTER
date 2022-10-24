import 'package:objectbox/objectbox.dart';

@Entity()
class StudyTheme {
  @Id()
  int id = 0; //don't delete this. it's for objectbox
  int index;
  String folder;
  String name;

  StudyTheme({required this.index, required this.folder, required this.name});
}

@Entity()
class StudyCount {
  @Id()
  int id = 0; //don't delete this. it's for objectbox
  int count;
  SessionDate date;

  StudyCount({required this.count, required this.date});
}

@Entity()
class SessionDate {
  @Id()
  int id = 0;

  int year;
  int month;
  int day;
  int weekday;

  SessionDate(
      {required this.year,
      required this.month,
      required this.day,
      required this.weekday});

  ///If the dates are the same then return true
  bool compareTo(SessionDate date) {
    return year == date.year &&
        month == date.month &&
        day == date.day &&
        weekday == date.weekday;
  }
}
