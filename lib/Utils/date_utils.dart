/// Returns `yyyy-MM-dd` or null when [date] is null.
String? formatDateOnly(DateTime? date) {
  if (date == null) return null;
  return "${date.year.toString().padLeft(4, '0')}-"
      "${date.month.toString().padLeft(2, '0')}-"
      "${date.day.toString().padLeft(2, '0')}";
}

class DateUtils{

  //
  displayFormat(){


  }

  //
  String dateOnlyFormat(DateTime date){

    return "${date.month}-${date.day}-${date.year}";
  }

  //
  String parsableDate(DateTime date){

    return "${date.year}-${date.month<10?"0${date.month}":date.month}-${date.day<10?"0${date.day}":date.day}";
  }

  //
  String displayTime(String time){

      final parts = time.split(":");
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      String period = hour >= 12 ? "PM" : "AM";

      // Convert to 12-hour format
      hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

      return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";

  }

}