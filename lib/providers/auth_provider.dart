import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final Map<String, Map<String, String>> _users = {}; // Data pengguna (username, email, password)
  String? _currentUsername; // Simpan username pengguna yang sedang login
  String? _currentEmail;
  String? _currentAvatar; // Menyimpan avatar pengguna

  // Fungsi untuk mendapatkan username, email, dan avatar pengguna yang sedang login
  String? get currentUsername => _currentUsername;
  String? get currentEmail => _currentEmail;
  String? get currentAvatar => _currentAvatar;

  // Getter untuk mendapatkan data lengkap pengguna yang login
  Map<String, String>? get currentUserData {
    if (_currentEmail != null && _users.containsKey(_currentEmail)) {
      return _users[_currentEmail];
    }
    return null;
  }

  // Fungsi login
  String? login(String email, String password) {
    if (_users.containsKey(email)) {
      if (_users[email]!['password'] == password) {
        _currentUsername = _users[email]!['username'];
        _currentEmail = email;
        _currentAvatar = _users[email]!['avatar']; // Ambil avatar dari data pengguna
        notifyListeners();
        return null; // Login berhasil
      } else {
        return "Password salah.";
      }
    } else {
      return "Email tidak ditemukan. Silakan registrasi terlebih dahulu.";
    }
  }

  // Fungsi registrasi
  String? register(String username, String email, String password, String confirmPassword) {
    if (_users.containsKey(email)) {
      return "Email sudah digunakan.";
    }
    if (password != confirmPassword) {
      return "Password dan verifikasi password tidak cocok.";
    }

    // Simpan data pengguna, dengan avatar default
    _users[email] = {'username': username, 'password': password, 'avatar': 'assets/Avatar/gamer.png'};
    notifyListeners();
    return null; // Registrasi berhasil
  }

  // Fungsi untuk memperbarui profil pengguna
  void updateProfile({String? newName, String? newEmail, String? newPassword, String? newAvatar}) {
    if (_currentEmail != null && _users.containsKey(_currentEmail)) {
      // Update username jika ada perubahan
      if (newName != null) {
        _users[_currentEmail]!['username'] = newName;
        _currentUsername = newName;
      }
      // Update email jika ada perubahan
      if (newEmail != null && newEmail != _currentEmail) {
        _users[newEmail] = _users[_currentEmail]!; // Salin data pengguna ke email baru
        _users.remove(_currentEmail); // Hapus data pengguna dengan email lama
        _currentEmail = newEmail;
      }
      // Update password jika ada perubahan
      if (newPassword != null) {
        _users[_currentEmail]!['password'] = newPassword;
      }
      // Update avatar jika ada perubahan
      if (newAvatar != null) {
        _users[_currentEmail]!['avatar'] = newAvatar;
        _currentAvatar = newAvatar; // Menyimpan avatar baru
      }
      notifyListeners();
    }
  }

  // Fungsi reset password
  Future<String?> resetPassword(String email) async {
    try {
      // Logika untuk mengirim email reset password (ganti sesuai backend Anda)
      await Future.delayed(const Duration(seconds: 2)); // Simulasi proses
      return null; // Null berarti tidak ada error
    } catch (e) {
      return 'Failed to send reset password email. Please try again.';
    }
  }

  // Fungsi untuk menghapus akun pengguna
  void deleteAccount() {
    if (_currentEmail != null && _users.containsKey(_currentEmail)) {
      _users.remove(_currentEmail); // Hapus data pengguna dari database lokal
      _currentUsername = null;
      _currentEmail = null;
      _currentAvatar = null;
      notifyListeners();
    }
  }

  // Fungsi logout
  void logout() {
    _currentUsername = null;
    _currentEmail = null;
    _currentAvatar = null;
    notifyListeners();
  }
}
