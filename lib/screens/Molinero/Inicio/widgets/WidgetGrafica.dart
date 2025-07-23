import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final Map<String, Map<String, double>> data;

  const LineChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    List<String> daysOfWeek = ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab'];

    List<FlSpot> costalesCocidosSpots = [];
    List<FlSpot> masaPesadaSpots = [];

    data['costales_cocidos']!.forEach((day, value) {
      int index = daysOfWeek.indexOf(day);
      costalesCocidosSpots.add(FlSpot(index.toDouble(), value));
    });

    data['masa_pesada']!.forEach((day, value) {
      int index = daysOfWeek.indexOf(day);
      masaPesadaSpots.add(FlSpot(index.toDouble(), value));
    });

    // Calcular el rango dinámico del eje Y
    final allValues = [
      ...costalesCocidosSpots.map((e) => e.y),
      ...masaPesadaSpots.map((e) => e.y)
    ];
    double minY = allValues.reduce((a, b) => a < b ? a : b);
    double maxY = allValues.reduce((a, b) => a > b ? a : b);

    // Agregar un pequeño margen al rango
    double margin = (maxY - minY) * 0.1;
    minY = (minY - margin).clamp(0, double.infinity);
    maxY += margin;

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Text(daysOfWeek[value.toInt()]);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: ((maxY - minY) / 5).clamp(1, double.infinity),

                getTitlesWidget: (value, meta) {
                  return Text(value.toStringAsFixed(0));
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xFF37434D)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: costalesCocidosSpots,
              isCurved: false, // No suavizada
              color: const Color(0xFF21B0E4),
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: masaPesadaSpots,
              isCurved: false, // No suavizada
              color: const Color(0xFF5BA951),
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final value = spot.y;
                  final day = daysOfWeek[spot.x.toInt()];
                  String category = spot.barIndex == 0 ? 'Maíz' : 'Masa';
                  String formattedValue = category == 'Maíz'
                      ? value.toStringAsFixed(0)
                      : '${value.toStringAsFixed(1)} Kg';

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
