import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/browse_screen.dart';
import 'screens/bookmarks_screen.dart';
import 'screens/outputs_screen.dart';
import 'screens/hf_chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routes: {'/outputs': (_) => const OutputsScreen()},
      title: 'Gradio Spaces',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
        textTheme: Typography.material2021().black,
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          indicatorColor: Colors.black.withValues(alpha: 0.06),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final Map<int, Widget> _screens = {0: const BrowseScreen()};

  Widget _screenFor(int index) => switch (index) {
    0 => const BrowseScreen(),
    1 => const BookmarksScreen(),
    2 => const OutputsScreen(),
    _ => const HFChatScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(4, (index) =>
          _screens[index] ?? const SizedBox.shrink()),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(24),
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: NavigationBar(
                height: 40,
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    if (index == 2 && index != _currentIndex) {
                      _screens[index] = _screenFor(index);
                    } else {
                      _screens.putIfAbsent(index, () => _screenFor(index));
                    }
                    _currentIndex = index;
                  });
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.explore_outlined),
                    selectedIcon: Icon(Icons.explore),
                    label: 'Explorar',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.favorite_border),
                    selectedIcon: Icon(Icons.favorite),
                    label: 'Favoritos',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.outbox_outlined),
                    selectedIcon: Icon(Icons.outbox),
                    label: 'Resultados',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.chat_bubble_outline),
                    selectedIcon: Icon(Icons.chat_bubble),
                    label: 'Conversa',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}