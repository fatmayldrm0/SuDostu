class SuTuketimiModeli {
  final String tarih; // Su tüketiminin kaydedildiği tarih
  final double miktar; // Su tüketim miktarı (litre cinsinden)

  // Constructor: Bu sınıftan bir nesne oluşturmak için gerekli olan parametreler
  SuTuketimiModeli({required this.tarih, required this.miktar});

  // Verileri bir harita (map) yapısına dönüştüren fonksiyon
  Map<String, dynamic> toMap() {
    return {
      'tarih': tarih, // Tarih bilgisi haritaya eklenir
      'miktar': miktar, // Miktar bilgisi haritaya eklenir
    };
  }

  @override
  String toString() {
    return 'SuTuketimiModeli{tarih: $tarih, miktar: $miktar}';
  }
}
