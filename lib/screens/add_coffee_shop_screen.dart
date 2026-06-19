import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/recommendation/providers/recommendation_provider.dart';
import '../models/coffee_shop.dart';
import '../theme/app_theme.dart';
import 'package:uuid/uuid.dart';

class AddCoffeeShopScreen extends ConsumerStatefulWidget {
  const AddCoffeeShopScreen({super.key});

  @override
  ConsumerState<AddCoffeeShopScreen> createState() => _AddCoffeeShopScreenState();
}

class _AddCoffeeShopScreenState extends ConsumerState<AddCoffeeShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _imageController = TextEditingController();
  
  final List<String> _selectedVibes = [];
  final List<MenuItem> _menuItems = [MenuItem(name: '', price: 0)];
  
  final List<String> _availableVibes = ['nongki', 'ngechill', 'nugas'];

  void _addMenuItem() {
    setState(() {
      _menuItems.add(MenuItem(name: '', price: 0));
    });
  }

  void _removeMenuItem(int index) {
    if (_menuItems.length > 1) {
      setState(() {
        _menuItems.removeAt(index);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedVibes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal satu vibe ya!')),
      );
      return;
    }

    // Filter out empty menu items
    final validMenu = _menuItems.where((item) => item.name.isNotEmpty && item.price > 0).toList();
    if (validMenu.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tambahkan minimal satu menu yang valid!')),
      );
      return;
    }

    final shop = CoffeeShop(
      id: const Uuid().v4(),
      name: _nameController.text,
      address: _addressController.text,
      imageUrl: _imageController.text.isEmpty 
          ? 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=500&auto=format&fit=crop&q=60' 
          : _imageController.text,
      rating: 4.5, // Default rating for new shops
      vibes: _selectedVibes,
      menu: validMenu,
    );

    await ref.read(recommendationProvider.notifier).addCoffeeShop(shop);
    
    if (mounted) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coffee Shop berhasil ditambahkan!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Coffee Shop'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Informasi Dasar'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Coffee Shop',
                  hintText: 'Misal: Kopi Nako',
                  prefixIcon: Icon(Icons.storefront_rounded),
                ),
                validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat / Lokasi',
                  hintText: 'Misal: Jl. Pajajaran No. 1',
                  prefixIcon: Icon(Icons.location_on_rounded),
                ),
                validator: (v) => v!.isEmpty ? 'Alamat tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar (Opsional)',
                  hintText: 'https://...',
                  prefixIcon: Icon(Icons.image_rounded),
                ),
              ),
              
              const SizedBox(height: 32),
              _buildSectionTitle('Pilih Vibe / Suasana'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: _availableVibes.map((vibe) {
                  final isSelected = _selectedVibes.contains(vibe);
                  return FilterChip(
                    label: Text(vibe[0].toUpperCase() + vibe.substring(1)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedVibes.add(vibe);
                        } else {
                          _selectedVibes.remove(vibe);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('Daftar Menu'),
                  TextButton.icon(
                    onPressed: _addMenuItem,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Tambah Menu'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _menuItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nama Menu',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                          onChanged: (v) => _menuItems[index] = MenuItem(
                            name: v, 
                            price: _menuItems[index].price
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Harga',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            prefixText: 'Rp ',
                          ),
                          onChanged: (v) => _menuItems[index] = MenuItem(
                            name: _menuItems[index].name, 
                            price: int.tryParse(v) ?? 0
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.danger),
                        onPressed: () => _removeMenuItem(index),
                      ),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Simpan Coffee Shop',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }
}
