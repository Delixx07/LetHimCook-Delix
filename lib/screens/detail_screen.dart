import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/db_service.dart';
import '../services/tflite_service.dart';

class DetailScreen extends StatefulWidget {
  final Recipe recipe;

  const DetailScreen({super.key, required this.recipe});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorite = false;
  String _aiClassification = "Menganalisis... ⏳";

  @override
  void initState() {
    super.initState();
    _checkFavorite();
    _runAiClassification();
  }

  Future<void> _runAiClassification() async {
    final result = await TfliteService.classifyRecipeHealth(widget.recipe);
    if (mounted) {
      setState(() => _aiClassification = result);
    }
  }

  Future<void> _checkFavorite() async {
    final isFav = await DbService.isFavorite(widget.recipe.nama);
    if (mounted) {
      setState(() => _isFavorite = isFav);
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await DbService.removeFavorite(widget.recipe.nama);
    } else {
      await DbService.addFavorite(widget.recipe);
    }
    await _checkFavorite();
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Disimpan ke Favorit 🤍' : 'Dihapus dari Favorit'),
        backgroundColor: const Color(0xFF587893),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF203A56),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF587893),
            expandedHeight: 180,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: const Color(0xFF98F6CD),
                  size: 28,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.recipe.nama,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF587893), Color(0xFF203A56)],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 64,
                    color: const Color(0xFF98F6CD).withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(),
                  const SizedBox(height: 16),
                  
                  // AI Classification Badge
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _aiClassification.contains('Sehat') && !_aiClassification.contains('Kurang')
                          ? Colors.green.withValues(alpha: 0.2)
                          : Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _aiClassification.contains('Sehat') && !_aiClassification.contains('Kurang')
                            ? Colors.green.withValues(alpha: 0.5)
                            : Colors.orange.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      _aiClassification,
                      style: TextStyle(
                        color: _aiClassification.contains('Sehat') && !_aiClassification.contains('Kurang')
                            ? Colors.greenAccent
                            : Colors.orangeAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 28),

                  _buildSectionTitle(
                    Icons.shopping_basket,
                    'Bahan-bahan yang Dibutuhkan',
                  ),
                  const SizedBox(height: 14),
                  _buildBahanList(),
                  const SizedBox(height: 32),

                  _buildSectionTitle(
                    Icons.format_list_numbered,
                    'Langkah-langkah Memasak',
                  ),
                  const SizedBox(height: 14),
                  _buildLangkahList(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildInfoBadge(Icons.timer_outlined, widget.recipe.waktuMasak),
        _buildInfoBadge(Icons.checklist, '${widget.recipe.bahanLengkap.length} bahan'),
        _buildInfoBadge(
          Icons.list_alt,
          '${widget.recipe.langkahLangkah.length} langkah',
        ),
      ],
    );
  }

  Widget _buildInfoBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF587893).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF95CED3).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF98F6CD), size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF95CED3).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF98F6CD), size: 22),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBahanList() {
    return Column(
      children: widget.recipe.bahanLengkap.map((bahan) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Icon(Icons.circle, color: Color(0xFF98F6CD), size: 8),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  bahan,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLangkahList() {
    return Column(
      children: List.generate(widget.recipe.langkahLangkah.length, (index) {
        final langkah = widget.recipe.langkahLangkah[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF98F6CD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Color(0xFF203A56),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF587893).withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF95CED3).withValues(alpha: 0.15),
                    ),
                  ),
                  child: Text(
                    langkah,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
