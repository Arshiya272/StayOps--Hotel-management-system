import 'dart:convert';
import 'dart:html' as html;

import 'guest_account.dart';

class GuestAccountStore {
  GuestAccountStore._() {
    _loadAccounts();
  }

  static final GuestAccountStore instance = GuestAccountStore._();

  static const String _storageKey = 'stayops_guest_accounts';

  final List<GuestAccount> _accounts = [];

  List<GuestAccount> get accounts => List.unmodifiable(_accounts);

  // -----------------------------
  // LOAD SAVED ACCOUNTS
  // -----------------------------

  void _loadAccounts() {
    try {
      final savedData = html.window.localStorage[_storageKey];

      if (savedData == null || savedData.isEmpty) {
        return;
      }

      final List<dynamic> decoded = jsonDecode(savedData);

      _accounts.clear();

      for (final item in decoded) {
        _accounts.add(
          GuestAccount(
            guestId: item['guestId'],
            fullName: item['fullName'],
            email: item['email'],
            password: item['password'],
          ),
        );
      }
    } catch (e) {
      _accounts.clear();
    }
  }

  // -----------------------------
  // SAVE ACCOUNTS
  // -----------------------------

  void _saveAccounts() {
    final data = _accounts.map((account) {
      return {
        'guestId': account.guestId,
        'fullName': account.fullName,
        'email': account.email,
        'password': account.password,
      };
    }).toList();

    html.window.localStorage[_storageKey] = jsonEncode(data);
  }

  // -----------------------------
  // ADD NEW GUEST
  // -----------------------------

  void addGuest({
    required String fullName,
    required String email,
    required String password,
  }) {
    final guestId = 'GST-${DateTime.now().millisecondsSinceEpoch}';

    final account = GuestAccount(
      guestId: guestId,
      fullName: fullName,
      email: email.toLowerCase().trim(),
      password: password,
    );

    _accounts.insert(0, account);

    _saveAccounts();
  }

  // -----------------------------
  // CHECK EMAIL EXISTS
  // -----------------------------

  bool emailExists(String email) {
    final normalizedEmail = email.toLowerCase().trim();

    return _accounts.any(
      (account) => account.email.toLowerCase() == normalizedEmail,
    );
  }

  // -----------------------------
  // FIND GUEST BY EMAIL
  // -----------------------------

  GuestAccount? findByEmail(String email) {
    final normalizedEmail = email.toLowerCase().trim();

    for (final account in _accounts) {
      if (account.email.toLowerCase() == normalizedEmail) {
        return account;
      }
    }

    return null;
  }

  // -----------------------------
  // VALIDATE LOGIN
  // -----------------------------

  GuestAccount? validateCredentials({
    required String email,
    required String password,
  }) {
    final account = findByEmail(email);

    if (account == null) {
      return null;
    }

    if (account.password != password) {
      return null;
    }

    return account;
  }

  // -----------------------------
  // CLEAR ALL ACCOUNTS
  // -----------------------------

  void clearAccounts() {
    _accounts.clear();

    html.window.localStorage.remove(_storageKey);
  }
}
