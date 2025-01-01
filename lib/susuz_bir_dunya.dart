import 'package:flutter/material.dart';

class SusuzBirDunya extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Susuz Bir Dünya'),
      ),
      body: Container(
        color: Colors.lightBlue[100], // Arka plan rengini açık mavi
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Image.asset(
          'assets/images/dunyasugunu.jpg', // Resim dosya yolu
          fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
            SizedBox(height: 16),
            Text(
              'Su Olmayan Bir Dünyada Karşılaşılacak Durumlar:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '- Tarım ve gıda üretimi duracak.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- Temizlik ve hijyen büyük sorun haline gelecek.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- Sağlık sorunları artacak, salgın hastalıklar yayılacak.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- Doğal ekosistemler zarar görecek ve birçok canlı türü yok olacak.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- Ekonomik krizler ve toplumsal huzursuzluklar artacak.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- İklim değişiklikleri hızlanacak.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- Dünya çorak ve ıssız bir çöl olurdu.',
              style: TextStyle(fontSize: 16),
            ),
             Text(
            '- Su buharı, Dünyanın ısısını düzenleyen önemli bir sera gazıdır. Su olmadan, Dünya çok soğuk ve yaşanamaz hale gelirdi.',
        style: TextStyle(fontSize: 16),
      ),
            Text(
              '- Su, yangınları söndürmek, sellerden korunmak ve fırtınalardan korunmak için olmazsa olmazdır. Su olmadan, doğal afetler çok daha yıkıcı olurdu.',
              style: TextStyle(fontSize: 16),
            ),
      ],
        ),
      ),
    );
  }
}
