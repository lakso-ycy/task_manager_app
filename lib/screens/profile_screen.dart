import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _username; // Menyimpan nama pengguna
  late String _email; // Menyimpan email pengguna
  late String _password; // Menyimpan password pengguna
  bool _notificationsEnabled = true; // Status notifikasi
  String _selectedAvatar = 'assets/Avatar/gamer.png'; // Avatar default

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _username = authProvider.currentUsername ?? "Ganti Namamu";
    _email = authProvider.currentEmail ?? "example@email.com";
    _password = "********"; // Password disembunyikan
  }

  // Fungsi untuk menampilkan dialog edit nama
  void _showEditNameDialog() {
    final nameController = TextEditingController(text: _username);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Name", style: TextStyle(fontFamily: 'Poppins')),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Enter your name",
              labelStyle: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _username = nameController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save", style: TextStyle(fontFamily: 'Poppins')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(fontFamily: 'Poppins')),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog edit email
  void _showEditEmailDialog() {
    final emailController = TextEditingController(text: _email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Email", style: TextStyle(fontFamily: 'Poppins')),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: "Enter your email",
              labelStyle: TextStyle(fontFamily: 'Poppins'),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _email = emailController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save", style: TextStyle(fontFamily: 'Poppins')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(fontFamily: 'Poppins')),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk memilih avatar
  void _showAvatarSelectionDialog() {
    final List<String> avatars = [
      'assets/Avatar/gamer.png',
      'assets/Avatar/girl.png',
      'assets/Avatar/man.png',
      'assets/Avatar/woman.png',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Avatar", style: TextStyle(fontFamily: 'Poppins')),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              shrinkWrap: true,
              itemCount: avatars.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatar = avatars[index];
                    });
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(avatars[index]),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(fontFamily: 'Poppins')),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog perubahan password
  void _showChangePasswordDialog() {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Change Password", style: TextStyle(fontFamily: 'Poppins')),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Enter new password",
              labelStyle: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _showConfirmationDialog(() {
                  Provider.of<AuthProvider>(context, listen: false)
                      .updateProfile(newPassword: passwordController.text);
                  setState(() {
                    _password = passwordController.text;
                  });
                  Navigator.of(context).pop();  // Close password change dialog
                });
              },
              child: const Text("Save", style: TextStyle(fontFamily: 'Poppins')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(fontFamily: 'Poppins')),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan konfirmasi perubahan password
  void _showConfirmationDialog(VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Password Change", style: TextStyle(fontFamily: 'Poppins')),
          content: const Text("Are you sure you want to change your password?"),
          actions: [
            TextButton(
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
              child: const Text("Yes", style: TextStyle(fontFamily: 'Poppins')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No", style: TextStyle(fontFamily: 'Poppins')),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus akun
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Account", style: TextStyle(fontFamily: 'Poppins')),
          content: const Text("Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text("Delete", style: TextStyle(fontFamily: 'Poppins')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(fontFamily: 'Poppins')),
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
        title: const Text(
          "Profile",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 192, 236, 44),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _showAvatarSelectionDialog,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(_selectedAvatar),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildProfileField("Name", _username, _showEditNameDialog),
            const Divider(),
            _buildProfileField("Email", _email, _showEditEmailDialog),
            const Divider(),
            _buildProfileField("Password", _password, _showChangePasswordDialog),
            const Divider(),
            SwitchListTile(
              title: const Text("Enable Notifications", style: TextStyle(fontFamily: 'Poppins')),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            const Divider(),
            ListTile(
              title: const Text("Privacy Policy", style: TextStyle(fontFamily: 'Poppins')),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Privacy Policy", style: TextStyle(fontFamily: 'Poppins')),
                      content: const Text("This is the privacy policy of the app.",
                          style: TextStyle(fontFamily: 'Poppins')),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Close", style: TextStyle(fontFamily: 'Poppins')),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showDeleteAccountDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: const Text(
                  "Delete Account",
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
                ),
              ),
            ),
            const Divider(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: const Text(
                  "Log Out",
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan field profil
  Widget _buildProfileField(
      String title, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontFamily: 'Poppins')),
      subtitle: Text(value, style: const TextStyle(fontFamily: 'Poppins')),
      trailing: const Icon(Icons.edit),
      onTap: onTap,
    );
  }
}
