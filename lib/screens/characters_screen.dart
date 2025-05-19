import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/api_service.dart'; // Asegúrate de que este servicio exista
import '../widgets/character_card.dart'; // Asegúrate de que este widget exista
import '../widgets/search_bar.dart'; // Asegúrate de que este widget exista

// Considera si esta URL es correcta para Image.network o si debería ser 'assets/...'
// Si es un asset local, cambia Image.network por Image.asset
const String logoUrl = 'assets/logo_dragonballapi.webp';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  // Future que contendrá la lista de personajes obtenida de la API
  late Future<List<Personaje>> _personajes;
  // Variable para almacenar la consulta de búsqueda
  String _query = '';

  @override
  void initState() {
    super.initState();
    // Inicializa el Future para obtener todos los personajes al iniciar la pantalla
    _personajes = ApiService().fetchAllCharacters();
  }

  @override
  void dispose() {
    // Asegúrate de cancelar cualquier Future o Stream si los tuvieras aquí
    // para evitar posibles fugas de memoria. En este caso, FutureBuilder maneja el Future.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300], // Color de fondo de la AppBar
        elevation: 0, // Sin sombra en la AppBar
        title: Row( // Fila para organizar el título y el logo
          children: [
            const Text('Personajes', style: TextStyle(color: Colors.black)), // Título de la pantalla
            const Spacer(), // Widget que ocupa todo el espacio disponible entre el título y el logo
            // Muestra el logo. Usamos Image.asset si es un archivo local.
            // Si logoUrl es una URL de red, Image.network es correcto, pero el errorBuilder
            // es una buena práctica para manejar fallos de carga.
            Image.asset( // Cambiado a Image.asset asumiendo que es un asset local
              logoUrl,
              height: 40, // Altura del logo
              fit: BoxFit.contain, // Ajusta el logo para que quepa sin distorsionarse
              // errorBuilder: (context, error, stackTrace) => // errorBuilder no es necesario para assets locales
              //     const Icon(Icons.error, color: Colors.red),
            ),
          ],
        ),
        // Agregar un botón de retroceso si esta pantalla se navega desde otra
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Regresa a la pantalla anterior
          },
        ),
      ),
      body: SafeArea( // Asegura que el contenido no se solape con barras del sistema
        child: FutureBuilder<List<Personaje>>( // Construye la UI basado en el estado del Future _personajes
          future: _personajes,
          builder: (context, snapshot) {
            // Muestra un indicador de carga mientras se obtienen los datos
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // Muestra un mensaje de error si el Future falla
            else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            // Muestra un mensaje si no hay datos o la lista está vacía
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No hay personajes disponibles.'),
              );
            }

            // Si los datos se cargaron correctamente
            final personajes = snapshot.data!;
            // Filtra los personajes basándose en la consulta de búsqueda
            final filtrados = _query.isEmpty
                ? personajes
                : personajes.where((p) => p.name.toLowerCase().contains(_query)).toList();

            // Construye la interfaz principal con la barra de búsqueda y la lista/mensaje
            return Column(
              children: [
                // Barra de búsqueda
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: SearchBarWidget( // Widget de barra de búsqueda
                    hintText: 'Buscar personaje', // Texto de sugerencia
                    onChanged: (query) => setState(() => _query = query.toLowerCase()), // Actualiza la consulta y reconstruye el widget
                  ),
                ),
                // Lista de personajes filtrados o mensaje de "no encontrado"
                Expanded( // Permite que el GridView o el mensaje ocupen el espacio restante
                  child: filtrados.isEmpty
                      ? Center( // Muestra el mensaje y GIF si no hay resultados
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // GIF de Freezer (asegúrate de que la ruta sea correcta)
                              Image.asset(
                                'assets/images/freezer.gif',
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 8), // Espacio entre el GIF y el texto
                              // Mensaje de "no encontrado"
                              Text(
                                'No se encontró ningún personaje con el nombre "$_query"\nFreezer destruyó todo sobre este personaje.',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : GridView.builder( // Muestra la cuadrícula de personajes
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // <--- CAMBIADO AQUÍ: 4 columnas
                            childAspectRatio: 0.68, // Relación de aspecto de cada elemento de la cuadrícula
                            crossAxisSpacing: 12, // Espacio horizontal entre columnas
                            mainAxisSpacing: 12, // Espacio vertical entre filas
                          ),
                          padding: const EdgeInsets.all(12), // Padding alrededor de la cuadrícula
                          itemCount: filtrados.length, // Número de elementos en la cuadrícula
                          itemBuilder: (context, index) {
                            // Construye cada tarjeta de personaje
                            return CharacterCard(personaje: filtrados[index]); // Asegúrate de que CharacterCard reciba un objeto Personaje
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
