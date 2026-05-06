import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _allIngredients = [];
  final Set<int> _selectedIndexes = {};
  bool _isLoading = false;

  void _addIngredient(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty && !_allIngredients.contains(trimmed)) {
      setState(() {
        _allIngredients.add(trimmed);
        _selectedIndexes.add(_allIngredients.length - 1);
      });
    }
    _controller.clear();
  }

  void _removeIngredient(int index) {
    setState(() {
      _allIngredients.removeAt(index);
      final newSelected = <int>{};
      for (final i in _selectedIndexes) {
        if (i < index) {
          newSelected.add(i);
        } else if (i > index) {
          newSelected.add(i - 1);
        }
      }
      _selectedIndexes
        ..clear()
        ..addAll(newSelected);
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  List<String> get _selectedIngredients =>
      _selectedIndexes.map((i) => _allIngredients[i]).toList();

  Future<void> _searchRecipes() async {
    if (_selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal 1 bahan untuk mencari resep!'),
          backgroundColor: Color(0xFF587893),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final recipes = await AiService.getRecipeRecommendations(
        _selectedIngredients,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(recipes: recipes)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil resep: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF203A56),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF203A56),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restaurant_menu,
              color: const Color(0xFF98F6CD),
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              'LetHimCook',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Text(
                        'Mau masak apa\nhari ini? 🤌🏻',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tambahkan bahan, lalu pilih yang ingin digunakan.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF587893).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(
                              0xFF95CED3,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Ketik bahan (misal: ayam, bawang...)',
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                              fontSize: 15,
                            ),
                            prefixIcon: const Icon(
                              Icons.add_shopping_cart,
                              color: Color(0xFF95CED3),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: Color(0xFF98F6CD),
                                size: 28,
                              ),
                              onPressed: () => _addIngredient(_controller.text),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          onSubmitted: _addIngredient,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (_allIngredients.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.kitchen,
                              color: Color(0xFF95CED3),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Daftar Bahan (${_selectedIndexes.length}/${_allIngredients.length} dipilih):',
                              style: const TextStyle(
                                color: Color(0xFF95CED3),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ]),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: _allIngredients.isEmpty
                      ? SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.egg_outlined,
                                  size: 64,
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Belum ada bahan.\nTambahkan bahan di atas!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final isSelected = _selectedIndexes.contains(index);
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(
                                        0xFF98F6CD,
                                      ).withValues(alpha: 0.15)
                                    : const Color(
                                        0xFF587893,
                                      ).withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(
                                          0xFF98F6CD,
                                        ).withValues(alpha: 0.5)
                                      : Colors.transparent,
                                ),
                              ),
                              child: ListTile(
                                dense: true,
                                leading: Checkbox(
                                  value: isSelected,
                                  onChanged: (_) => _toggleSelection(index),
                                  activeColor: const Color(0xFF98F6CD),
                                  checkColor: const Color(0xFF203A56),
                                  side: const BorderSide(
                                    color: Color(0xFF95CED3),
                                  ),
                                ),
                                title: Text(
                                  _allIngredients[index],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.6),
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.white.withValues(alpha: 0.4),
                                  ),
                                  onPressed: () => _removeIngredient(index),
                                ),
                                onTap: () => _toggleSelection(index),
                              ),
                            );
                          }, childCount: _allIngredients.length),
                        ),
                ),

                SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: true,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _searchRecipes,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF98F6CD),
                              foregroundColor: const Color(0xFF203A56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: const Color(
                                0xFF98F6CD,
                              ).withValues(alpha: 0.4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.auto_awesome, size: 22),
                                const SizedBox(width: 10),
                                Text(
                                  _selectedIndexes.isEmpty
                                      ? 'Pilih Bahan Dulu'
                                      : 'Cari Resep (${_selectedIndexes.length} bahan)',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_isLoading)
            Container(
              color: const Color(0xFF203A56).withValues(alpha: 0.85),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 56,
                      height: 56,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF98F6CD),
                        ),
                        strokeWidth: 4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'LET HIM COOK... 🔥',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
