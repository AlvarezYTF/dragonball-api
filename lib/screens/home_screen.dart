import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dragon Ball API')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Personajes'),
            // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CharactersScreen())),
          ),
          ListTile(
            title: Text('Planetas'),
            // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlanetsScreen())),
          ),
        ],
      ),
    );
  }
}