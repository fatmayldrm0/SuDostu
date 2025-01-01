import 'package:flutter/material.dart';
import 'su_tuketimi_veri_tabani.dart';
import 'su_tuketimi_modeli.dart';

class SuTuketimiSayfasi extends StatelessWidget {
  final SuTuketimiVeriTabani veriTabani;

  // Constructor: Bu sınıftan bir nesne oluşturmak için gerekli olan parametre
  SuTuketimiSayfasi({required this.veriTabani});

  @override
  Widget build(BuildContext context) {
    final veriler = veriTabani.veriAl(); // Veritabanındaki verileri alır
    return Scaffold(
      appBar: AppBar(
        title: Text('Günlük Su Tüketimi'), // Uygulama başlığı
      ),
      body: Container(
        color: Colors.lightBlue[100], // Arka plan rengini açık mavi olarak ayarladık
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: veriler.isEmpty
                  ? Center(child: Text('Veri yok')) // Veri yoksa kullanıcıya mesaj göster
                  : ListView.builder(
                itemCount: veriler.length,
                itemBuilder: (context, index) {
                  final veri = veriler[index];
                  return ListTile(
                    title: Text(veri.tarih),
                    subtitle: Text('${veri.miktar} Litre'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
