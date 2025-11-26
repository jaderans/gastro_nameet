import 'package:flutter/material.dart';
import 'package:gastro_nameet/pages/login-signUp/loginstart.dart';
import 'package:gastro_nameet/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _loading = true);
    try {
      final user = await AuthService.instance.getCurrentUser();
      setState(() {
        _user = user;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _user = null;
        _loading = false;
      });
    }
  }

  Future<void> _signOut() async {
    await AuthService.instance.clearCurrentUser();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const loginstart()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFA726),
        title: Row(children: const [
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: Icon(Icons.account_circle, color: Colors.white),
          ),
          Text(
            'Profile',
            style: TextStyle(
              fontFamily: 'Talina',
              color: Colors.white,
            ),
          ),
        ]),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: _user == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No user is currently signed in.'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const loginstart()),
                              (route) => false,
                            );
                          },
                          child: const Text('Sign In'),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 48,
                            child: Text(
                              (_user!['USER_NAME'] as String? ?? 'U')
                                  .split(' ')
                                  .map((s) => s.isNotEmpty ? s[0] : '')
                                  .take(2)
                                  .join()
                                  .toUpperCase(),
                              style: const TextStyle(fontSize: 28, color: Colors.white),
                            ),
                            backgroundColor: const Color(0xFFF7941D),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Name', style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(height: 4),
                        Text(_user!['USER_NAME'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text('Email', style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(height: 4),
                        Text(_user!['USER_EMAIL'] ?? '', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 12),
                        Text('User ID', style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(height: 4),
                        Text('${_user!['USER_ID']}', style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _signOut,
                          child: const Text('Sign Out'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 247, 29, 29),
                            minimumSize: const Size.fromHeight(50),
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}
