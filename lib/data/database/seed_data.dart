import 'package:drift/drift.dart';
import 'app_database.dart';

class RecipeSeed {
  final RecipesCompanion companion;
  final List<IngredientsCompanion> ingredients;
  final List<StepsCompanion> steps;

  RecipeSeed(this.companion, this.ingredients, this.steps);
}

class SeedData {
  List<RecipeSeed> get recipes => [
    // 1. Nasi Goreng Spesial
    RecipeSeed(
      const RecipesCompanion(
        title: Value('Nasi Goreng Spesial'),
        description: Value('Nasi goreng lezat dengan bumbu rahasia keluarga, disajikan dengan telur mata sapi dan kerupuk.'),
        imageAsset: Value('assets/images/nasi_goreng.jpg'),
        cookTime: Value(15),
        difficulty: Value('Mudah'),
        servings: Value(2),
      ),
      [
        const IngredientsCompanion(name: Value('Nasi Putih (dingin)'), amount: Value(400), unit: Value('gram')),
        const IngredientsCompanion(name: Value('Bawang Merah'), amount: Value(5), unit: Value('siung')),
        const IngredientsCompanion(name: Value('Bawang Putih'), amount: Value(3), unit: Value('siung')),
        const IngredientsCompanion(name: Value('Cabai Merah'), amount: Value(2), unit: Value('buah')),
        const IngredientsCompanion(name: Value('Kecap Manis'), amount: Value(3), unit: Value('sdm')),
        const IngredientsCompanion(name: Value('Garam'), amount: Value(1), unit: Value('sdt')),
        const IngredientsCompanion(name: Value('Telur Ayam'), amount: Value(2), unit: Value('butir')),
        const IngredientsCompanion(name: Value('Minyak Goreng'), amount: Value(3), unit: Value('sdm')),
      ],
      [
        const StepsCompanion(stepNumber: Value(1), instruction: Value('Haluskan bawang merah, bawang putih, dan cabai merah.'), tip: Value('Gunakan blender atau ulekan untuk hasil terbaik.')),
        const StepsCompanion(stepNumber: Value(2), instruction: Value('Panaskan minyak, tumis bumbu halus hingga harum dan matang.')),
        const StepsCompanion(stepNumber: Value(3), instruction: Value('Sisihkan bumbu di tepi wajan, masukkan telur dan orak-arik hingga matang.')),
        const StepsCompanion(stepNumber: Value(4), instruction: Value('Masukkan nasi putih, aduk rata dengan bumbu dan telur.')),
        const StepsCompanion(stepNumber: Value(5), instruction: Value('Tambahkan kecap manis dan garam. Aduk terus hingga bumbu meresap sempurna. Sajikan hangat.'), tip: Value('Gunakan api besar saat mengaduk agar aroma "wok hei" keluar.')),
      ],
    ),
    // 2. Ayam Bakar Madu
    RecipeSeed(
      const RecipesCompanion(
        title: Value('Ayam Bakar Madu'),
        description: Value('Ayam bakar manis gurih dengan lapisan madu karamelisasi yang menggugah selera.'),
        imageAsset: Value('assets/images/ayam_bakar.jpg'),
        cookTime: Value(45),
        difficulty: Value('Sedang'),
        servings: Value(4),
      ),
      [
        const IngredientsCompanion(name: Value('Ayam (potong 4)'), amount: Value(1), unit: Value('ekor')),
        const IngredientsCompanion(name: Value('Jeruk Nipis'), amount: Value(1), unit: Value('buah')),
        const IngredientsCompanion(name: Value('Bawang Putih'), amount: Value(6), unit: Value('siung')),
        const IngredientsCompanion(name: Value('Bawang Merah'), amount: Value(8), unit: Value('siung')),
        const IngredientsCompanion(name: Value('Ketumbar Bubuk'), amount: Value(1), unit: Value('sdm')),
        const IngredientsCompanion(name: Value('Kunyit (bakar)'), amount: Value(2), unit: Value('cm')),
        const IngredientsCompanion(name: Value('Jahe'), amount: Value(2), unit: Value('cm')),
        const IngredientsCompanion(name: Value('Kecap Manis'), amount: Value(4), unit: Value('sdm')),
        const IngredientsCompanion(name: Value('Madu'), amount: Value(3), unit: Value('sdm')),
        const IngredientsCompanion(name: Value('Air Kelapa'), amount: Value(400), unit: Value('ml')),
      ],
      [
        const StepsCompanion(stepNumber: Value(1), instruction: Value('Lumuri ayam dengan perasan jeruk nipis dan garam. Diamkan 15 menit, lalu bilas bersih.')),
        const StepsCompanion(stepNumber: Value(2), instruction: Value('Haluskan bawang putih, bawang merah, ketumbar, kunyit, dan jahe.')),
        const StepsCompanion(stepNumber: Value(3), instruction: Value('Tumis bumbu halus hingga harum dan matang. Masukkan ayam, aduk hingga berubah warna.')),
        const StepsCompanion(stepNumber: Value(4), instruction: Value('Tuangkan air kelapa, kecap manis, dan garam. Ungkep ayam hingga empuk dan air menyusut.'), tip: Value('Gunakan api kecil agar bumbu meresap hingga ke tulang.')),
        const StepsCompanion(stepNumber: Value(5), instruction: Value('Campurkan madu dengan sisa bumbu ungkep untuk bahan olesan.')),
        const StepsCompanion(stepNumber: Value(6), instruction: Value('Bakar ayam di atas bara api atau panggangan, olesi dengan bumbu madu berulang kali hingga terkaramelisasi.')),
      ],
    ),
    // 3. Gado-Gado Jakarta
    RecipeSeed(
      const RecipesCompanion(
        title: Value('Gado-Gado Jakarta'),
        description: Value('Salad sayur khas Indonesia dengan siraman saus kacang legit dan taburan kerupuk.'),
        imageAsset: Value('assets/images/gado_gado.jpg'),
        cookTime: Value(30),
        difficulty: Value('Sedang'),
        servings: Value(3),
      ),
      [
        const IngredientsCompanion(name: Value('Kangkung (rebus)'), amount: Value(100), unit: Value('gram')),
        const IngredientsCompanion(name: Value('Tauge (seduh air panas)'), amount: Value(100), unit: Value('gram')),
        const IngredientsCompanion(name: Value('Kacang Panjang (rebus)'), amount: Value(100), unit: Value('gram')),
        const IngredientsCompanion(name: Value('Labu Siam (rebus)'), amount: Value(100), unit: Value('gram')),
        const IngredientsCompanion(name: Value('Tahu (goreng)'), amount: Value(2), unit: Value('buah')),
        const IngredientsCompanion(name: Value('Tempe (goreng)'), amount: Value(2), unit: Value('buah')),
        const IngredientsCompanion(name: Value('Telur Rebus'), amount: Value(3), unit: Value('butir')),
        const IngredientsCompanion(name: Value('Kacang Tanah Goreng'), amount: Value(200), unit: Value('gram')),
        const IngredientsCompanion(name: Value('Gula Merah'), amount: Value(50), unit: Value('gram')),
        const IngredientsCompanion(name: Value('Cabai Rawit'), amount: Value(3), unit: Value('buah')),
        const IngredientsCompanion(name: Value('Terasi Bakar'), amount: Value(1), unit: Value('sdt')),
        const IngredientsCompanion(name: Value('Air Asam Jawa'), amount: Value(2), unit: Value('sdm')),
      ],
      [
        const StepsCompanion(stepNumber: Value(1), instruction: Value('Siapkan semua sayuran matang, tahu, tempe, dan telur rebus. Potong-potong sesuai selera.')),
        const StepsCompanion(stepNumber: Value(2), instruction: Value('Untuk saus: Haluskan kacang tanah goreng bersama cabai rawit dan terasi.')),
        const StepsCompanion(stepNumber: Value(3), instruction: Value('Tambahkan gula merah dan garam, ulek kembali hingga rata.')),
        const StepsCompanion(stepNumber: Value(4), instruction: Value('Tuangkan air asam jawa dan sedikit air matang. Aduk hingga mencapai kekentalan yang pas.'), tip: Value('Jangan buat saus terlalu cair agar menempel sempurna di sayuran.')),
        const StepsCompanion(stepNumber: Value(5), instruction: Value('Tata sayuran, tahu, tempe, dan telur di atas piring.')),
        const StepsCompanion(stepNumber: Value(6), instruction: Value('Siram dengan bumbu kacang secara merata.')),
        const StepsCompanion(stepNumber: Value(7), instruction: Value('Taburi bawang goreng dan sajikan bersama kerupuk.'), tip: Value('Kerupuk udang atau emping sangat direkomendasikan!')),
      ]
    ),
    // 4. Soto Ayam Lamongan
    RecipeSeed(
      const RecipesCompanion(
        title: Value('Soto Ayam Lamongan'),
        description: Value('Kuah soto kuning segar dengan taburan koya gurih yang khas.'),
        imageAsset: Value('assets/images/soto_ayam.jpg'),
        cookTime: Value(60),
        difficulty: Value('Sulit'),
        servings: Value(5),
      ),
      [
        const IngredientsCompanion(name: Value('Ayam Kampung'), amount: Value(1), unit: Value('ekor')),
        const IngredientsCompanion(name: Value('Sereh (memarkan)'), amount: Value(2), unit: Value('batang')),
        const IngredientsCompanion(name: Value('Daun Jeruk'), amount: Value(5), unit: Value('lembar')),
        const IngredientsCompanion(name: Value('Bawang Putih'), amount: Value(8), unit: Value('siung')),
        const IngredientsCompanion(name: Value('Bawang Merah'), amount: Value(10), unit: Value('siung')),
        const IngredientsCompanion(name: Value('Kunyit (bakar)'), amount: Value(3), unit: Value('cm')),
        const IngredientsCompanion(name: Value('Jahe'), amount: Value(2), unit: Value('cm')),
        const IngredientsCompanion(name: Value('Kemiri (sangrai)'), amount: Value(4), unit: Value('butir')),
        const IngredientsCompanion(name: Value('Kol (iris tipis)'), amount: Value(100), unit: Value('gram')),
        const IngredientsCompanion(name: Value('Soun (seduh)'), amount: Value(100), unit: Value('gram')),
        const IngredientsCompanion(name: Value('Kerupuk Udang (untuk koya)'), amount: Value(50), unit: Value('gram')),
        const IngredientsCompanion(name: Value('Bawang Putih Goreng (koya)'), amount: Value(2), unit: Value('sdm')),
        const IngredientsCompanion(name: Value('Telur Rebus'), amount: Value(3), unit: Value('butir')),
        const IngredientsCompanion(name: Value('Seledri (iris tipis)'), amount: Value(2), unit: Value('batang')),
      ],
      [
        const StepsCompanion(stepNumber: Value(1), instruction: Value('Rebus ayam kampung bersama daun jeruk dan sereh hingga kaldu keluar dan ayam empuk.')),
        const StepsCompanion(stepNumber: Value(2), instruction: Value('Haluskan bawang putih, bawang merah, kunyit, jahe, dan kemiri.')),
        const StepsCompanion(stepNumber: Value(3), instruction: Value('Tumis bumbu halus hingga harum dan matang. Masukkan ke dalam rebusan ayam.')),
        const StepsCompanion(stepNumber: Value(4), instruction: Value('Tambahkan garam dan lada, masak dengan api kecil selama 15 menit agar bumbu meresap ke kaldu.')),
        const StepsCompanion(stepNumber: Value(5), instruction: Value('Angkat ayam, tiriskan lalu goreng sebentar. Suwir-suwir daging ayam.')),
        const StepsCompanion(stepNumber: Value(6), instruction: Value('Buat Koya: Haluskan kerupuk udang bersama bawang putih goreng hingga menjadi bubuk halus.'), tip: Value('Koya adalah rahasia kenikmatan soto Lamongan!')),
        const StepsCompanion(stepNumber: Value(7), instruction: Value('Tata kol, soun, dan ayam suwir di mangkuk.')),
        const StepsCompanion(stepNumber: Value(8), instruction: Value('Siram dengan kuah soto panas, taburi koya, seledri, dan beri irisan telur rebus.')),
      ]
    ),
    // 5. Es Teler
    RecipeSeed(
      const RecipesCompanion(
        title: Value('Es Teler'),
        description: Value('Minuman es manis dan segar dengan isian buah tropis.'),
        imageAsset: Value('assets/images/es_teler.jpg'),
        cookTime: Value(10),
        difficulty: Value('Mudah'),
        servings: Value(4),
      ),
      [
        const IngredientsCompanion(name: Value('Alpukat'), amount: Value(2), unit: Value('buah')),
        const IngredientsCompanion(name: Value('Kelapa Muda (kerok)'), amount: Value(1), unit: Value('buah')),
        const IngredientsCompanion(name: Value('Nangka (potong dadu)'), amount: Value(150), unit: Value('gram')),
        const IngredientsCompanion(name: Value('Susu Kental Manis'), amount: Value(8), unit: Value('sdm')),
        const IngredientsCompanion(name: Value('Sirup Gula / Cocopandan'), amount: Value(4), unit: Value('sdm')),
        const IngredientsCompanion(name: Value('Es Serut'), amount: Value(500), unit: Value('gram')),
        const IngredientsCompanion(name: Value('Selasih (seduh)'), amount: Value(1), unit: Value('sdm')),
        const IngredientsCompanion(name: Value('Air Kelapa Muda'), amount: Value(200), unit: Value('ml')),
      ],
      [
        const StepsCompanion(stepNumber: Value(1), instruction: Value('Kerok daging alpukat dan potong-potong buah nangka.')),
        const StepsCompanion(stepNumber: Value(2), instruction: Value('Siapkan gelas saji, susun kelapa muda, nangka, dan alpukat.')),
        const StepsCompanion(stepNumber: Value(3), instruction: Value('Tambahkan es serut hingga menggunung di atas buah.'), tip: Value('Bisa juga menggunakan es batu yang dipecahkan kecil-kecil.')),
        const StepsCompanion(stepNumber: Value(4), instruction: Value('Siram dengan air kelapa muda, sirup, dan susu kental manis. Taburi selasih di atasnya. Sajikan dingin!')),
      ]
    )
  ];
}
