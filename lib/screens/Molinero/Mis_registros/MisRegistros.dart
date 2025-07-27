import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tortillapp/models/Molinero/MolineroModelo.dart';
import 'package:tortillapp/config/paletteColor.dart';

class MisRegistrosMolinero extends StatefulWidget {
  final MostradorModel molino;

  const MisRegistrosMolinero({Key? key, required this.molino})
      : super(key: key);

  @override
  State<MisRegistrosMolinero> createState() => _MisRegistrosMolineroState();
}

class _MisRegistrosMolineroState extends State<MisRegistrosMolinero> {
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

    final datos = await widget.molino.getMisRegistros();

    if (datos is List) {
      final registros = List<Map<String, dynamic>>.from(datos);

      registros.sort((a, b) => b['maiz_cocido']['fecha_cocido']
          .compareTo(a['maiz_cocido']['fecha_cocido']));

      final agrupados = <String, List<Map<String, dynamic>>>{};

      for (var registro in registros) {
        final fechaStr = registro['maiz_cocido']['fecha_cocido'];
        final fecha = DateTime.tryParse(fechaStr);
        if (fecha == null) continue;

        final key = formatearFechaHeader(fecha);
        agrupados.putIfAbsent(key, () => []).add(registro);
      }

      final keys = agrupados.keys.toList()
        ..sort((a, b) {
          final f1 = agrupados[a]![0]['maiz_cocido']['fecha_cocido'];
          final f2 = agrupados[b]![0]['maiz_cocido']['fecha_cocido'];
          return f2.compareTo(f1);
        });

      setState(() {
        registrosPorFecha = agrupados;
        registrosOriginales =
            Map<String, List<Map<String, dynamic>>>.from(agrupados);
        headersOrdenados = keys;
        headersOriginales = List<String>.from(keys);

        registrosMostradosPorFecha = {
          for (var key in headersOrdenados)
            key: agrupados[key]!.length > pageSize
                ? pageSize
                : agrupados[key]!.length
        };
        _loading = false;
        fechaFiltro = null;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  String formatearFechaHeader(DateTime fecha) {
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
    final maiz = registro['maiz_cocido'];
    final masa = registro['peso_masa'];

    double? rendimiento;
    if (maiz != null && masa != null) {
      final double? kgCocido = double.tryParse(maiz['kg_cocido'].toString());
      final double? kgMasa = double.tryParse(masa['peso_masa'].toString());
      if (kgCocido != null && kgMasa != null && kgCocido > 0) {
        rendimiento = (kgMasa / kgCocido) * 100;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Maíz cocido",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text("${maiz['kg_cocido']} kg",
                      style: const TextStyle(fontSize: 13)),
                  Text(formatearHora(maiz['fecha_cocido']),
                      style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.0),
            child: Icon(Icons.arrow_forward, size: 18, color: Colors.grey),
          ),
          Flexible(
            flex: 4,
            child: masa != null
                ? Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Masa obtenida",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        Text("${masa['peso_masa']} kg",
                            style: const TextStyle(fontSize: 13)),
                        Text(formatearHora(masa['fecha_masa']),
                            style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          if (rendimiento != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: Icon(Icons.arrow_forward, size: 18, color: Colors.grey),
            ),
            Flexible(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Relación Maíz/Masa",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    Text("${rendimiento.toStringAsFixed(1)} %",
                        style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
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
    final fechaStrFiltro = DateFormat('dd/MM/yyyy').format(fecha);

    // Filtrar registros originales para la fecha seleccionada
    final filtrados = <String, List<Map<String, dynamic>>>{};

    registrosOriginales.forEach((key, lista) {
      final registrosFiltradosPorFecha = lista.where((registro) {
        final fechaStr = registro['maiz_cocido']['fecha_cocido'];
        final fechaRegistro = DateTime.tryParse(fechaStr);
        if (fechaRegistro == null) return false;

        // Comparar solo la parte de día, mes y año
        return fechaRegistro.year == fecha.year &&
            fechaRegistro.month == fecha.month &&
            fechaRegistro.day == fecha.day;
      }).toList();

      if (registrosFiltradosPorFecha.isNotEmpty) {
        filtrados[key] = registrosFiltradosPorFecha;
      }
    });

    setState(() {
      registrosPorFecha = filtrados;
      headersOrdenados = filtrados.keys.toList();

      // Ajustar paginación para filtro
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
