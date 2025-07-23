import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/utils/extension.dart';

Map<String, dynamic> numThoiHan = {
    '0': 0,
    '1': 30,
    '2': 90,
    '3': 365,
    '4': 3,
  };


Map<int, dynamic> strThoiHan = {
  0: 'Không thời hạn',
  1: 'Tháng',
  2: 'Quý',
  3: 'Năm',
  4: 'Thử (3N)',
};


int maAscii(int kq){
  if(kq>=225)kq = kq~/3;
  if(kq>= 113 && kq<225) kq = kq~/2;
  if((kq>57 && kq<65) || (kq>90 && kq<97)) kq = kq+8;
  return kq;
}

String createBanQuyen(String seri){
  String sKQ = "";int kq;
  String loaiPM = 'S09';
  try{
    String chuoiTao = "$loaiPM$seri".substring(0,16);
    for(int i = 0;i<chuoiTao.length;i++){
      kq = 40  + (i+1) * (chuoiTao[i].toInt +9);
      kq = maAscii(kq);
      sKQ += String.fromCharCode(kq).toUpperCase();
    }
    return sKQ;
  }catch(e){
    print(e);
    return '';
  }


}
