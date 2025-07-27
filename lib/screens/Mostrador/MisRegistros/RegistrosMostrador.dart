import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Mostrador/ModelMostrador.dart';


class MisRegistrosMostrador extends StatefulWidget {
  final MostradorModel mostrador;
  const MisRegistrosMostrador({Key? key, required this.mostrador})
      : super(key: key);

  @override
  State<MisRegistrosMostrador> createState() => _MisRegistrosMostradorState();
}

class _MisRegistrosMostradorState extends State<MisRegistrosMostrador> {
  final PaletaDeColores colores = PaletaDeColores();

  Map<String, List<Map<String, dynamic>>> registrosPorFecha = {};
  List<String> headersOrdenados = [];
  Map<String, int> registrosMostradosPorFecha = {};

  static const int pageSize = 20;

  bool _loading = false;

  // Variable para filtrar fecha seleccionada (null = sin filtro)
  DateTime? fechaFiltro;

  // Registros originales sin filtrar para restaurar
  Map<String, List<Map<String, dynamic>>> registrosOriginales = {};
  List<String> headersOriginales = [];

  @override
  void initState() {
    super.initState();
    loadRegistros();
  }

Future<void> loadRegistros() async {
  if (_loading) return;
  setState(() => _loading = true);

  final registroVentasTortillas = await widget.mostrador.getVentasTortillas();
  final registroVentasProductos = await widget.mostrador.getVentasProductos();
  //imprimir los registros
  print("Registros de ventas de tortillas: $registroVentasTortillas");
  print("Registros de ventas de productos: $registroVentasProductos");
  final List<Map<String, dynamic>> registrosTotales = [];

  for (final venta in registroVentasTortillas) {
    venta['tipo'] = 'tortilla';
    registrosTotales.add(venta);
  }

  for (final venta in registroVentasProductos) {
    venta['tipo'] = 'producto';
    registrosTotales.add(venta);
  }

  registrosTotales.sort((a, b) =>
      DateTime.parse(b['fecha']).compareTo(DateTime.parse(a['fecha'])));

  final Map<String, List<Map<String, dynamic>>> agrupados = {};

  for (final registro in registrosTotales) {
    final fecha = DateTime.parse(registro['fecha']);
    final key = formatearFechaHeader(fecha);

    agrupados.putIfAbsent(key, () => []).add(registro);
  }

  setState(() {
    registrosPorFecha = agrupados;
    registrosOriginales = Map.from(agrupados);
    headersOrdenados = agrupados.keys.toList();
    headersOriginales = List.from(headersOrdenados);
    registrosMostradosPorFecha = {
      for (var key in headersOrdenados)
        key: agrupados[key]!.length > pageSize
            ? pageSize
            : agrupados[key]!.length
    };
    _loading = false;
  });
}


String formatearFechaHeader(DateTime fechaUtc) {
  final fecha = fechaUtc.toLocal(); // <--- Convertir a hora local

  final ahora = DateTime.now();
  final hoy = DateTime(ahora.year, ahora.month, ahora.day);
  final ayer = hoy.subtract(const Duration(days: 1));
  final fechaSoloDia = DateTime(fecha.year, fecha.month, fecha.day);

  if (fechaSoloDia == hoy) return "Hoy";
  if (fechaSoloDia == ayer) return "Ayer";
  return DateFormat('dd/MM/yyyy').format(fecha);
}

  String formatearHora(String fecha) {
    final dt = DateTime.tryParse(fecha);
    return dt != null ? DateFormat.Hm().format(dt) : fecha;
  }

 Widget buildRegistro(Map<String, dynamic> registro) {
  final tipo = registro['tipo'];

  if (tipo == 'tortilla') {
    return ListTile(
      leading: const Icon(Icons.circle),
      title: Text("Venta de tortillas"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Cantidad: ${registro['cantidad']} kg"),
          Text("Total: \$${registro['total_venta']}"),
          Text("Precio unitario: \$${registro['precio_venta']}"),
          Text("Lugar venta: ${registro['lugar_venta']}"),
        ],
      ),
      trailing: Text(formatearHora(registro['fecha'])),
    );
  } else if (tipo == 'producto') {
    return ListTile(
      leading: const Icon(Icons.inventory),
      title: Text("Producto: ${registro['nombre_producto']}"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Cantidad: ${registro['cantidad']}"),
          Text("Total: \$${registro['total_venta']}"),
        ],
      ),
      trailing: Text(formatearHora(registro['fecha'])),
    );
  }

  return const SizedBox.shrink(); // Fallback
}

  void cargarMasRegistros(String header) {
    final total = registrosPorFecha[header]!.length;
    final actuales = registrosMostradosPorFecha[header] ?? 0;
    final nuevos =
        (actuales + pageSize) > total ? total : (actuales + pageSize);

    setState(() {
      registrosMostradosPorFecha[header] = nuevos;
    });
  }

  Future<void> seleccionarFechaFiltro() async {
    final ahora = DateTime.now();
    final fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: fechaFiltro ?? ahora,
      firstDate: DateTime(2000),
      lastDate: ahora,
      locale: const Locale('es', 'ES'),
    );

    if (fechaSeleccionada != null) {
      aplicarFiltroFecha(fechaSeleccionada);
    }
  }

void aplicarFiltroFecha(DateTime fecha) {
  final filtrados = <String, List<Map<String, dynamic>>>{};

  registrosOriginales.forEach((_, lista) {
    for (var registro in lista) {
      final fechaStr = registro['fecha'];
      final fechaRegistro = DateTime.tryParse(fechaStr)?.toLocal(); // ✅ aquí

      if (fechaRegistro == null) continue;

      if (fechaRegistro.year == fecha.year &&
          fechaRegistro.month == fecha.month &&
          fechaRegistro.day == fecha.day) {
        final key = formatearFechaHeader(fechaRegistro); // ya en local
        filtrados.putIfAbsent(key, () => []).add(registro);
      }
    }
  });

  setState(() {
    registrosPorFecha = filtrados;
    headersOrdenados = filtrados.keys.toList();
    registrosMostradosPorFecha = {
      for (var key in headersOrdenados)
        key: filtrados[key]!.length > pageSize
            ? pageSize
            : filtrados[key]!.length
    };
    fechaFiltro = fecha;
  });
}

  void limpiarFiltro() {
    setState(() {
      registrosPorFecha =
          Map<String, List<Map<String, dynamic>>>.from(registrosOriginales);
      headersOrdenados = List<String>.from(headersOriginales);

      registrosMostradosPorFecha = {
        for (var key in headersOrdenados)
          key: registrosPorFecha[key]!.length > pageSize
              ? pageSize
              : registrosPorFecha[key]!.length
      };
      fechaFiltro = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Mis registros',
              style: TextStyle(
                color: colores.colorPrincipal,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            // Mostrar filtro activo
            if (fechaFiltro != null)
              GestureDetector(
                onTap: limpiarFiltro,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colores.colorPrincipal.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(fechaFiltro!),
                        style: TextStyle(
                            color: colores.colorPrincipal, fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.close,
                          size: 16, color: colores.colorPrincipal),
                    ],
                  ),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt, color: colores.colorPrincipal),
            tooltip: 'Filtrar por fecha',
            onPressed: seleccionarFechaFiltro,
          ),
        ],
      ),
      body: _loading && registrosPorFecha.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadRegistros,
              child: registrosPorFecha.isEmpty
                  ? Center(
                      child: Text(
                        fechaFiltro != null
                            ? 'No hay registros para la fecha seleccionada'
                            : 'No hay registros disponibles',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: headersOrdenados.length,
                      itemBuilder: (context, index) {
                        final header = headersOrdenados[index];
                        final registrosGrupo = registrosPorFecha[header]!;
                        final mostrarCantidad =
                            registrosMostradosPorFecha[header] ?? pageSize;

                        final registrosAMostrar =
                            registrosGrupo.take(mostrarCantidad).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              child: Row(
                                children: [
                                  Text(
                                    header,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Divider(
                                        color: Colors.grey, thickness: 0.4),
                                  ),
                                ],
                              ),
                            ),
                            ...registrosAMostrar.map(buildRegistro).toList(),
                            if (mostrarCantidad < registrosGrupo.length)
                              Center(
                                child: TextButton(
                                  onPressed: () => cargarMasRegistros(header),
                                  child: const Text("Cargar más",
                                      style: TextStyle(fontSize: 14)),
                                ),
                              ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
            ),
    );
  }
}
