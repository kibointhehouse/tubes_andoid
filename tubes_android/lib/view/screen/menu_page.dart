import 'package:flutter/material.dart';
import 'package:tubes_android/model/menu_model.dart';
import 'package:tubes_android/services/api_services.dart';
import 'package:tubes_android/services/auth_manager.dart';
import 'package:tubes_android/view/screen/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_android/view/widget/menu_card.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _priceCtl = TextEditingController();
  final _descCtl = TextEditingController();
  final _stockCtl = TextEditingController();
  String? _selectedCategory;
  // File? _image;

  String _result = '-';
  final ApiServices _dataService = ApiServices();
  List<MenuModel> _menuMdl = [];
  MenuResponse? ctRes;
  bool isEdit = false;
  String idMenu = '';

  late SharedPreferences loginData;
  String username = '';
  String token = '';
  String role = '';

  // List<Map<String, dynamic>> _menuList = [];

  @override
  void initState() {
    super.initState();
    refreshMenuList();
    initialize();
  }

  void initialize() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      username = loginData.getString('username') ?? '';
      token = loginData.getString('token') ?? '';
      role = loginData.getString('role') ?? '';
    });
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _priceCtl.dispose();
    _descCtl.dispose();
    _stockCtl.dispose();
    _selectedCategory = null;
    // _image = null;
    super.dispose();
  }

  // Validasi nama menu
  String? _validateMenuName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama menu wajib diisi';
    }
    if (!RegExp(r'^[A-Z][a-zA-Z ]+$').hasMatch(value)) {
      return 'Nama menu harus diawali huruf kapital dan hanya mengandung huruf';
    }
    return null;
  }

// Validasi harga
  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Harga wajib diisi';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Harga hanya boleh berisi angka';
    }
    return null;
  }

// Validasi deskripsi
  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Deskripsi wajib diisi';
    }
    if (!RegExp(r'^[a-zA-Z0-9.,!? ]+$').hasMatch(value)) {
      return 'Deskripsi hanya boleh mengandung huruf, angka, dan tanda baca';
    }
    return null;
  }

// Validasi stok
  String? _validateStock(String? value) {
    if (value == null || value.isEmpty) {
      return 'Stok wajib diisi';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Stok hanya boleh berisi angka';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Menu'),
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // Bungkus dengan Form widget
          key: _formKey,
          child: Column(
            children: [
              _buildUserInfoCard(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameCtl,
                validator: _validateMenuName,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Menu Name',
                  suffixIcon: IconButton(
                    onPressed: _nameCtl.clear,
                    icon: const Icon(Icons.fastfood),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceCtl,
                validator: _validatePrice,
                keyboardType: TextInputType.number, // Supaya keyboard angka
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Price',
                  suffixIcon: IconButton(
                    onPressed: _priceCtl.clear,
                    icon: const Icon(Icons.attach_money),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtl,
                validator: _validateDescription,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Description',
                  suffixIcon: IconButton(
                    onPressed: _descCtl.clear,
                    icon: const Icon(Icons.description),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockCtl,
                validator: _validateStock,
                keyboardType: TextInputType.number, // Supaya keyboard angka
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Stock',
                  suffixIcon: IconButton(
                    onPressed: _stockCtl.clear,
                    icon: const Icon(Icons.storage),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Category',
                ),
                items: ['Makanan', 'Minuman']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final isValidForm = _formKey.currentState!
                              .validate(); // Panggil validasi
                          if (!isValidForm) {
                            displaySnackbar('Isi form dengan benar');
                            return;
                          }
                          if (_nameCtl.text.isEmpty ||
                                  _priceCtl.text.isEmpty ||
                                  _descCtl.text.isEmpty ||
                                  _stockCtl.text.isEmpty ||
                                  _selectedCategory == null
                              // _image == null
                              ) {
                            displaySnackbar('Semua field harus diisi');
                            return;
                          }
                          final postModel = MenuInput(
                            menuName: _nameCtl.text,
                            price: _priceCtl.text,
                            description: _descCtl.text,
                            stock: _stockCtl.text,
                            menuCategories: _selectedCategory!,
                            // image: _image!.path,
                          );
                          MenuResponse? res;
                          if (isEdit) {
                            res = await _dataService.putMenu(idMenu, postModel);
                          } else {
                            res = await _dataService.postMenu(postModel);
                          }
                          setState(() {
                            ctRes = res;
                            isEdit = false;
                          });
                          _formKey.currentState!.reset(); // Reset form
                          _nameCtl.clear();
                          _priceCtl.clear();
                          _descCtl.clear();
                          _stockCtl.clear();
                          _selectedCategory = null;
                          // _image = null;
                          await refreshMenuList();
                        },
                        child: Text(isEdit ? 'UPDATE' : 'POST'),
                      ),
                      if (isEdit)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            _formKey.currentState!.reset(); // Reset form
                            _nameCtl.clear();
                            _priceCtl.clear();
                            _descCtl.clear();
                            _stockCtl.clear();
                            _selectedCategory = null;
                            // _image = null;
                            setState(() {
                              isEdit = false;
                            });
                          },
                          child: const Text('Cancel Update'),
                        ),
                    ],
                  )
                ],
              ),
              hasilCard(context),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await refreshMenuList();
                        setState(() {});
                      },
                      child: const Text('Refresh Data'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _result = '-';
                        _menuMdl.clear();
                        ctRes = null;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Text(
                'List Menu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 8.0),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

// untuk menampilkan list menu
  Widget _buildListMenu() {
    print("Jumlah data dalam _menuMdl: ${_menuMdl.length}"); // Debugging output
    if (_menuMdl.isEmpty) {
      return const Center(
        child: Text("Tidak ada menu tersedia"),
      );
    }
    return ListView.separated(
      itemBuilder: (context, index) {
        final ctList = _menuMdl[index];
        return Card(
          child: ListTile(
            title: Text(ctList.menuName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rp ${ctList.price.toStringAsFixed(2)}", // ✅ Perbaikan: Format harga dengan 2 desimal
                  style: const TextStyle(color: Colors.green),
                ),
                Text(
                  ctList.menuCategories,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                Text(
                  "Stock: ${ctList.stock}", // ✅ Perbaikan: Pastikan stock ditampilkan sebagai string
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    final menu = await _dataService.getMenuById(ctList.id);

                    // ✅ Perbaikan: Pastikan menu tidak null dan bertipe MenuModel
                    if (menu != null && menu is MenuModel) {
                      setState(() {
                        _nameCtl.text = menu.menuName;
                        _priceCtl.text = menu.price
                            .toString(); // ✅ Perbaikan: Konversi price ke String
                        _descCtl.text = menu.description;
                        _stockCtl.text = menu.stock
                            .toString(); // ✅ Perbaikan: Konversi stock ke String
                        _selectedCategory = menu.menuCategories;
                        isEdit = true;
                        idMenu = menu.id;
                      });
                    }
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(ctList.id, ctList.menuName);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      itemCount: _menuMdl.length,
    );
  }

  Widget _buildUserInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.person, size: 50, color: Colors.deepPurple),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Username: $username",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Role: $role",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Token: ${token.isNotEmpty ? token.substring(0, 10) + '...' : '-'}",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> refreshMenuList() async {
    print("🔄 Memuat ulang menu...");

    final users = await _dataService.getAllMenus();

    print("📩 Data dari API: $users"); // Cek apakah API mengembalikan data

    setState(() {
      _menuMdl.clear(); // Bersihkan list sebelum menambah data baru
      if (users != null && users.isNotEmpty) {
        _menuMdl.addAll(users);
        print(
            "✅ Data berhasil dimasukkan ke _menuMdl, total: ${_menuMdl.length}");
      } else {
        print("❌ Tidak ada data menu yang masuk ke _menuMdl!");
      }
    });
  }

  // method untuk post data
  Widget hasilCard(BuildContext context) {
    return Column(children: [
      if (ctRes != null)
        MenuCard(
          ctRes: ctRes!,
          onDismissed: () {
            setState(() {
              ctRes = null;
            });
          },
        )
      else
        const Text(''),
    ]);
  }

  void _showDeleteConfirmationDialog(String id, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data $name ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                MenuResponse? res = await _dataService.deleteMenu(id);
                setState(() {
                  ctRes = res;
                });
                Navigator.of(context).pop();
                await refreshMenuList();
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                await AuthManager.logout();
                Navigator.pushAndRemoveUntil(
                  dialogContext,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }
}
