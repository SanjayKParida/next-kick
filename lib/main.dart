import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_kick/core/theme/theme.dart';
import 'package:next_kick/view/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:next_kick/view/authentication/login_screen.dart';
import 'provider/user_provider.dart';

// Initialize app-level services
Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
}

void main() async {
  await initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _checkTokenAndSetUser();
    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _checkTokenAndSetUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? userJson = prefs.getString('user');

      if (token != null && userJson != null) {
        ref.read(userProvider.notifier).setUser(userJson);
      } else {
        ref.read(userProvider.notifier).signOut();
      }
    } catch (e) {
      debugPrint('Error initializing app: $e');
      ref.read(userProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Market Sphere',
      theme: buildTheme(),
      home: !_isInitialized
          ? const _LoadingScreen()
          : Consumer(
              builder: (context, ref, _) {
                final user = ref.watch(userProvider);
                return user != null ? const HomeScreen() : const LoginScreen();
              },
            ),
      onGenerateRoute: (settings) {
        // Add your route generation logic here
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(
              builder: (_) => const LoginScreen(),
              settings: settings,
            );
          case '/home':
            return MaterialPageRoute(
              builder: (_) => const HomeScreen(),
              settings: settings,
            );
          // Add other routes as needed
          default:
            return MaterialPageRoute(
              builder: (_) => const LoginScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
