import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'menu_list_page.dart';

class _ReceiptLine {
  const _ReceiptLine(this.name, this.qty, this.total, this.detail);
  final String name;
  final int qty;
  final int total;
  final String detail;
}

class _Receipt {
  const _Receipt({
    required this.no,
    required this.time,
    required this.lines,
    required this.subtotal,
    required this.service,
    required this.delivery,
    required this.discount,
    required this.total,
    required this.method,
    required this.payment,
  });

  final String no;
  final DateTime time;
  final List<_ReceiptLine> lines;
  final int subtotal;
  final int service;
  final int delivery;
  final int discount;
  final int total;
  final String method;
  final String payment;
}

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _store = AppStore.instance;
  final _voucherCtrl = TextEditingController();

  static const _payments = [
    ('Tunai', 'Bayar langsung di kasir', Icons.payments_outlined),
    ('QRIS', 'Scan QR di kasir', Icons.qr_code_2_rounded),
    ('E-Wallet', 'GoPay, OVO, DANA', Icons.account_balance_wallet_outlined),
  ];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  int _method = 0; // 0 = ambil sendiri, 1 = antar ke meja
  int _payment = 0;
  int _table = 5;
  bool _noCutlery = true;
  bool _submitting = false;
  String? _appliedCode;
  String? _voucherError;
  _Receipt? _receipt;

  @override
  void dispose() {
    _voucherCtrl.dispose();
    super.dispose();
  }

  // ---------- perhitungan ----------
  int get _serviceFee => _appliedCode == 'BEBAS' ? 0 : 1000;
  int get _deliveryFee => _method == 1 ? 2000 : 0;

  int get _discount {
    final sub = _store.subtotal;
    switch (_appliedCode) {
      case 'SARI10':
        return math.min(sub * 10 ~/ 100, 10000);
      case 'HEMAT5':
        return sub >= 15000 ? 5000 : 0;
      default:
        return 0;
    }
  }

  int get _grandTotal => _store.subtotal + _serviceFee + _deliveryFee - _discount;

  String get _methodLabel => _method == 0 ? 'Ambil di kasir' : 'Antar ke Meja $_table';

  // ---------- aksi ----------
  void _goHome() => Navigator.popUntil(context, (route) => route.isFirst);

  void _applyVoucher() {
    FocusScope.of(context).unfocus();
    final code = _voucherCtrl.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() => _voucherError = 'Masukkan kode voucher dulu');
      return;
    }
    if (!['SARI10', 'HEMAT5', 'BEBAS'].contains(code)) {
      setState(() => _voucherError = 'Kode tidak ditemukan');
      return;
    }
    if (code == 'HEMAT5' && _store.subtotal < 15000) {
      setState(() => _voucherError = 'Min. belanja ${rupiah(15000)}');
      return;
    }
    setState(() {
      _appliedCode = code;
      _voucherError = null;
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Voucher $code berhasil dipakai')));
  }

  void _removeVoucher() => setState(() {
        _appliedCode = null;
        _voucherCtrl.clear();
      });

  Future<void> _placeOrder() async {
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final now = DateTime.now();
    final receipt = _Receipt(
      no: 'KBS-${(now.millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}',
      time: now,
      lines: _store.lines
          .map((l) => _ReceiptLine(l.item.name, l.qty, l.total, l.describe()))
          .toList(),
      subtotal: _store.subtotal,
      service: _serviceFee,
      delivery: _deliveryFee,
      discount: _discount,
      total: _grandTotal,
      method: _methodLabel,
      payment: _payments[_payment].$1,
    );
    _store.clear();
    setState(() {
      _submitting = false;
      _receipt = receipt;
    });
  }

  // ---------- build ----------
  @override
  Widget build(BuildContext context) {
    final placed = _receipt != null;
    return PopScope(
      canPop: !placed,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(placed ? 'Struk Pesanan' : 'Keranjang Kamu'),
          automaticallyImplyLeading: !placed,
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: placed
              ? _buildReceipt(_receipt!)
              : ListenableBuilder(
                  key: const ValueKey('cart'),
                  listenable: _store,
                  builder: (context, _) =>
                      _store.lines.isEmpty ? _buildEmpty() : _buildCart(),
                ),
        ),
        bottomNavigationBar: ListenableBuilder(
          listenable: _store,
          builder: (context, _) {
            if (placed || _store.lines.isEmpty) return const SizedBox.shrink();
            return _buildBottomBar();
          },
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                color: AppColors.maroon.withValues(alpha: .08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_bag_outlined,
                  size: 48, color: AppColors.maroon),
            ),
            const SizedBox(height: 22),
            const Text(
              'Keranjangmu masih kosong',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Yuk pilih menu favoritmu dulu,\nBu Sari siap memasak!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, height: 1.45),
            ),
            const SizedBox(height: 26),
            FilledButton.icon(
              onPressed: _goHome,
              icon: const Icon(Icons.restaurant_menu_rounded, size: 20),
              label: const Text('Lihat Menu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCart() {
    final lines = _store.lines;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      children: [
        _title('Pesananmu', trailing: '${_store.count} item'),
        for (final l in lines) _lineTile(l),
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.swipe_left_rounded, size: 15, color: AppColors.muted),
              SizedBox(width: 6),
              Text(
                'Geser ke kiri untuk menghapus',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
        _title('Cara pengambilan'),
        _methodCard(),
        _title('Voucher'),
        _voucherCard(),
        _title('Metode pembayaran'),
        for (var i = 0; i < _payments.length; i++) _paymentTile(i),
        const SizedBox(height: 4),
        _card(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: SwitchListTile(
            value: _noCutlery,
            onChanged: (v) => setState(() => _noCutlery = v),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            title: const Text(
              'Tanpa sendok & garpu plastik',
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              'Bantu kurangi sampah plastik',
              style: TextStyle(fontSize: 12.5),
            ),
          ),
        ),
        _title('Ringkasan pembayaran'),
        _summaryCard(),
      ],
    );
  }

  Widget _title(String text, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ),
          if (trailing != null)
            Text(trailing,
                style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
        ],
      ),
    );
  }

  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: softShadow,
      ),
      child: child,
    );
  }

  Widget _lineTile(CartLine l) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ObjectKey(l),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFFDE8E8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.delete_outline_rounded,
              color: Color(0xFFD64545), size: 26),
        ),
        onDismissed: (_) {
          final index = _store.remove(l);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('${l.item.name} dihapus'),
                action: SnackBarAction(
                  label: 'BATALKAN',
                  onPressed: () => _store.insert(index, l),
                ),
              ),
            );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: softShadow,
          ),
          child: Row(
            children: [
              FoodThumb(
                item: l.item,
                width: 68,
                height: 68,
                iconSize: 30,
                radius: 16,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.describe(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.3,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      rupiah(l.total),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.maroon,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              QtyStepper(
                compact: true,
                value: l.qty,
                minValue: 0,
                onChanged: (v) => _store.setQty(l, v),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _methodCard() {
    return _card(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<int>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: 0,
                  icon: Icon(Icons.storefront_outlined, size: 18),
                  label: Text('Ambil'),
                ),
                ButtonSegment(
                  value: 1,
                  icon: Icon(Icons.table_restaurant_outlined, size: 18),
                  label: Text('Antar ke meja'),
                ),
              ],
              selected: {_method},
              onSelectionChanged: (s) => setState(() => _method = s.first),
              style: SegmentedButton.styleFrom(
                backgroundColor: AppColors.cream,
                foregroundColor: AppColors.ink,
                selectedBackgroundColor: AppColors.maroon,
                selectedForegroundColor: Colors.white,
                side: const BorderSide(color: AppColors.line),
                textStyle:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _method == 1
                ? Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _table,
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(14),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        items: [
                          for (var i = 1; i <= 12; i++)
                            DropdownMenuItem(value: i, child: Text('Meja $i')),
                        ],
                        onChanged: (v) => setState(() => _table = v ?? _table),
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
          Row(
            children: [
              Icon(
                _method == 0
                    ? Icons.info_outline_rounded
                    : Icons.delivery_dining_rounded,
                size: 17,
                color: AppColors.muted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _method == 0
                      ? 'Ambil pesananmu langsung di kasir Bu Sari.'
                      : 'Pesanan diantar ke mejamu (+${rupiah(2000)}).',
                  style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _voucherCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _voucherCtrl,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (_) {
                    if (_voucherError != null) {
                      setState(() => _voucherError = null);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Masukkan kode voucher',
                    hintStyle:
                        const TextStyle(color: AppColors.muted, fontSize: 14),
                    errorText: _voucherError,
                    prefixIcon: const Icon(Icons.local_offer_outlined,
                        size: 20, color: AppColors.muted),
                    filled: true,
                    fillColor: AppColors.cream,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.line),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: AppColors.maroon, width: 1.4),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFD64545)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFD64545)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 50,
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.maroon.withValues(alpha: .1),
                    foregroundColor: AppColors.maroon,
                    minimumSize: const Size(0, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                  onPressed: _applyVoucher,
                  child: const Text('Pakai'),
                ),
              ),
            ],
          ),
          if (_appliedCode != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      size: 18, color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Voucher $_appliedCode diterapkan',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close_rounded,
                        size: 18, color: AppColors.success),
                    onPressed: _removeVoucher,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          const Text(
            'Coba: SARI10 · HEMAT5 · BEBAS',
            style: TextStyle(fontSize: 12, color: AppColors.muted),
          ),
        ],
      ),
    );
  }

  Widget _paymentTile(int i) {
    final p = _payments[i];
    final sel = _payment == i;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => setState(() => _payment = i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: sel ? AppColors.maroon.withValues(alpha: .05) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: sel ? AppColors.maroon : AppColors.line,
              width: sel ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: sel ? AppColors.maroon : AppColors.cream,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(p.$3,
                    size: 22, color: sel ? Colors.white : AppColors.maroon),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.$1,
                        style: const TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(p.$2,
                        style: const TextStyle(
                            fontSize: 12.5, color: AppColors.muted)),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  sel
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  key: ValueKey(sel),
                  color: sel ? AppColors.maroon : AppColors.line,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard() {
    return _card(
      child: Column(
        children: [
          _sumRow('Subtotal', rupiah(_store.subtotal)),
          _sumRow('Biaya layanan',
              _serviceFee == 0 ? 'Gratis' : rupiah(_serviceFee),
              good: _serviceFee == 0),
          if (_method == 1) _sumRow('Antar ke meja', rupiah(_deliveryFee)),
          if (_discount > 0)
            _sumRow('Diskon ($_appliedCode)', '-${rupiah(_discount)}', good: true),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: AppColors.line),
          ),
          Row(
            children: [
              const Expanded(
                child: Text('Total',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
              Text(
                rupiah(_grandTotal),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.maroon,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sumRow(String label, String value, {bool good = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 14, color: AppColors.muted)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: good ? AppColors.success : AppColors.ink,
            ),
          ),
        ],
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
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Total pembayaran',
                      style: TextStyle(fontSize: 12, color: AppColors.muted)),
                  const SizedBox(height: 2),
                  Text(
                    rupiah(_grandTotal),
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: AppColors.maroon,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 18),
              Expanded(
                child: FilledButton(
                  onPressed: _submitting ? null : _placeOrder,
                  child: _submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Pesan Sekarang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- struk ----------
  String _fmtTime(DateTime t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '${t.day} ${_months[t.month - 1]} ${t.year} · $hh.$mm';
  }

  Widget _buildReceipt(_Receipt r) {
    return SingleChildScrollView(
      key: const ValueKey('receipt'),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
            builder: (context, v, child) =>
                Transform.scale(scale: v, child: child),
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: .35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.check_rounded, size: 46, color: Colors.white),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Pesanan Kamu Diterima!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tunjukkan struk ini ke kasir Bu Sari.',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.maroon,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.restaurant_rounded,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kantin Bu Sari',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800)),
                          Text('Struk pemesanan',
                              style: TextStyle(
                                  fontSize: 12.5, color: AppColors.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _recRow('No. pesanan', r.no, bold: true),
                _recRow('Waktu', _fmtTime(r.time)),
                const _DashedLine(),
                for (final l in r.lines)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${l.qty}×',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.maroon)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.name,
                                  style: const TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.w700)),
                              Text(l.detail,
                                  style: const TextStyle(
                                      fontSize: 11.5, color: AppColors.muted)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(rupiah(l.total),
                            style: const TextStyle(
                                fontSize: 13.5, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                const _DashedLine(),
                _recRow('Subtotal', rupiah(r.subtotal)),
                _recRow('Biaya layanan',
                    r.service == 0 ? 'Gratis' : rupiah(r.service)),
                if (r.delivery > 0) _recRow('Antar ke meja', rupiah(r.delivery)),
                if (r.discount > 0)
                  _recRow('Diskon', '-${rupiah(r.discount)}', good: true),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Total',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                    ),
                    Text(rupiah(r.total),
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: AppColors.maroon,
                        )),
                  ],
                ),
                const _DashedLine(),
                _recRow('Pengambilan', r.method),
                _recRow('Pembayaran', r.payment),
              ],
            ),
          ),
          const SizedBox(height: 18),
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: r.no));
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    const SnackBar(content: Text('Nomor pesanan disalin')));
            },
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: const Text('Salin nomor pesanan'),
            style: TextButton.styleFrom(foregroundColor: AppColors.maroon),
          ),
          const SizedBox(height: 6),
          FilledButton.icon(
            onPressed: _goHome,
            icon: const Icon(Icons.home_rounded, size: 20),
            label: const Text('Kembali ke Daftar Menu'),
          ),
        ],
      ),
    );
  }

  Widget _recRow(String label, String value, {bool bold = false, bool good = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 13.5, color: AppColors.muted)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: good ? AppColors.success : AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: LayoutBuilder(
        builder: (context, c) {
          const dash = 6.0;
          const gap = 5.0;
          final n = (c.maxWidth / (dash + gap)).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              n,
              (_) => Container(
                width: dash,
                height: 1.4,
                color: const Color(0xFFD9CABD),
              ),
            ),
          );
        },
      ),
    );
  }
}