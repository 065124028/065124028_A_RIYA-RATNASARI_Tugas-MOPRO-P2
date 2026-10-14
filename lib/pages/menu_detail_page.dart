import 'package:flutter/material.dart';

import 'menu_list_page.dart';

class MenuDetailPage extends StatefulWidget {
  const MenuDetailPage({super.key});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  final _store = AppStore.instance;
  final _note = TextEditingController();

  FoodItem? _item;
  int _qty = 1;
  String _size = 'Reguler';
  double _spice = 1;
  final Set<String> _selectedAddOns = {};

  FoodItem get item => _item!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _item ??=
        (ModalRoute.of(context)?.settings.arguments as FoodItem?) ?? kMenu.first;
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  List<AddOn> get _chosenAddOns => addOnsFor(item.category)
      .where((a) => _selectedAddOns.contains(a.name))
      .toList();

  CartLine _buildLine() => CartLine(
        item: item,
        qty: _qty,
        size: _size,
        spice: item.spicy ? _spice.round() : 0,
        addOns: _chosenAddOns,
        note: _note.text,
      );

  int get _total => _buildLine().total;

  void _addAndBack() {
    final messenger = ScaffoldMessenger.of(context);
    _store.add(_buildLine());
    Navigator.pop(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$_qty× ${item.name} masuk keranjang')));
  }

  void _orderNow() {
    _store.add(_buildLine());
    Navigator.pushNamed(context, '/pesan');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 320,
            backgroundColor: item.colors.last,
            surfaceTintColor: Colors.transparent,
            leadingWidth: 64,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _RoundIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context),
              ),
            ),
            actions: [
              ListenableBuilder(
                listenable: _store,
                builder: (context, _) {
                  final fav = _store.isFav(item.id);
                  return _RoundIconButton(
                    icon: fav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: fav ? AppColors.maroon : AppColors.ink,
                    onTap: () => _store.toggleFav(item.id),
                  );
                },
              ),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: FoodThumb(
                item: item,
                radius: 0,
                iconSize: 64,
                heroTag: 'food-${item.id}',
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(26),
              child: Container(
                height: 26,
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeadline(),
                  const SizedBox(height: 16),
                  _buildInfoPills(),
                  const SizedBox(height: 18),
                  Text(
                    item.desc,
                    style: const TextStyle(
                      fontSize: 14.5,
                      height: 1.55,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 26),
                  _section('Ukuran porsi', child: _buildSize()),
                  if (item.spicy) ...[
                    const SizedBox(height: 26),
                    _section('Level pedas', child: _buildSpice()),
                  ],
                  const SizedBox(height: 26),
                  _section('Tambahan', trailing: 'Opsional', child: _buildAddOns()),
                  const SizedBox(height: 26),
                  _section('Catatan untuk Bu Sari', child: _buildNote()),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeadline() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.maroon.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10.5,
                    letterSpacing: .8,
                    fontWeight: FontWeight.w800,
                    color: AppColors.maroon,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 27,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.5,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              rupiah(item.price),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.maroon,
              ),
            ),
            const Text(
              'per porsi',
              style: TextStyle(fontSize: 12, color: AppColors.muted),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoPills() {
    Widget pill(IconData icon, Color color, String text) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 17, color: color),
              const SizedBox(width: 6),
              Text(
                text,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        pill(Icons.star_rounded, AppColors.amber,
            '${item.rating} (${item.reviews})'),
        pill(Icons.schedule_rounded, AppColors.maroon, '${item.minutes} menit'),
        pill(Icons.local_fire_department_rounded, const Color(0xFFE8663D),
            '${item.kcal} kkal'),
      ],
    );
  }

  Widget _section(String title, {String? trailing, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
              ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildSize() {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<String>(
        showSelectedIcon: false,
        segments: [
          const ButtonSegment(
            value: 'Reguler',
            icon: Icon(Icons.rice_bowl_outlined, size: 18),
            label: Text('Reguler'),
          ),
          ButtonSegment(
            value: 'Besar',
            icon: const Icon(Icons.restaurant_rounded, size: 18),
            label: Text('Besar +${rupiah(kBigExtra).replaceFirst('Rp ', '')}'),
          ),
        ],
        selected: {_size},
        onSelectionChanged: (s) => setState(() => _size = s.first),
        style: SegmentedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.ink,
          selectedBackgroundColor: AppColors.maroon,
          selectedForegroundColor: Colors.white,
          side: const BorderSide(color: AppColors.line),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
        ),
      ),
    );
  }

  Widget _buildSpice() {
    final level = _spice.round();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  kSpiceLabels[level],
                  style: const TextStyle(
                      fontSize: 14.5, fontWeight: FontWeight.w700),
                ),
              ),
              Row(
                children: List.generate(
                  3,
                  (i) => Icon(
                    Icons.local_fire_department_rounded,
                    size: 20,
                    color: i < level
                        ? const Color(0xFFE8663D)
                        : AppColors.line,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: _spice,
            min: 0,
            max: 3,
            divisions: 3,
            label: kSpiceLabels[level],
            onChanged: (v) => setState(() => _spice = v),
          ),
        ],
      ),
    );
  }

  Widget _buildAddOns() {
    final list = addOnsFor(item.category);
    return Column(
      children: [
        for (final a in list)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _selectedAddOns.contains(a.name)
                    ? AppColors.maroon
                    : AppColors.line,
              ),
            ),
            child: CheckboxListTile(
              value: _selectedAddOns.contains(a.name),
              onChanged: (v) => setState(() {
                if (v == true) {
                  _selectedAddOns.add(a.name);
                } else {
                  _selectedAddOns.remove(a.name);
                }
              }),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Text(
                a.name,
                style: const TextStyle(
                    fontSize: 14.5, fontWeight: FontWeight.w600),
              ),
              secondary: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  a.price == 0 ? 'Gratis' : '+${rupiah(a.price)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNote() {
    return TextField(
      controller: _note,
      maxLines: 3,
      minLines: 2,
      maxLength: 80,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: 'Contoh: sambalnya dipisah ya, Bu',
        hintStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.maroon, width: 1.4),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
              color: Color(0x1A000000), blurRadius: 24, offset: Offset(0, -6)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total harga',
                          style: TextStyle(fontSize: 12, color: AppColors.muted),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (c, a) =>
                              FadeTransition(opacity: a, child: c),
                          child: Text(
                            rupiah(_total),
                            key: ValueKey(_total),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.maroon,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  QtyStepper(
                    value: _qty,
                    onChanged: (v) => setState(() => _qty = v),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _addAndBack,
                      icon: const Icon(Icons.add_shopping_cart_rounded, size: 19),
                      label: const Text('Keranjang'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _orderNow,
                      child: const Text('Pesan Sekarang'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.color = AppColors.ink,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white.withValues(alpha: .92),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, size: 19, color: color),
          ),
        ),
      ),
    );
  }
}