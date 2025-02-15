import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tubes_android/services/auth_manager.dart';
import 'package:tubes_android/view/screen/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

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
  File? _image;
  late SharedPreferences loginData;
  String username = '';
  String token = '';
  String role = '';

  List<Map<String, dynamic>> _menuList = [];

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
      role = loginData.getString('role') ?? '';
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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Future<void> _pickImage() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.image, // Hanya memperbolehkan file gambar
  //   );

  //   if (result != null) {
  //     setState(() {
  //       _image = File(result.files.single.path!);
  //     });
  //   }
  // }

  Future<void> _loadMenuList() async {
    final prefs = await SharedPreferences.getInstance();
    final menuJson = prefs.getStringList('menu_list') ?? [];
    setState(() {
      _menuList = menuJson
          .map((menu) => jsonDecode(menu))
          .cast<Map<String, dynamic>>()
          .toList();
    });
  }

  Future<void> _saveMenuList() async {
    final prefs = await SharedPreferences.getInstance();
    final menuJson = _menuList.map((menu) => jsonEncode(menu)).toList();
    await prefs.setStringList('menu_list', menuJson);
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
            _buildMenuList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _menuList.length,
      itemBuilder: (context, index) {
        final menu = _menuList[index];
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: ListTile(
            leading: menu['image'] != null && menu['image'].isNotEmpty
                ? Image.file(File(menu['image']),
                    width: 50, height: 50, fit: BoxFit.cover)
                : const Icon(Icons.image, size: 50, color: Colors.grey),
            title: Text(menu['name']),
            subtitle: Text('Price: ${menu['price']}\nStock: ${menu['stock']}'),
            trailing: Text(menu['category'] ?? 'No Category'),
          ),
        );
      },
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

  Widget _buildAddMenuForm() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add New Menu',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 16),
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
      validator: (value) {
        if (value == null || value.isEmpty) return '$label tidak boleh kosong';
        if (isNumeric && double.tryParse(value) == null) {
          return '$label harus berupa angka';
        }
        if (isNumeric && double.parse(value) <= 0) {
          return '$label harus lebih dari 0';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Category',
        prefixIcon: const Icon(Icons.category, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      value:
          _selectedCategory, // Tidak perlu cek isNotEmpty karena null sudah bisa diterima
      hint: const Text('Select Category'), // Tambahkan hint
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
      validator: (value) => value == null
          ? 'Please select a category'
          : null, // Validasi kategori
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
      child: _image == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.image, size: 50, color: Colors.deepPurple),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _pickImage,
                    child: const Text('Upload Image',
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_image!,
                  fit: BoxFit.cover, width: double.infinity, height: 150),
            ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(vertical: 16)),
        onPressed: _addNewMenu,
        child: const Text('Submit',
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _image != null
            ? Image.file(_image!,
                width: double.infinity, height: 200, fit: BoxFit.cover)
            : const Text('No image selected',
                style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Choose Image'),
        ),
      ],
    );
  }

  void _addNewMenu() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _menuList.add({
          "menu_name": _nameCtl.text,
          "price": _priceCtl.text,
          "description": _descCtl.text,
          "stock": _stockCtl.text,
          "menu_categories": _selectedCategory ?? 'Unknown',
          "image": _image?.path ?? '',
        });
        _saveMenuList();
      });
    }
  }
}
