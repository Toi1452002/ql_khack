import 'package:intl/intl.dart';

class Helper{
  static String get nowYmdT => DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  static String get nowYmd => DateFormat('yyyy-MM-dd').format(DateTime.now());

  static String dMy(String? date, {bool hour = false}){
   if(date==null || date =='' || date == 'null') {
     return '';
   } else {
     return  DateFormat('dd/MM/yyyy ${hour ? 'HH:mm' : ''}').format(DateTime.parse(date.trim())).trim();
   }
  }
  static String My(String? date){
    if(date==null) {
      return '';
    } else {
      List<String> lstDate = date.split('-');
      return "${lstDate.last}/${lstDate.first}";
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