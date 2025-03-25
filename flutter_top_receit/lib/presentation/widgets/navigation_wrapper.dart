import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationWrapper extends StatefulWidget {
  @override
  _NavigationWrapperState createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int _selectedIndex = 0;

  final List<String> _routes = [
    '/home',
    '/allRecipes',
    '/shopping-list', // Nueva ruta añadida
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Usar GoRouter para la navegación
    GoRouter.of(context).go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreenForSelectedIndex(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Recetas Públicas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), // Icono de carrito
            label: 'Lista de Compra',
          ),
        ],
        // Opcional: Personaliza el estilo
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget _buildScreenForSelectedIndex() {
    return const SizedBox.shrink();
  }
}
