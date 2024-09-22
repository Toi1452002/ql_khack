class PathServer{
  const PathServer._();

  static String get  _path => "http://192.168.1.5:8000/api_qlkhach/api";
  // static String get  _path => "http://rgb.com.vn/admin/server/api";
  // static String get home => "$_path/home";
  static String get khach => "$_path/khach.php";
  static String get hopdong => "$_path/hopdong.php";
  static String get user => "$_path/user.php";
  static String get product => "$_path/product.php";
  static String get phieuThu => "$_path/phieuthu.php";
  static String get hoaHong => "$_path/hoahong.php";
  static String get config => "$_path/config.php";


  static push({required String type, Map<String, dynamic>? data}){
    return {
      'type': type,
      'data': data ??{}
    };
  }
}