import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'su_tuketimi_modeli.dart';

class SuTuketimiVeriTabani {
  List<SuTuketimiModeli> _veriler = []; // Su tüketimi verilerini saklamak için bir liste

  // Yeni veri ekleme metodu
  Future<void> veriEkle(SuTuketimiModeli veri) async {
    _veriler.add(veri); // Listeye yeni veri eklenir
    await _saveVeriler(); // Veriler kaydedilir
  }

  // Verileri alma metodu
  List<SuTuketimiModeli> veriAl() {
    return _veriler; // Mevcut veriler döndürülür
  }

  // Verileri kaydetme metodu (private)
  Future<void> _saveVeriler() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // SharedPreferences örneği alınır
    List<String> veriListesi = _veriler.map((veri) => jsonEncode(veri.toMap())).toList(); // Veriler JSON formatına dönüştürülür
    await prefs.setStringList('suTuketimiVeriler', veriListesi); // Veriler SharedPreferences'a kaydedilir
  }

  // Verileri yükleme metodu
  Future<void> loadVeriler() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // SharedPreferences örneği alınır
    List<String> veriListesi = prefs.getStringList('suTuketimiVeriler') ?? []; // Veriler SharedPreferences'tan alınır
    _veriler = veriListesi.map((veriString) {
      Map<String, dynamic> veriMap = jsonDecode(veriString); // JSON string haritaya (map) dönüştürülür
      return SuTuketimiModeli(
        tarih: veriMap['tarih'],
        miktar: veriMap['miktar'],
      ); // Harita kullanılarak SuTuketimiModeli nesnesi oluşturulur
    }).toList(); // Liste oluşturulur
  }
}
