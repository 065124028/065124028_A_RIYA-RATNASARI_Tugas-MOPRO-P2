import 'package:flutter/material.dart';

import 'menu_list_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _sudahMasuk = false;

  void _masuk() {
    if (_sudahMasuk) return;
    _sudahMasuk = true;
    Navigator.pushReplacementNamed(context, '/menu');
  }

  @override
  Widget build(BuildContext context) {
    // foto latar diambil dari menu pertama (assets/images/nasi_goreng.jpg)
    final foto = kMenu.first;

    return Scaffold(
      backgroundColor: AppColors.maroonDark,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _masuk,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FoodThumb(item: foto, radius: 0, iconSize: 64),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, .45, 1],
                  colors: [
                    Color(0x66000000),
                    Color(0x33000000),
                    Color(0xE6240A10),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kantin Bu Sari',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .3,
                      ),
                    ),
                    const Spacer(),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      builder: (context, v, child) => Opacity(
                        opacity: v,
                        child: Transform.translate(
                          offset: Offset(0, 24 * (1 - v)),
                          child: child,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pesan makan siang\ntanpa antre.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              height: 1.15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Pilih menu dari dapur Bu Sari, lalu tinggal ambil di kasir atau minta diantar ke meja.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .8),
                              fontSize: 14.5,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 28),
                          FilledButton(
                            onPressed: _masuk,
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.maroon,
                              minimumSize: const Size.fromHeight(56),
                            ),
                            child: const Text('Mulai Pesan'),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              'Ketuk di mana saja untuk masuk',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: .65),
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}