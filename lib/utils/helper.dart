import 'package:intl/intl.dart';
import 'package:string_validator/string_validator.dart';

class Helper{
  static String get nowYmdT => DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  static String get nowYmd => DateFormat('yyyy-MM-dd').format(DateTime.now());

  static String dMy(dynamic date) {
    if (date == null) return '';
    if (date.runtimeType == DateTime) {
      return DateFormat('dd/MM/yyyy').format(date);
    } else if (date.runtimeType == String && date.toString().isNotEmpty) {
      return DateFormat('dd/MM/yyyy').format(toDate(date)!);
    }

    return date.toString();
  }
  static String? numFormat(dynamic number) {
    if (number == null) {
      return null;
    } else {
      try {
        String strNum = number.toString();
        if (strNum.contains(',')) strNum = strNum.replaceAll(',', '');
        final num = double.parse(strNum);
        return NumberFormat('#,###.##', "en_US").format(num);
      } catch (e) {
        return number;
      }
    }
  }
  static DateTime? strToDate(String date) {
    if (date.contains('/')) {
      final str = date.split('/');
      final x = "${str.last}-${str[1]}-${str.first}";
      return toDate(x);
    } else {
      return null;
    }
  }
  static String My(String? date){
    if(date==null) {
      return '';
    } else {
      if(date.contains('-')){
        List<String> lstDate = date.split('-');
        if(lstDate.length==2){
          return "${lstDate.last}/${lstDate.first}";
        }else {
          return "${lstDate[1]}/${lstDate.first}";
        }
      }return date;
    }
  }

  static String yM(String? date){
    if(date==null) {
      return '';
    } else {
      List<String> lstDate = date.split('/');
      return "${lstDate.last}-${lstDate.first}".trim();
    }
  }
  static String yMd(DateTime? date,{bool hour = false}){

    ///[hour]
    if(date==null) {
      return '';
    } else {
      return  DateFormat('yyyy-MM-dd ${hour ? 'HH:mm:ss' : ''}').format(date).trim();
    }
  }

  static DateTime dMytoDate(String val){
    List lst = val.split('/');
    String yMd = '${lst.last.toString().trim()}-${lst[1].toString().trim()}-${lst.first.toString().trim()}';
    return DateTime.parse(yMd);
  }

  static String dMYtoYMD(String val){
    List lst = val.split('/');
    String yMd = '${lst.last.toString().trim()}-${lst[1].toString().trim()}-${lst.first.toString().trim()}';
    return yMd.trim();
  }

  static String formatNum(double num){
    return NumberFormat('#,###').format(num);
  }
}