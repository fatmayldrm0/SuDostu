import 'package:flutter/material.dart';

class ProfilSayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Container(
        color: Colors.lightBlue[100], // Arka plan rengini açık mavi olarak ayarladık
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/images.jpg'), // Profil fotoğrafı dosya yolu
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Ad: Fatma Yıldırım', // Kullanıcı adı
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'Email: fatmayldrm0@outlook.com', // Kullanıcı email
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Telefon: +90 123 456 7890', // Kullanıcı telefon numarası
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
