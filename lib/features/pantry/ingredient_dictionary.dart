/// A canonical list of common Indonesian kitchen ingredients, used as the
/// reference set for fuzzy typo correction when the user enters ingredients.
///
/// This is intentionally a curated, lowercase list of base ingredient names
/// (without quantities). It does not need to be exhaustive — it just needs to
/// cover the common items so obvious typos can be caught and gently corrected.
const List<String> kCommonIngredients = [
  // Pokok / karbohidrat
  'nasi', 'nasi putih', 'beras', 'mie', 'bihun', 'soun', 'kentang',
  'singkong', 'ubi', 'jagung', 'tepung terigu', 'tepung beras',
  'roti', 'pasta',
  // Protein
  'telur', 'telur ayam', 'ayam', 'daging sapi', 'daging ayam', 'ikan',
  'udang', 'cumi', 'tahu', 'tempe', 'bakso', 'sosis', 'kornet',
  // Sayuran
  'bawang merah', 'bawang putih', 'bawang bombay', 'cabai', 'cabai merah',
  'cabai rawit', 'cabai hijau', 'tomat', 'wortel', 'kentang', 'kol',
  'sawi', 'kangkung', 'bayam', 'tauge', 'kacang panjang', 'buncis',
  'terong', 'labu siam', 'jamur', 'timun', 'daun bawang', 'seledri',
  'daun jeruk', 'daun salam', 'sereh',
  // Bumbu & rempah
  'garam', 'gula', 'gula merah', 'merica', 'lada', 'ketumbar', 'kunyit',
  'jahe', 'lengkuas', 'kemiri', 'kencur', 'pala', 'kayu manis', 'cengkeh',
  'asam jawa', 'terasi', 'kaldu bubuk', 'penyedap',
  // Cairan & saus
  'minyak goreng', 'minyak', 'kecap manis', 'kecap asin', 'saus tiram',
  'saus tomat', 'saus sambal', 'santan', 'susu', 'susu kental manis',
  'air', 'air kelapa', 'cuka', 'madu', 'margarin', 'mentega', 'keju',
  // Buah
  'jeruk nipis', 'jeruk', 'alpukat', 'nangka', 'kelapa', 'kelapa muda',
  'pisang', 'mangga', 'nanas',
];
