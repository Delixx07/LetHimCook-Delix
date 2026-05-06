import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class AiService {
  static const String _apiKey = 'YOUR_GROQ_API_KEY';
  static const String _baseUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  static Future<List<Recipe>> getRecipeRecommendations(
    List<String> ingredients,
  ) async {
    final daftarBahan = ingredients.join(', ');

    final systemPrompt =
        'Kamu adalah koki profesional. Bahan yang tersedia: $daftarBahan. '
        'Berikan 3 rekomendasi resep. '
        'ATURAN: '
        '1. bahan_lengkap: sertakan takaran dan kondisi (contoh: "2 siung bawang merah, iris tipis"). Tambahkan bumbu dasar jika perlu. '
        '2. langkah_langkah: BUAT LEBIH DARI 3 LANGKAH (minimal 5-8 langkah per resep). Pecah proses memasak menjadi langkah-langkah detail dan berurutan seperti di Cookpad. '
        'Jelaskan ukuran api, durasi, dan tanda kematangan. Contoh: Langkah 1 siapkan bahan, Langkah 2 buat adonan/saus, Langkah 3 panaskan minyak & goreng, Langkah 4 campur bumbu, dst. '
        '3. Kembalikan HANYA JSON Array murni tanpa markdown. '
        'Format: nama, deskripsi_singkat, waktu_masak, bahan_lengkap (array), langkah_langkah (array).';

    final body = jsonEncode({
      'model': 'llama-3.3-70b-versatile',
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        {
          'role': 'user',
          'content': 'Berikan 3 rekomendasi resep dengan bahan: $daftarBahan',
        },
      ],
      'temperature': 0.7,
      'max_completion_tokens': 4096,
      'top_p': 1,
      'stream': false,
    });

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Groq API Error (${response.statusCode}): ${response.body}',
      );
    }

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final rawText = jsonResponse['choices'][0]['message']['content'] as String;

    return _parseRecipes(rawText);
  }

  static List<Recipe> _parseRecipes(String rawText) {
    String cleaned = rawText.trim();
    if (cleaned.startsWith('```')) {
      cleaned = cleaned.replaceFirst(RegExp(r'^```json?\s*'), '');
      cleaned = cleaned.replaceFirst(RegExp(r'```\s*$'), '');
      cleaned = cleaned.trim();
    }

    final List<dynamic> jsonList = jsonDecode(cleaned);
    return jsonList
        .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
