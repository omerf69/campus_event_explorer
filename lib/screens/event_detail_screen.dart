import 'package:flutter/material.dart';
import '../models/event_model.dart';
import 'image_viewer_screen.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  final VoidCallback onStateChanged;

  const EventDetailScreen({
    super.key,
    required this.event,
    required this.onStateChanged,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  void _toggleFavorite() {
    setState(() {
      widget.event.isFavorite = !widget.event.isFavorite;
    });
    widget.onStateChanged();
  }

  void _showJoinDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.how_to_reg, color: Color(0xFF1E5B99)),
            SizedBox(width: 8),
            Text('Katılım Onayı'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.event.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month,
                          size: 16, color: Colors.blueGrey),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(_formatDateTime(widget.event.dateTime))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.place,
                          size: 16, color: Color(0xFFC0392B)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(widget.event.venue)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Bu ESTÜ kampüs etkinliğine katılmak istiyor musunuz? Kontenjandan 1 yer rezerve edilecektir.',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hayır', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E5B99),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _joinEvent();
            },
            child: const Text('Evet, Katıl'),
          ),
        ],
      ),
    );
  }

  void _joinEvent() {
    if (widget.event.isJoined) return;
    if (widget.event.isFull || widget.event.availablePlaces <= 0) return;

    setState(() {
      widget.event.isJoined = true;
      widget.event.availablePlaces =
          (widget.event.availablePlaces - 1).clamp(0, widget.event.totalCapacity);
    });
    widget.onStateChanged();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                  'Tebrikler! "${widget.event.title}" etkinliğine katıldınız.'),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF27AE60),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFC0392B)),
            SizedBox(width: 8),
            Text('Katılımı İptal Et'),
          ],
        ),
        content: Text(
            '"${widget.event.title}" etkinliğine katılımınızı iptal etmek istediğinize emin misiniz? Yerinizi başka bir öğrenci alabilir.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hayır', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC0392B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _cancelParticipation();
            },
            child: const Text('Evet, İptal Et'),
          ),
        ],
      ),
    );
  }

  void _cancelParticipation() {
    if (!widget.event.isJoined) return;

    setState(() {
      widget.event.isJoined = false;
      widget.event.availablePlaces =
          (widget.event.availablePlaces + 1).clamp(0, widget.event.totalCapacity);
    });
    widget.onStateChanged();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                  '"${widget.event.title}" katılımınız iptal edildi, kontenjan geri açıldı.'),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFD35400),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year} • '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Technology':
        return const Color(0xFF1E5B99);
      case 'Arts':
        return const Color(0xFF8E44AD);
      case 'Sports':
        return const Color(0xFF27AE60);
      case 'Music':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFF455A64);
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final catColor = _getCategoryColor(event.category);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              event.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: event.isFavorite ? const Color(0xFFE74C3C) : null,
              size: 26,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner with Hero & Double-tap indicator
            GestureDetector(
              onDoubleTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImageViewerScreen(
                      imagePath: event.imagePath,
                      title: event.title,
                      eventId: event.id,
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Hero(
                    tag: 'event_image_${event.id}',
                    child: SizedBox(
                      height: 260,
                      width: double.infinity,
                      child: Image.asset(
                        event.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Gradient Shade
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Double Tap Badge
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.zoom_in, size: 16, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            'Büyütmek için çift tıkla',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ESTÜ University Tag
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB31B1B).withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school, size: 14, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            'ESTÜ KAMPÜS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category, ID Badge & Status
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.blueGrey.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Text(
                          'ID: #${event.id}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: catColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          event.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: catColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      _buildMiniStatus(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Event Title
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Details Grid Cards
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoTile(
                          icon: Icons.confirmation_number_outlined,
                          iconColor: const Color(0xFF607D8B),
                          title: 'Etkinlik Kodu (ID)',
                          subtitle: 'ESTU-EVT-00${event.id}',
                        ),
                        const Divider(height: 20),
                        _buildInfoTile(
                          icon: Icons.calendar_month,
                          iconColor: const Color(0xFF1E5B99),
                          title: 'Tarih & Saat',
                          subtitle: _formatDateTime(event.dateTime),
                        ),
                        const Divider(height: 20),
                        _buildInfoTile(
                          icon: Icons.location_on,
                          iconColor: const Color(0xFFC0392B),
                          title: 'Mekan & Konum',
                          subtitle: event.venue,
                        ),
                        const Divider(height: 20),
                        _buildInfoTile(
                          icon: Icons.groups,
                          iconColor: const Color(0xFF27AE60),
                          title: 'Kontenjan Durumu',
                          subtitle:
                              '${event.availablePlaces} / ${event.totalCapacity} boş yer mevcut',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Description
                  const Text(
                    'Etkinlik Hakkında',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      event.description,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: _buildActionButton(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStatus() {
    if (widget.event.isJoined) {
      return const Text(
        '✓ Katılımın Onaylandı',
        style: TextStyle(
          color: Color(0xFF27AE60),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      );
    } else if (widget.event.isFull) {
      return const Text(
        'Kontenjan Dolu',
        style: TextStyle(
          color: Color(0xFFC0392B),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      );
    } else {
      return Text(
        '${widget.event.availablePlaces} Yer Mevcut',
        style: TextStyle(
          color: Colors.blueGrey[700],
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      );
    }
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    if (widget.event.isJoined) {
      return ElevatedButton.icon(
        onPressed: _showCancelDialog,
        icon: const Icon(Icons.cancel_outlined),
        label: const Text(
          'Katılımı İptal Et',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC0392B),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 2,
        ),
      );
    } else if (widget.event.isFull) {
      return ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.block),
        label: const Text(
          'Kontenjan Doldu',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: _showJoinDialog,
        icon: const Icon(Icons.how_to_reg),
        label: const Text(
          'Etkinliğe Katıl',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E5B99),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 3,
        ),
      );
    }
  }
}
