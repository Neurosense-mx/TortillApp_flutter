import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final Map<String, Map<String, double>> data;

  const LineChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Lista de días de la semana en el formato abreviado
    List<String> daysOfWeek = ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab'];

    List<FlSpot> costalesCocidosSpots = [];
    List<FlSpot> masaPesadaSpots = [];

    // Extraer los valores de los datos
    data['costales_cocidos']!.forEach((day, value) {
      int index = daysOfWeek.indexOf(day); // Obtener el índice del día
      costalesCocidosSpots.add(FlSpot(index.toDouble(), value)); // Añadir el punto al gráfico
    });

    data['masa_pesada']!.forEach((day, value) {
      int index = daysOfWeek.indexOf(day); // Obtener el índice del día
      masaPesadaSpots.add(FlSpot(index.toDouble(), value)); // Añadir el punto al gráfico
    });

    return Container(
      height: 300, // Define una altura fija para el gráfico
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true, // Mostrar líneas horizontales de la cuadrícula
            drawVerticalLine: false, // Ocultar líneas verticales de la cuadrícula
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, // Mostrar etiquetas del eje X
                interval: 1,
                getTitlesWidget: (value, meta) {
                  // Mostrar el nombre del día en el eje X
                  return Text(daysOfWeek[value.toInt()]);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Ocultar etiquetas del eje Y
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Ocultar etiquetas del eje Y (lado derecho)
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Ocultar etiquetas del eje X (arriba)
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xFF37434D)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: costalesCocidosSpots,
              isCurved: true,
              color: const Color(0xFF21B0E4), // Línea de costales cocidos
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: masaPesadaSpots,
              isCurved: true,
              color: const Color(0xFF5BA951), // Línea de masa pesada
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final value = spot.y; // Valor del punto seleccionado
                  final day = daysOfWeek[spot.x.toInt()]; // Día seleccionado

                  // Determinar la categoría basada en el índice de la línea
                  String category;
                  if (spot.barIndex == 0) {
                    category = 'Costales';
                  } else {
                    category = 'Masa';
                  }

                  // Formatear el valor según la categoría
                  String formattedValue;
                  if (category == 'Costales') {
                    formattedValue = value.toStringAsFixed(0); // Sin decimales
                  } else {
                    formattedValue = '${value.toStringAsFixed(1)} Kg'; // Con "Kg"
                  }

                  return LineTooltipItem(
                    '$category: $formattedValue',
                    const TextStyle(color: Colors.white),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}