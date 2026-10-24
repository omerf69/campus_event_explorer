import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../data/event_data.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Event> _allEvents;
  int _currentIndex = 0;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allEvents = getInitialEvents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _categories {
    final cats = _allEvents.map((e) => e.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  List<Event> get _filteredEvents {
    List<Event> events;

    // Filter by tab
    switch (_currentIndex) {
      case 1: // Favorites
        events = _allEvents.where((e) => e.isFavorite).toList();
        break;
      case 2: // My Events
        events = _allEvents.where((e) => e.isJoined).toList();
        break;
      default: // Explore
        events = List.from(_allEvents);
    }

    // Filter by category
    if (_selectedCategory != 'All') {
      events = events.where((e) => e.category == _selectedCategory).toList();
    }

    // Filter by search
    if (_searchQuery.trim().isNotEmpty) {
      final query = _normalize(_searchQuery);
      events = events.where((e) {
        final title = _normalize(e.title);
        final rawTitle = e.title.toLowerCase();
        final rawQuery = _searchQuery.trim().toLowerCase();
        return title.contains(query) || rawTitle.contains(rawQuery);
      }).toList();
    }

    return events;
  }

  String _normalize(String input) {
    return input
        .trim()
        .toLowerCase()
        .replaceAll('İ', 'i')
        .replaceAll('I', 'ı')
        .replaceAll('\u0307', '');
  }

  int get _joinedCount => _allEvents.where((e) => e.isJoined).length;

  void _toggleFavorite(Event event) {
    setState(() {
      event.isFavorite = !event.isFavorite;
    });
  }

  void _openDetail(Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailScreen(
          event: event,
          onStateChanged: () {
            setState(() {});
          },
        ),
      ),
    );
    setState(() {});
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  String _getCategoryDisplayName(String cat) {
    switch (cat) {
      case 'All':
        return 'Tümü';
      case 'Technology':
        return 'Teknoloji';
      case 'Arts':
        return 'Sanat';
      case 'Sports':
        return 'Spor';
      case 'Music':
        return 'Müzik';
      default:
        return cat;
    }
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat) {
      case 'All':
        return Icons.auto_awesome;
      case 'Technology':
        return Icons.memory;
      case 'Arts':
        return Icons.palette;
      case 'Sports':
        return Icons.sports_soccer;
      case 'Music':
        return Icons.music_note;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredEvents;
    final tabTitles = [
      'ESTÜ Kampüs Keşfet',
      'Favori Etkinliklerim',
      'Katıldığım Etkinlikler'
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFF1E5B99).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.school,
                color: Color(0xFF1E5B99),
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tabTitles[_currentIndex],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF1A2530),
                  ),
                ),
                const Text(
                  'Eskişehir Teknik Üniversitesi',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (_currentIndex == 2)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E5B99), Color(0xFF2980B9)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E5B99).withValues(alpha: 0.3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle,
                          size: 14, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        '$_joinedCount Katılım',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Modern Search Box
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Etkinlik başlığı ile ara...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF1E5B99)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: _clearSearch,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          // Category Filter Chips
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    avatar: Icon(
                      _getCategoryIcon(cat),
                      size: 16,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                    label: Text(_getCategoryDisplayName(cat)),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13,
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFF1E5B99),
                    showCheckmark: false,
                    elevation: isSelected ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Result Count Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${filtered.length} etkinlik bulundu',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_searchQuery.isNotEmpty || _selectedCategory != 'All') ...[
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'All';
                        _clearSearch();
                      });
                    },
                    child: const Text(
                      'Filtreleri Sıfırla',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1E5B99),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Events List or Empty State
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20, top: 4),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final event = filtered[index];
                      return EventCard(
                        event: event,
                        onTap: () => _openDetail(event),
                        onFavoriteToggle: () => _toggleFavorite(event),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: const Color(0xFF1E5B99),
          unselectedItemColor: Colors.grey[500],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Keşfet',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favoriler',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: _joinedCount > 0,
                label: Text('$_joinedCount'),
                backgroundColor: const Color(0xFF1E5B99),
                child: const Icon(Icons.event_available_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: _joinedCount > 0,
                label: Text('$_joinedCount'),
                backgroundColor: const Color(0xFF1E5B99),
                child: const Icon(Icons.event_available),
              ),
              label: 'Etkinliklerim',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String title;
    String message;
    IconData icon;
    Color iconColor;

    if (_searchQuery.isNotEmpty || _selectedCategory != 'All') {
      title = 'Eşleşen Etkinlik Yok';
      message =
          'Arama kriterlerinize uygun etkinlik bulunamadı.\nFarklı bir anahtar kelime veya kategori deneyebilirsiniz.';
      icon = Icons.search_off_rounded;
      iconColor = const Color(0xFF1E5B99);
    } else if (_currentIndex == 1) {
      title = 'Henüz Favori Eklenmedi';
      message =
          'İlgilendiğiniz ESTÜ etkinliklerini kalp simgesine dokunarak favorilerinize kaydedebilirsiniz.';
      icon = Icons.favorite_border_rounded;
      iconColor = const Color(0xFFE74C3C);
    } else if (_currentIndex == 2) {
      title = 'Henüz Bir Etkinliğe Katılmadınız';
      message =
          'Kampüsteki etkinlikleri keşfedip "Katıl" butonuna tıklayarak yerinizi ayırtabilirsiniz.';
      icon = Icons.event_note_rounded;
      iconColor = const Color(0xFF27AE60);
    } else {
      title = 'Etkinlik Bulunamadı';
      message = 'Şu anda listelenecek etkinlik bulunmuyor.';
      icon = Icons.event_busy_rounded;
      iconColor = Colors.grey;
    }

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 56, color: iconColor),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              if (_searchQuery.isNotEmpty || _selectedCategory != 'All') ...[
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = 'All';
                      _clearSearch();
                    });
                  },
                  icon: const Icon(Icons.clear_all_rounded),
                  label: const Text('Aramayı ve Filtreleri Temizle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E5B99),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
