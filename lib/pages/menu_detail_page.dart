import 'package:flutter/material.dart';

class MenuDetailPage extends StatelessWidget {
  const MenuDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kantin Bu Sari - Detail Menu'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Detail Menu Pilihan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Harga, deskripsi, dan gambar menu.'),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/pesan');
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Pesan Sekarang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
