import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Molinero/MolineroModelo.dart';
import 'package:tortillapp/screens/Molinero/Inicio/pages/Add_Maiz.dart';
import 'package:tortillapp/screens/Molinero/Inicio/pages/PesarMasa.dart';
import 'package:tortillapp/screens/Molinero/Inicio/widgets/WidgetGrafica.dart';

class HomeMolinero extends StatefulWidget {
  final MostradorModel molino;
  const HomeMolinero({Key? key, required this.molino}) : super(key: key);

  @override
  State<HomeMolinero> createState() => _HomeMolineroState();
}

class _HomeMolineroState extends State<HomeMolinero> {
  final PaletaDeColores colores = PaletaDeColores();
  late Future<String> _nombreFuture;
  late Future<Map<String, Map<String, double>>> _estadisticasFuture;

  late final Widget iconMolinoSvg;
  late final Widget iconAguaSvg;
  late final Widget iconPesoSvg;

  @override
  void initState() {
    super.initState();
    _nombreFuture = _loadNombre();
    _estadisticasFuture = _getEstadisticas();

    iconMolinoSvg = SvgPicture.asset(
      'lib/assets/cards/molinero/molino_icon.svg',
      width: 30,
      height: 30,
      cacheColorFilter: true,
    );

    iconAguaSvg = SvgPicture.asset(
      'lib/assets/cards/molinero/cocer_icon.svg',
      width: 50,
      height: 50,
      cacheColorFilter: true,
    );

    iconPesoSvg = SvgPicture.asset(
      'lib/assets/cards/molinero/pesar_masa_icon.svg',
      width: 50,
      height: 50,
      cacheColorFilter: true,
    );
  }

  Future<String> _loadNombre() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nombre') ?? "Usuario";
  }

  Future<Map<String, Map<String, double>>> _getEstadisticas() async {
    try {
      final rawData = await widget.molino.getEstadisticas();
      return rawData.map((key, value) {
        final innerMap = Map<String, double>.from(
          (value as Map)
              .map((k, v) => MapEntry(k.toString(), (v as num).toDouble())),
        );
        return MapEntry(key.toString(), innerMap);
      });
    } catch (e) {
      debugPrint("Error al obtener estadísticas: $e");
      return {};
    }
  }

  String _getSaludo() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Buenos días";
    if (hour < 18) return "Buenas tardes";
    return "Buenas noches";
  }

  void _refreshEstadisticas() {
    setState(() {
      _estadisticasFuture = _getEstadisticas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<String>(
            future: _nombreFuture,
            builder: (context, snapshotNombre) {
              final nombre = snapshotNombre.data ?? "Usuario";
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SaludoText(
                    nombre: nombre,
                    colorPrincipal: colores.colorPrincipal,
                    saludo: _getSaludo(),
                  ),
                  const SizedBox(height: 16),
                  _SeccionTitulo(
                      texto: 'Puesto actual', color: colores.colorPrincipal),
                  const SizedBox(height: 10),
                  PuestoCard(icono: iconMolinoSvg),
                  const SizedBox(height: 16),
                  _SeccionTitulo(
                      texto: 'Acciones', color: colores.colorPrincipal),
                  const SizedBox(height: 10),
                  AccionesRow(
                    molino: widget.molino,
                    iconAguaSvg: iconAguaSvg,
                    iconPesoSvg: iconPesoSvg,
                  ),
                  const SizedBox(height: 16),
                  _SeccionEstadisticas(
                    colorPrincipal: colores.colorPrincipal,
                    estadisticasFuture: _estadisticasFuture,
                    onRefresh: _refreshEstadisticas,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SaludoText extends StatelessWidget {
  final String nombre;
  final Color colorPrincipal;
  final String saludo;

  const _SaludoText({
    Key? key,
    required this.nombre,
    required this.colorPrincipal,
    required this.saludo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hola, $nombre',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: colorPrincipal),
        ),
        const SizedBox(height: 4),
        Text(saludo,
            style: const TextStyle(fontSize: 15, color: Color(0xFF393939))),
      ],
    );
  }
}

class _SeccionTitulo extends StatelessWidget {
  final String texto;
  final Color color;

  const _SeccionTitulo({Key? key, required this.texto, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(texto, style: TextStyle(fontSize: 16, color: color));
  }
}

class PuestoCard extends StatelessWidget {
  final Widget icono;

  const PuestoCard({Key? key, required this.icono}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PaletaDeColores colores = PaletaDeColores();
    return Card(
      color: Colors.white,
      elevation: 2.4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFFDADADA)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icono,
            const SizedBox(width: 10),
            Text(
              'Molino',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: colores.colorPrincipal),
            ),
          ],
        ),
      ),
    );
  }
}

class AccionesRow extends StatelessWidget {
  final MostradorModel molino;
  final Widget iconAguaSvg;
  final Widget iconPesoSvg;

  const AccionesRow({
    Key? key,
    required this.molino,
    required this.iconAguaSvg,
    required this.iconPesoSvg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PaletaDeColores colores = PaletaDeColores();

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardSize = (constraints.maxWidth / 2) - 12;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _SquareCard(
                icono: iconAguaSvg,
                text: 'Cocer maíz',
                colorHex: '21B0E4',
                size: cardSize,
                destino: Add_maiz_screen(molino: molino),
              ),
              const SizedBox(width: 10),
              _SquareCard(
                icono: iconPesoSvg,
                text: 'Pesar masa',
                colorHex: '5BA951',
                size: cardSize,
                destino: PesarMasa(molino: molino),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SquareCard extends StatelessWidget {
  final Widget icono;
  final String text;
  final String colorHex;
  final double size;
  final Widget destino;

  const _SquareCard({
    Key? key,
    required this.icono,
    required this.text,
    required this.colorHex,
    required this.size,
    required this.destino,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse("0xFF$colorHex"));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => destino,
            transitionsBuilder: (_, animation, __, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                  position: animation.drive(tween), child: child);
            },
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icono,
              const SizedBox(height: 16),
              Text(text,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

// Aquí deberías completar con tu widget _SeccionEstadisticas si no está incluido en otro archivo.
class _SeccionEstadisticas extends StatelessWidget {
  final Color colorPrincipal;
  final Future<Map<String, Map<String, double>>> estadisticasFuture;
  final VoidCallback onRefresh;

  const _SeccionEstadisticas({
    Key? key,
    required this.colorPrincipal,
    required this.estadisticasFuture,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Estadísticas',
                  style: TextStyle(fontSize: 16, color: colorPrincipal)),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.refresh, size: 20, color: colorPrincipal),
                onPressed: onRefresh,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<Map<String, Map<String, double>>>(
              future: estadisticasFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text("Error al cargar estadísticas."));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No hay datos disponibles."));
                } else {
                  return LineChartWidget(data: snapshot.data!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
