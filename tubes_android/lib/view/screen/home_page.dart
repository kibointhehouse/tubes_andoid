import 'package:flutter/material.dart';
import 'package:tubes_android/services/auth_manager.dart';
import 'package:tubes_android/view/screen/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _priceCtl = TextEditingController();
  final _descCtl = TextEditingController();
  final _stockCtl = TextEditingController();
  String? _selectedCategory;
  late SharedPreferences loginData;
  String username = '';
  String token = '';

  // List untuk menampung menu yang telah ditambahkan
  final List<Map<String, dynamic>> _menuList = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      username = loginData.getString('username') ?? '';
      token = loginData.getString('token') ?? '';
    });
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _priceCtl.dispose();
    _descCtl.dispose();
    _stockCtl.dispose();
    super.dispose();
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
        child: Column(
          children: [
            _buildUserInfoCard(),
            const SizedBox(height: 16),
            _buildAddMenuForm(),
            const SizedBox(height: 16),
            _buildMenuList(), // Menampilkan daftar menu yang telah ditambahkan
          ],
        ),
      ),
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

  Widget _buildAddMenuForm() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Menu',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField('Menu Name', _nameCtl, Icons.fastfood),
              const SizedBox(height: 12),
              _buildTextField('Price', _priceCtl, Icons.attach_money,
                  isNumeric: true),
              const SizedBox(height: 12),
              _buildTextField('Description', _descCtl, Icons.description,
                  maxLines: 3),
              const SizedBox(height: 12),
              _buildTextField('Stock', _stockCtl, Icons.storage,
                  isNumeric: true),
              const SizedBox(height: 12),
              _buildCategoryDropdown(),
              const SizedBox(height: 16),
              _buildImageUploader(),
              const SizedBox(height: 16),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool isNumeric = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Category',
        prefixIcon: const Icon(Icons.category, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      value: _selectedCategory,
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
    );
  }

  Widget _buildImageUploader() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image, size: 50, color: Colors.deepPurple),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: const Text('Upload Image', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _addNewMenu,
        child: const Text('Submit',
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  // LOGOUT
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

// ADD MENU
  void _addNewMenu() {
    setState(() {
      _menuList.add({
        "name": _nameCtl.text,
        "price": _priceCtl.text,
        "description": _descCtl.text,
        "stock": _stockCtl.text,
        "category": _selectedCategory ?? 'Unknown',
      });

      _nameCtl.clear();
      _priceCtl.clear();
      _descCtl.clear();
      _stockCtl.clear();
      _selectedCategory = null;
    });
  }

// Menampilkan daftar menu yang telah ditambahkan
  Widget _buildMenuList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Added Menus",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _menuList.isEmpty
            ? const Text("No menu added yet",
                style: TextStyle(fontSize: 16, color: Colors.grey))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _menuList.length,
                itemBuilder: (context, index) {
                  final menu = _menuList[index];
                  return ListTile(
                    title: Text(menu["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Price: Rp ${menu["price"]}"),
                  );
                },
              ),
      ],
    );
  }
}
