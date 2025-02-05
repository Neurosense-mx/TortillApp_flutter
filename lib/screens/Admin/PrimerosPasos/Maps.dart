import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tortillapp/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialLocation; // Ubicación inicial

  MapScreen({required this.initialLocation}); // Constructor con la ubicación inicial

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLocation; // Variable para la ubicación seleccionada

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation; // Iniciar con la ubicación actual
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  void _confirmSelection() {
    if (_selectedLocation != null) {
      Navigator.pop(context, _selectedLocation); // Devuelve la ubicación seleccionada
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecciona una ubicación en el mapa')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Selecciona una ubicación")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation!, // Usa la ubicación actual como punto de inicio
              zoom: 15,
            ),
            onTap: _onMapTapped, // Captura la ubicación al tocar el mapa
            markers: {
              Marker(
                markerId: MarkerId("selected"),
                position: _selectedLocation!,
              ),
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CustomWidgets().ButtonPrimary(
                                text: 'Seleccionar ubicación',
                                onPressed: () {
                                  // Acción del botón
                                  _confirmSelection();
                                },
                              ),
          ),
        ],
      ),
    );
  }
}
