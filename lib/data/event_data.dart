import '../models/event_model.dart';

List<Event> getInitialEvents() {
  return [
    Event(
      id: '1',
      title: 'ESTÜ İHA & Havacılık Zirvesi 2026',
      category: 'Technology',
      dateTime: DateTime(2026, 11, 4, 10, 0),
      venue: 'İki Eylül Kampüsü - Havacılık Hangarı',
      description:
          'Eskişehir Teknik Üniversitesi Havacılık ve Uzay Bilimleri Fakültesi bünyesinde gerçekleşecek zirvede; otonom İHA yarışları, roket sistemleri atölyesi ve ESTÜ mezunu havacılık mühendisleriyle networking oturumları yer alacaktır.',
      imagePath: 'assets/images/aviation.png',
      totalCapacity: 150,
      availablePlaces: 35,
    ),
    Event(
      id: '2',
      title: 'ESTÜ Yapay Zeka ve Robotik Günleri',
      category: 'Technology',
      dateTime: DateTime(2026, 11, 8, 13, 30),
      venue: 'Mühendislik Fakültesi Seminer Salonu',
      description:
          'Bilgisayar ve Elektrik-Elektronik Mühendisliği bölümleri ortaklığıyla düzenlenen etkinlikte endüstriyel robot kollar, derin öğrenme projeleri ve kuantum hesaplama sunumları yapılacaktır.',
      imagePath: 'assets/images/technology.png',
      totalCapacity: 120,
      availablePlaces: 48,
    ),
    Event(
      id: '3',
      title: 'ESTÜ Rektörlük Kupası Futbol Turnuvası',
      category: 'Sports',
      dateTime: DateTime(2026, 11, 12, 16, 0),
      venue: 'İki Eylül Kampüsü Stadyumu',
      description:
          'Fakülteler arası geleneksel futbol turnuvası açılış maçı. Tribünlerde meşaleler eşliğinde kıyasıya rekabet ve ESTÜ bandosu gösterisi sizleri bekliyor.',
      imagePath: 'assets/images/sports.png',
      totalCapacity: 250,
      availablePlaces: 0, // BAŞLANGIÇTA TAMAMEN DOLU (FULL)
    ),
    Event(
      id: '4',
      title: 'ESTÜ Akustik Günbatımı Konseri',
      category: 'Music',
      dateTime: DateTime(2026, 11, 16, 18, 30),
      venue: 'Yabancı Diller Yüksekokulu Çim Amfisi',
      description:
          'Günün yorgunluğunu çimlerde sıcak içecekler, peri ışıkları ve ESTÜ Müzik Kulübü öğrencilerinin canlı akustik gitar ve keman dinletisiyle atıyoruz.',
      imagePath: 'assets/images/music.png',
      totalCapacity: 90,
      availablePlaces: 1, // TAM 1 KİŞİLİK YER KALDI
    ),
    Event(
      id: '5',
      title: 'ESTÜ Mimarlık ve Tasarım Sergisi',
      category: 'Arts',
      dateTime: DateTime(2026, 11, 20, 11, 0),
      venue: 'Mimarlık Fakültesi Fuaye Alanı',
      description:
          'ESTÜ Mimarlık ve Tasarım Fakültesi öğrencilerinin dönem boyunca hazırladığı çağdaş heykeller, maketler, seramik çalışmaları ve dijital illüstrasyonlar sergilenmektedir.',
      imagePath: 'assets/images/arts.png',
      totalCapacity: 80,
      availablePlaces: 28,
    ),
    Event(
      id: '6',
      title: 'ESTÜ IEEE 24 Saatlik Hackathon',
      category: 'Technology',
      dateTime: DateTime(2026, 11, 28, 09, 0),
      venue: 'Merkezi Bilgisayar Laboratuvarı',
      description:
          'ESTÜ IEEE Öğrenci Kolu organizasyonuyla 24 saat boyunca akıllı kampüs çözümleri geliştirilecek, dereceye giren takımlara staj ve ödüller verilecektir.',
      imagePath: 'assets/images/technology.png',
      totalCapacity: 60,
      availablePlaces: 12,
    ),
    Event(
      id: '7',
      title: 'ESTÜ Tiyatro Kulübü: Bir Delinin Hatıra Defteri',
      category: 'Arts',
      dateTime: DateTime(2026, 12, 3, 19, 0),
      venue: 'Kongre ve Kültür Merkezi - Kırmızı Salon',
      description:
          'Gogol\'ün ölümsüz eseri ESTÜ Tiyatro Topluluğu tarafından sahneye taşınıyor. İki perdelik sürükleyici bir tiyatro ziyafeti.',
      imagePath: 'assets/images/arts.png',
      totalCapacity: 180,
      availablePlaces: 40,
    ),
    Event(
      id: '8',
      title: 'ESTÜ Fakülteler Arası Basketbol Ligi',
      category: 'Sports',
      dateTime: DateTime(2026, 12, 10, 17, 30),
      venue: 'Merkez Kapalı Spor Salonu',
      description:
          'Mühendislik Fakültesi ile Fen Fakültesi basketbol takımlarının heyecan dolu şampiyonluk mücadelesi.',
      imagePath: 'assets/images/sports.png',
      totalCapacity: 300,
      availablePlaces: 95,
    ),
    Event(
      id: '9',
      title: 'ESTÜ Caz & Rock Festivali',
      category: 'Music',
      dateTime: DateTime(2026, 12, 18, 20, 0),
      venue: 'Açık Hava Gösteri Merkezi',
      description:
          'Eskişehir\'in enerjisini kampüse taşıyan, farklı üniversitelerden konuk grupların ve ESTÜ müzisyenlerinin sahne alacağı unutulmaz bir müzik gecesi.',
      imagePath: 'assets/images/music.png',
      totalCapacity: 220,
      availablePlaces: 110,
    ),
  ];
}
