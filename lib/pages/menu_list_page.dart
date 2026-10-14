import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//  BAGIAN BERSAMA (dipakai juga oleh menu_detail_page.dart & order_page.dart)
//  Ditaruh di sini supaya struktur folder project tetap sama.

class AppColors {
  AppColors._();
  static const maroon = Color(0xFF7B1E2B);
  static const maroonDark = Color(0xFF55121D);
  static const amber = Color(0xFFF2A93B);
  static const cream = Color(0xFFFAF5EE);
  static const ink = Color(0xFF2A1A1D);
  static const muted = Color(0xFF8C7C7F);
  static const line = Color(0xFFEFE5DB);
  static const success = Color(0xFF2E7D5B);
}

const softShadow = [
  BoxShadow(color: Color(0x147B1E2B), blurRadius: 24, offset: Offset(0, 10)),
];

String rupiah(int v) {
  final s = v.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return '${v < 0 ? '-' : ''}Rp $b';
}

class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.minutes,
    required this.kcal,
    required this.colors,
    this.image,
    this.spicy = false,
    this.popular = false,
  });

  final int id;
  final String name;
  final String desc;
  final int price;
  final String category;
  final double rating;
  final int reviews;
  final int minutes;
  final int kcal;
  final List<Color> colors;

  final String? image;
  final bool spicy;
  final bool popular;
}

const kMenu = <FoodItem>[
  FoodItem(
    id: 1,
    name: 'Nasi Goreng Spesial',
    desc: 'Nasi goreng bumbu rempah dengan telur, ayam suwir, acar, dan kerupuk renyah.',
    price: 15000,
    category: 'Makanan',
    rating: 4.8,
    reviews: 320,
    minutes: 12,
    kcal: 520,
    colors: [Color(0xFFFFD59A), Color(0xFFF29B4B)],
    image: 'https://share.google/fksphdC8jJXQziweX',
    spicy: true,
    popular: true,
  ),
  FoodItem(
    id: 2,
    name: 'Ayam Geprek Sambal Bawang',
    desc: 'Ayam crispy digeprek bersama sambal bawang segar, disajikan dengan nasi hangat.',
    price: 18000,
    category: 'Makanan',
    rating: 4.9,
    reviews: 512,
    minutes: 10,
    kcal: 610,
    colors: [Color(0xFFFFC9A8), Color(0xFFE8663D)],
    image: 'assets/images/ayam_geprek.jpg',
    spicy: true,
    popular: true,
  ),
  FoodItem(
    id: 3,
    name: 'Mie Ayam Bakso',
    desc: 'Mie kenyal dengan topping ayam kecap, bakso sapi, dan pangsit goreng.',
    price: 14000,
    category: 'Makanan',
    rating: 4.7,
    reviews: 284,
    minutes: 8,
    kcal: 450,
    colors: [Color(0xFFFFE3A3), Color(0xFFE9B44C)],
    image: 'assets/images/mie_ayam.jpg',
    spicy: true,
  ),
  FoodItem(
    id: 4,
    name: 'Soto Ayam Lamongan',
    desc: 'Kuah kuning gurih khas Lamongan, isi suwiran ayam, soun, dan telur rebus.',
    price: 16000,
    category: 'Makanan',
    rating: 4.6,
    reviews: 198,
    minutes: 9,
    kcal: 380,
    colors: [Color(0xFFFFF0B8), Color(0xFFF0C94A)],
    image: 'assets/images/soto_ayam.jpg',
  ),
  FoodItem(
    id: 5,
    name: 'Gado-Gado Siram',
    desc: 'Sayuran segar, tahu, tempe, dan lontong disiram saus kacang yang kental.',
    price: 13000,
    category: 'Makanan',
    rating: 4.5,
    reviews: 143,
    minutes: 7,
    kcal: 340,
    colors: [Color(0xFFCDEBB0), Color(0xFF7CBF6A)],
    image: 'assets/images/gado_gado.jpg',
  ),
  FoodItem(
    id: 6,
    name: 'Es Teh Tarik',
    desc: 'Teh pekat dengan susu creamy, ditarik hingga berbusa. Dingin dan menyegarkan.',
    price: 8000,
    category: 'Minuman',
    rating: 4.8,
    reviews: 610,
    minutes: 3,
    kcal: 180,
    colors: [Color(0xFFE9CDB3), Color(0xFFB9825B)],
    image: 'assets/images/es_teh_tarik.jpg',
    popular: true,
  ),
  FoodItem(
    id: 7,
    name: 'Es Jeruk Peras',
    desc: 'Jeruk peras asli tanpa pengawet, disajikan dengan es batu kristal.',
    price: 7000,
    category: 'Minuman',
    rating: 4.6,
    reviews: 220,
    minutes: 3,
    kcal: 120,
    colors: [Color(0xFFFFE0A6), Color(0xFFFFA93B)],
    image: 'assets/images/es_jeruk.jpg',
  ),
  FoodItem(
    id: 8,
    name: 'Pisang Goreng Keju',
    desc: 'Pisang kepok goreng tepung garing, ditaburi keju parut dan susu kental manis.',
    price: 10000,
    category: 'Camilan',
    rating: 4.7,
    reviews: 305,
    minutes: 6,
    kcal: 290,
    colors: [Color(0xFFFFF0B3), Color(0xFFF5C242)],
    image: 'assets/images/pisang_goreng.jpg',
  ),
  FoodItem(
    id: 9,
    name: 'Batagor Kuah Kacang',
    desc: 'Batagor ikan tenggiri goreng dengan bumbu kacang pedas manis dan perasan jeruk.',
    price: 12000,
    category: 'Camilan',
    rating: 4.6,
    reviews: 167,
    minutes: 8,
    kcal: 330,
    colors: [Color(0xFFFFD9C2), Color(0xFFE58A5C)],
    image: 'assets/images/batagor.jpg',
    spicy: true,
  ),
];

class AddOn {
  const AddOn(this.name, this.price);
  final String name;
  final int price;
}

List<AddOn> addOnsFor(String category) {
  switch (category) {
    case 'Minuman':
      return const [AddOn('Tambah boba', 4000), AddOn('Whipped cream', 3000)];
    case 'Camilan':
      return const [AddOn('Saus keju', 3000), AddOn('Mayones', 2000)];
    default:
      return const [
        AddOn('Telur mata sapi', 4000),
        AddOn('Kerupuk', 2000),
        AddOn('Sambal extra', 1000),
      ];
  }
}

const kBigExtra = 4000; // tambahan harga untuk porsi "Besar"
const kSpiceLabels = ['Tidak pedas', 'Sedang', 'Pedas', 'Level setan'];

class CartLine {
  CartLine({
    required this.item,
    this.qty = 1,
    this.size = 'Reguler',
    this.spice = 0,
    this.addOns = const [],
    this.note = '',
  });

  final FoodItem item;
  int qty;
  final String size;
  final int spice;
  final List<AddOn> addOns;
  final String note;

  int get unitPrice =>
      item.price +
      (size == 'Besar' ? kBigExtra : 0) +
      addOns.fold(0, (s, a) => s + a.price);

  int get total => unitPrice * qty;

  String get key {
    final names = addOns.map((a) => a.name).toList()..sort();
    return '${item.id}|$size|$spice|${names.join(',')}|$note';
  }

  String describe() {
    final parts = <String>[size];
    if (item.spicy) parts.add(kSpiceLabels[spice]);
    parts.addAll(addOns.map((a) => a.name));
    if (note.trim().isNotEmpty) parts.add('“${note.trim()}”');
    return parts.join(' · ');
  }
}

class AppStore extends ChangeNotifier {
  AppStore._();
  static final AppStore instance = AppStore._();

  final List<CartLine> _lines = [];
  final Set<int> _favorites = {};

  List<CartLine> get lines => List.unmodifiable(_lines);
  int get count => _lines.fold(0, (s, l) => s + l.qty);
  int get subtotal => _lines.fold(0, (s, l) => s + l.total);

  bool isFav(int id) => _favorites.contains(id);

  void toggleFav(int id) {
    if (!_favorites.remove(id)) _favorites.add(id);
    notifyListeners();
  }

  void add(CartLine line) {
    final i = _lines.indexWhere((l) => l.key == line.key);
    if (i >= 0) {
      _lines[i].qty += line.qty;
    } else {
      _lines.add(line);
    }
    notifyListeners();
  }

  void setQty(CartLine line, int qty) {
    if (qty <= 0) {
      remove(line);
    } else {
      line.qty = qty;
      notifyListeners();
    }
  }

  int remove(CartLine line) {
    final i = _lines.indexOf(line);
    if (i >= 0) {
      _lines.removeAt(i);
      notifyListeners();
    }
    return i;
  }

  void insert(int index, CartLine line) {
    if (index < 0) index = 0;
    if (index > _lines.length) index = _lines.length;
    _lines.insert(index, line);
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}

class FoodThumb extends StatelessWidget {
  const FoodThumb({
    super.key,
    required this.item,
    this.width,
    this.height,
    this.iconSize = 40,
    this.radius = 20,
    this.heroTag,
  });

  final FoodItem item;
  final double? width;
  final double? height;
  final double iconSize;
  final double radius;
  final String? heroTag;

  Widget _fallback() {
    return Center(
      child: Icon(
        Icons.restaurant_rounded,
        size: iconSize,
        color: Colors.white.withValues(alpha: .7),
      ),
    );
  }

  Widget _photo() {
    final path = item.image;
    if (path == null) return const SizedBox.shrink();

    Widget fade(BuildContext c, Widget child, int? frame, bool sync) {
      if (sync) return child;
      return AnimatedOpacity(
        opacity: frame == null ? 0 : 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        child: child,
      );
    }

    Widget broken(BuildContext c, Object e, StackTrace? st) =>
        const SizedBox.shrink();

    if (path.startsWith('http')) {
      return Image.network(path,
          fit: BoxFit.cover,
          frameBuilder: fade,
          errorBuilder: broken);
    }
    return Image.asset(path,
        fit: BoxFit.cover, frameBuilder: fade, errorBuilder: broken);
  }

  @override
  Widget build(BuildContext context) {
    final thumb = Material(
      type: MaterialType.transparency,
      child: Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: item.colors,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [_fallback(), _photo()],
        ),
      ),
    );
    return heroTag == null ? thumb : Hero(tag: heroTag!, child: thumb);
  }
}

class QtyStepper extends StatelessWidget {
  const QtyStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.minValue = 1,
    this.maxValue = 20,
    this.compact = false,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int minValue;
  final int maxValue;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final s = compact ? 30.0 : 38.0;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(s),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove_rounded, value > minValue,
              () => onChanged(value - 1), s, false),
          SizedBox(
            width: compact ? 28 : 38,
            child: Center(
              child: Text(
                '$value',
                style: TextStyle(
                  fontSize: compact ? 14 : 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
          _btn(Icons.add_rounded, value < maxValue, () => onChanged(value + 1),
              s, true),
        ],
      ),
    );
  }

  Widget _btn(
      IconData icon, bool enabled, VoidCallback onTap, double size, bool filled) {
    final bg = filled && enabled ? AppColors.maroon : Colors.white;
    final fg = filled && enabled
        ? Colors.white
        : (enabled ? AppColors.ink : AppColors.muted.withValues(alpha: .5));
    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: size - 6,
          height: size - 6,
          child: Icon(icon, size: compact ? 16 : 18, color: fg),
        ),
      ),
    );
  }
}

//  HALAMAN BERANDA (DAFTAR MENU)

class _Promo {
  const _Promo(this.title, this.subtitle, this.code, this.itemId, this.colors);
  final String title;
  final String subtitle;
  final String code;
  final int itemId; // id menu yang fotonya dipajang di banner
  final List<Color> colors;
}

const _promos = <_Promo>[
  _Promo('Diskon 10%', 'Maks. Rp 10.000 untuk semua menu pilihan', 'SARI10',
      1, [Color(0xFF8E2433), Color(0xFF55121D)]),
  _Promo('Potongan Rp 5.000', 'Min. belanja Rp 15.000, berlaku hari ini',
      'HEMAT5', 2, [Color(0xFFE8892B), Color(0xFFC2571A)]),
  _Promo('Bebas Biaya Layanan', 'Pesan sekarang tanpa biaya tambahan',
      'BEBAS', 5, [Color(0xFF2F7D5E), Color(0xFF1F5A43)]),
];

class MenuListPage extends StatefulWidget {
  const MenuListPage({super.key});

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  final _store = AppStore.instance;
  final _search = TextEditingController();
  final _promoCtrl = PageController(viewportFraction: .9);

  int _promoIndex = 0;
  String _category = 'Semua';
  String _query = '';

  static const _categories = ['Semua', 'Makanan', 'Minuman', 'Camilan', 'Favorit'];

  @override
  void dispose() {
    _search.dispose();
    _promoCtrl.dispose();
    super.dispose();
  }

  List<FoodItem> get _filtered {
    final q = _query.trim().toLowerCase();
    return kMenu.where((i) {
      final byCat = switch (_category) {
        'Semua' => true,
        'Favorit' => _store.isFav(i.id),
        _ => i.category == _category,
      };
      final byQuery = q.isEmpty ||
          i.name.toLowerCase().contains(q) ||
          i.desc.toLowerCase().contains(q);
      return byCat && byQuery;
    }).toList();
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 11) return 'Selamat pagi';
    if (h < 15) return 'Selamat siang';
    if (h < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  void _quickAdd(FoodItem item) {
    _store.add(CartLine(item: item));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${item.name} masuk keranjang'),
          action: SnackBarAction(
            label: 'LIHAT',
            onPressed: () => Navigator.pushNamed(context, '/pesan'),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: _store,
          builder: (context, _) {
            final items = _filtered;
            return CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildSearch()),
                SliverToBoxAdapter(
                  child: _query.isEmpty ? _buildPromo() : const SizedBox(height: 8),
                ),
                SliverToBoxAdapter(child: _buildCategories()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Menu Hari Ini',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        Text(
                          '${items.length} menu',
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ),
                if (items.isEmpty)
                  SliverToBoxAdapter(child: _buildEmpty())
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                    sliver: SliverList.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, i) => _MenuCard(
                        item: items[i],
                        isFav: _store.isFav(items[i].id),
                        onFav: () => _store.toggleFav(items[i].id),
                        onAdd: () => _quickAdd(items[i]),
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: items[i],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _store,
        builder: (context, _) {
          final has = _store.count > 0;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            transitionBuilder: (child, anim) => SizeTransition(
              sizeFactor: anim,
              axisAlignment: -1,
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: has
                ? SafeArea(
                    key: const ValueKey('bar'),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
                      child: _buildCartBar(),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting,
                  style: const TextStyle(fontSize: 14, color: AppColors.muted),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Mau makan apa\nhari ini?',
                  style: TextStyle(
                    fontSize: 28,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.5,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8, color: AppColors.success),
                      SizedBox(width: 6),
                      Text(
                        'Kantin Bu Sari · Buka 07.00 – 16.00',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: softShadow,
            ),
            child: Badge(
              isLabelVisible: _store.count > 0,
              label: Text('${_store.count}'),
              backgroundColor: AppColors.amber,
              textColor: AppColors.ink,
              offset: const Offset(-4, 4),
              child: IconButton(
                iconSize: 24,
                padding: const EdgeInsets.all(12),
                icon: const Icon(Icons.shopping_bag_outlined,
                    color: AppColors.ink),
                onPressed: () => Navigator.pushNamed(context, '/pesan'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: TextField(
        controller: _search,
        onChanged: (v) => setState(() => _query = v),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Cari menu favoritmu…',
          hintStyle: const TextStyle(color: AppColors.muted),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () {
                    _search.clear();
                    setState(() => _query = '');
                  },
                ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.maroon, width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _buildPromo() {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _promoCtrl,
            itemCount: _promos.length,
            padEnds: false,
            onPageChanged: (i) => setState(() => _promoIndex = i),
            itemBuilder: (context, i) {
              final p = _promos[i];
              return Padding(
                padding: EdgeInsets.only(left: i == 0 ? 20 : 0, right: 12),
                child: GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: p.code));
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text('Kode ${p.code} disalin. Pakai di keranjang!'),
                      ));
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: p.colors,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: p.colors.last.withValues(alpha: .28),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -18,
                          bottom: -18,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: .85),
                                  width: 4),
                            ),
                            child: FoodThumb(
                              item: kMenu.firstWhere((m) => m.id == p.itemId),
                              width: 122,
                              height: 122,
                              radius: 61,
                              iconSize: 46,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 110, 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: .2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'KODE: ${p.code}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        letterSpacing: .6,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.copy_rounded,
                                        size: 12, color: Colors.white),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                p.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                p.subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.3,
                                  color: Colors.white.withValues(alpha: .85),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promos.length, (i) {
            final active = i == _promoIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 22 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.maroon
                    : AppColors.maroon.withValues(alpha: .18),
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final c = _categories[i];
          final sel = c == _category;
          return ChoiceChip(
            showCheckmark: false,
            avatar: c == 'Favorit'
                ? Icon(Icons.favorite_rounded,
                    size: 16, color: sel ? Colors.white : AppColors.maroon)
                : null,
            label: Text(c),
            selected: sel,
            onSelected: (_) => setState(() => _category = c),
            selectedColor: AppColors.maroon,
            backgroundColor: Colors.white,
            shape: const StadiumBorder(),
            side: BorderSide(color: sel ? AppColors.maroon : AppColors.line),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: sel ? Colors.white : AppColors.ink,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    final isFav = _category == 'Favorit' && _query.isEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 40, 32, 40),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: AppColors.maroon.withValues(alpha: .08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFav ? Icons.favorite_border_rounded : Icons.search_off_rounded,
              size: 38,
              color: AppColors.maroon,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isFav ? 'Belum ada favorit' : 'Menu tidak ditemukan',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            isFav
                ? 'Ketuk ikon hati pada menu untuk menyimpannya di sini.'
                : 'Coba kata kunci lain atau pilih kategori berbeda.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildCartBar() {
    return Material(
      color: AppColors.maroon,
      borderRadius: BorderRadius.circular(20),
      elevation: 6,
      shadowColor: AppColors.maroon.withValues(alpha: .4),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.pushNamed(context, '/pesan'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.amber,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  '${_store.count}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Lihat keranjang',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                rupiah(_store.subtotal),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.item,
    required this.isFav,
    required this.onFav,
    required this.onAdd,
    required this.onTap,
  });

  final FoodItem item;
  final bool isFav;
  final VoidCallback onFav;
  final VoidCallback onAdd;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Stack(
                  children: [
                    FoodThumb(
                      item: item,
                      width: 108,
                      height: 108,
                      iconSize: 46,
                      radius: 20,
                      heroTag: 'food-${item.id}',
                    ),
                    if (item.popular)
                      Positioned(
                        top: 7,
                        left: 7,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.amber,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Terlaris',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          InkResponse(
                            onTap: onFav,
                            radius: 18,
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                isFav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 20,
                                color: isFav ? AppColors.maroon : AppColors.muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.35,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 16, color: AppColors.amber),
                          const SizedBox(width: 3),
                          Text(
                            '${item.rating}',
                            style: const TextStyle(
                                fontSize: 12.5, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.schedule_rounded,
                              size: 14, color: AppColors.muted),
                          const SizedBox(width: 3),
                          Text(
                            '${item.minutes} mnt',
                            style: const TextStyle(
                                fontSize: 12.5, color: AppColors.muted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              rupiah(item.price),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.maroon,
                              ),
                            ),
                          ),
                          Material(
                            color: AppColors.maroon,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: onAdd,
                              child: const SizedBox(
                                width: 36,
                                height: 36,
                                child: Icon(Icons.add_rounded,
                                    color: Colors.white, size: 22),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}