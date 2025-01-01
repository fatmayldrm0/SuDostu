import 'package:flutter/material.dart';
import 'susuz_bir_dunya.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'su_tuketimi_modeli.dart';
import 'su_tuketimi_veri_tabani.dart';
import 'su_tuketimi_sayfasi.dart';
import 'profil_sayfasi.dart';

void main() {
  runApp(sudostu());
}

// Ana uygulama widget'ı
class sudostu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SuDostu', // Uygulama başlığı
      theme: ThemeData(
        primarySwatch: Colors.blue, // Tema rengi
      ),
      home: KapakSayfasi(), // Kapak sayfası widget'ı
    );
  }
}

// Uygulama açıldığında gösterilen kapak sayfası
class KapakSayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AnaSayfa()),
        );
      },
  child: Scaffold(
        body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/su.jpg'), // Resim dosya yolu
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Text(
              'Su Dostu Uygulamasına Hoşgeldiniz', // Hoşgeldiniz mesajı
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                backgroundColor: Colors.black54, // Arkafon rengini ayarla
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        ),
       ),
      );
     }
    }

// Ana sayfa widget'ı
class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final SuTuketimiVeriTabani veriTabani = SuTuketimiVeriTabani();
  double gunlukSuTuketimi = 0; // Litre cinsinden tutulur
  final TextEditingController _controller = TextEditingController();


 @override
 void initState() {
   super.initState();
   _loadVeriler();
 }

  // Verileri yükleme fonksiyonu
  Future<void> _loadVeriler() async {
   await veriTabani.loadVeriler(); // Veri tabanından verileri yükle
   setState(() {
     gunlukSuTuketimi = veriTabani.veriAl().fold(0, (sum, item) => sum + item.miktar);
   });
 }

  // Su tüketim verilerini yükleme
  void _loadSuTuketimi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      gunlukSuTuketimi = (prefs.getDouble('gunlukSuTuketimi') ?? 0);
    });
  }


  // Su tüketim verilerini kaydetme
  void _saveSuTuketimi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('gunlukSuTuketimi', gunlukSuTuketimi);
  }

  // Günlük su tüketimini artıran fonksiyon
  void suEkle() {
   setState(() {
     double litre = double.tryParse(_controller.text) ?? 0;
     if (litre > 0) {
       gunlukSuTuketimi += litre;
       _controller.clear();  // Metin alanı temizlenir
       veriTabani.veriEkle(SuTuketimiModeli(
         tarih: DateTime.now().toString(),
         miktar: litre,
       ));
       _kontrolEtVeBildirimGonder();
       _saveSuTuketimi(); // Verileri kaydet
     } else {
       _showErrorDialog('Geçerli bir litre değeri giriniz.');
     }
   });
 }


 // Hata mesajı gösteren fonksiyon
void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Hata'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Tamam'),
            onPressed: () {
              Navigator.of(context).pop();
              },
          ),
        ],
      );
      },
  );
}

  // 5 dakika duş süresinde harcanan su miktarını ekleyen fonksiyon
  void dusSuresiEkle() {
    setState(() {
      gunlukSuTuketimi += 25; // 25 litre su eklenir
      veriTabani.veriEkle(SuTuketimiModeli(
        tarih: DateTime.now().toString(),
        miktar: 25,
      )); // Veriyi veri tabanına ekle
      _kontrolEtVeBildirimGonder();
      _saveSuTuketimi();
    });
  }



  // Bulaşık makinesinin bir kez çalışmada tükettiği su miktarını ekleyen fonksiyon
  void bulasikMakinasiEkle() {
    setState(() {
      gunlukSuTuketimi += 10; // 10 litre su eklenir
      veriTabani.veriEkle(SuTuketimiModeli(
        tarih: DateTime.now().toString(),
        miktar: 10,
      )); // Veriyi veri tabanına ekle
      _kontrolEtVeBildirimGonder();
      _saveSuTuketimi();
    });
  }

  // Çamaşır makinesinin bir kez çalışmada tükettiği su miktarını ekleyen fonksiyon
  void camasirMakinasiEkle() {
    setState(() {
      gunlukSuTuketimi += 30; // 30 litre su eklenir
      veriTabani.veriEkle(SuTuketimiModeli(
        tarih: DateTime.now().toString(),
        miktar: 30,
      ));
      _kontrolEtVeBildirimGonder(); // Su tüketimini kontrol et ve bildirim gönder
      _saveSuTuketimi(); // Verileri kaydet
  });
  }

  // Günlük su tüketimini sıfırlayan fonksiyon
  void gunlukTuketimSifirla() {
    setState(() {
      gunlukSuTuketimi = 0;
      _saveSuTuketimi(); // Verileri kaydet
    });
  }

  // Su tüketimi 100 litreyi geçerse bildirim gönderen fonksiyon
  void _kontrolEtVeBildirimGonder() {
    if (gunlukSuTuketimi > 100) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Uyarı'),
            content: Text('Günlük su tüketim miktarını aştınız. Tasarruf ipuçlarını takip etmeniz tavsiye edilir.'),
            actions: <Widget>[
              TextButton(
                child: Text('Tamam'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Rastgele su tasarrufu ipucu döndüren fonksiyon
  String suTasarrufuIpucu() {
    var ipuclar = [
      'Dişlerinizi fırçalarken musluğu kapatın.',
      'Çamaşır makinesini tam dolu çalıştırarak su ve enerji tasarrufu sağlayabilirsiniz.',
      'Araçlarınızı hortum yerine bir kova su ile yıkamak su tasarrufu sağlar.',
      'Bulaşıkları makinede yıkayın, elde yıkamaktan daha az su harcar.',
      'Kısa duş alın, daha az su tüketirsiniz.',
      'Günde 2 ila 3 litre arasında su tüketiniz.',
      'Eğer evinizde bozuk musluk varsa tamir edin, bu büyük oranda su tasarrufu yapılmasını sağlar.',
      'Bardaklarda kalan içilmemiş sularla çiçeklerinizi sulayabilirsiniz.',
      'Sebze ve meyveleri musluk açık olarak elde yıkamak yerine, suyu bir kaba doldurup orada yıkayın.',
      'Sıcak su borularını izole ederek suyun daha hızlı ısınmasını sağlayabilir ve böylece suyu boşa akıtmadan sıcak suya ulaşabilirsiniz.',
      'Yemek pişirme veya sebze yıkama sırasında kullanılan suyu dökmek yerine bitkilerinizi sulamak için kullanabilirsiniz.',
      'Fazla kalan buz küplerini bitkilerinize yerleştirerek suyun yavaş yavaş emilmesini sağlayabilirsiniz.',
      'Evinizdeki tüm muslukları, boruları ve bağlantıları düzenli olarak kontrol ederek su kaçaklarını önleyin.',
      'Bitkilerinizi doğrudan köklerine yakın sulamak, suyun daha verimli kullanılmasını sağlar.',
      'Bahçe sularken erken saatlerde veya geç saatlerde sulama yapın, buharlaşma ile su kaybını azaltırsınız.',
      'Bulaşıklarımızı elde yıkıyorsak akan musluğun altında değil temiz suyun içinde durulamak.',
      'Ellerimizi sabunlarken suyu kapatmak.',
      'Bulaşık makinesine koymadan durulamanız gereken bulaşıkları musluğu en az seviyede açarak durulamak ya da bir peçete yardımıyla kirleri sıyırmak.',
      'Mutfakta, banyoda, lavabolarda, su basıncını arttıran ama su akışını azaltan sistemler kullanmalıyız.',
      'Duş sürenizi kısa tutun ve saçınızı şampuanlarken suyu kapatın.',
      'Tuvaletinizde tasarruflu sifon ve/veya çift kademeli sifon sistemi kullanın.',
      'Meyve ve sebzeleri musluk altında değil, su dolu bir kabın içinde yıkayın.',
      'Bahçenizi sularken ucunda tetikli püskürtücü olan hortumları tercih edin.',
    ];
    var randomIndex = (ipuclar..shuffle()).first; // Rastgele bir ipucu seçilir
    return randomIndex;
  }

  // Günlük su tüketimi gösteren metin
  Text gunlukSuTuketimiMetni() {
    return Text(
      'Günlük Su Tüketimi: $gunlukSuTuketimi L',
      style: TextStyle(fontSize: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
        title: Text('SuDostu'), // Uygulama başlığımTRER
        ),
      drawer: Drawer(
      child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'Menü',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profil'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilSayfasi(),
              ),
            );
            },
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('Günlük Su Tüketimi'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SuTuketimiSayfasi(veriTabani: veriTabani),
              ),
            );
            },
        ),
      ],
      ),
      ),
    body: SingleChildScrollView( // Kaydırılabilir alan
    child: Container(
    color: Colors.lightBlue[100], // Arkaplan rengi açık mavi
    padding: const EdgeInsets.all(16.0), // İçerik kenar boşluğu
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gunlukSuTuketimiMetni(),
        SizedBox(height: 16), // Boşluk
        // Manuel su tüketimi girişi için metin alanı
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Manuel Su Tüketimi (L)',
          ),
        ),
        SizedBox(height: 16), // Boşluk
        // Su tüketimini ekleme butonu
        ElevatedButton(
          onPressed: suEkle,
          child: Text('Su Tüketimini Ekle'),
        ),
        SizedBox(height: 16), // Butonlar arasında boşluk
        // 5 dakika duş süresinde harcanan su miktarını ekleme butonu
        ElevatedButton(
          onPressed: dusSuresiEkle,
          child: Text('5 Dakika Duş Süresinde Harcanan Su (25 L)'), // Güncellenmiş miktar
        ),
        SizedBox(height: 16), // Butonlar arasında boşluk
        // Bulaşık makinesinin bir kez çalışmada tükettiği su miktarını ekleme butonu
        ElevatedButton(
          onPressed: bulasikMakinasiEkle,
          child: Text('Bir Bulaşık Makinesinin Bir Kez Çalışmada Tükettiği Su (10 L)'),
        ),
        SizedBox(height: 16), // Butonlar arasında boşluk
        // Çamaşır makinesinin bir kez çalışmada tükettiği su miktarını ekleme butonu
        ElevatedButton(
          onPressed: camasirMakinasiEkle,
          child: Text('Bir Çamaşır Makinesinin Bir Kez Çalışmada Tükettiği Su (30 L)'),
        ),
        SizedBox(height: 16), // Butonlar arasında boşluk
        // Günlük tüketimi sıfırlama butonu
        ElevatedButton(
          onPressed: gunlukTuketimSifirla,
          child: Text('Günlük Tüketimi Sıfırla'),
        ),
        SizedBox(height: 16), // Boşluk
        // Su tasarruf ipucu başlığı
        Text(
          'Su Tasarruf İpucu:',
          style: TextStyle(fontSize: 20),
        ),
        // Rastgele su tasarrufu ipucu gösteren metin
        Text(
          suTasarrufuIpucu(),
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16), // Boşluk
        // Su tasarrufu ipuçları sayfasına yönlendiren buton
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SuTasarrufuOnlemler()),
            );
          },
          child: Text('Su Tasarrufu İçin Alınması Gereken Önlemler'),
        ),
        SizedBox(height: 16), // Boşluk
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SusuzBirDunya()),
            );
          },
          child: Text('Susuz Bir Dünya'),
        ),
        SizedBox(height: 20),
        Image.asset(
          'assets/images/su_tasarruf.jpg', // Resim dosyasının yolu
          fit: BoxFit.fill, // Resmi alanı tamamen kaplayacak şekilde sığdırma
        ),
      ],
    ),
    ),
    ),
    );
  }
}

class SuTasarrufuOnlemler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Su Tasarrufu İçin Alınması Gereken Önlemler'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.lightBlue[100], // Arkaplan rengi açık mavi
          padding: const EdgeInsets.all(16.0), // İçerik kenar boşluğu
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Su Tasarrufu İçin Alınması Gereken Önlemler:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '- Dişlerinizi fırçalarken musluğu kapatın.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Çamaşır makinesini tam dolu çalıştırarak su ve enerji tasarrufu sağlayabilirsiniz.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Araçlarınızı hortum yerine bir kova su ile yıkamak su tasarrufu sağlar.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Bulaşıkları makinede yıkayın, elde yıkamaktan daha az su harcar.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Kısa duş alın, daha az su tüketirsiniz.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Günde 2 ila 3 litre arasında su tüketiniz.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Eğer evinizde bozuk musluk varsa tamir edin, bu büyük oranda su tasarrufu yapılmasını sağlar.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Bardaklarda kalan içilmemiş sularla çiçeklerinizi sulayabilirsiniz.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Sebze ve meyveleri musluk açık olarak elde yıkamak yerine, suyu bir kaba doldurup orada yıkayın.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Sıcak su borularını izole ederek suyun daha hızlı ısınmasını sağlayabilir ve böylece suyu boşa akıtmadan sıcak suya ulaşabilirsiniz.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Yemek pişirme veya sebze yıkama sırasında kullanılan suyu dökmek yerine bitkilerinizi sulamak için kullanabilirsiniz.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Fazla kalan buz küplerini bitkilerinize yerleştirerek suyun yavaş yavaş emilmesini sağlayabilirsiniz.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Evinizdeki tüm muslukları, boruları ve bağlantıları düzenli olarak kontrol ederek su kaçaklarını önleyin.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Bitkilerinizi doğrudan köklerine yakın sulamak, suyun daha verimli kullanılmasını sağlar.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Bahçe sularken erken saatlerde veya geç saatlerde sulama yapın, buharlaşma ile su kaybını azaltırsınız.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Bulaşıklarımızı elde yıkıyorsak akan musluğun altında değil temiz suyun içinde durulamak.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Ellerinizi sabunlarken suyu kapatmak.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Bulaşık makinesine koymadan durulamanız gereken bulaşıkları musluğu en az seviyede açarak durulamak ya da bir peçete yardımıyla kirleri sıyırmak.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Mutfakta, banyoda, lavabolarda, su basıncını arttıran ama su akışını azaltan sistemler kullanmalıyız.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Duş sürenizi kısa tutun ve saçınızı şampuanlarken suyu kapatın.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Tuvaletinizde tasarruflu sifon ve/veya çift kademeli sifon sistemi kullanın.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Meyve ve sebzeleri musluk altında değil, su dolu bir kabın içinde yıkayın.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '- Bahçenizi sularken ucunda tetikli püskürtücü olan hortumları tercih edin.',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
