import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartExample extends StatelessWidget {
  const LineChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfica de Línea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: true,
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, interval: 1),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, interval: 10),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xFF37434D)),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 10), // Domingo
                  FlSpot(1, 20), // Lunes
                  FlSpot(2, 30), // Martes
                  FlSpot(3, 40), // Miércoles
                  FlSpot(4, 50), // Jueves
                  FlSpot(5, 60), // Viernes
                  FlSpot(6, 70), // Sábado
                ],
                isCurved: true,
                color: const Color(0xFF21B0E4), // Línea de costales cocidos
                barWidth: 4,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              ),
              LineChartBarData(
                spots: [
                  FlSpot(0, 5), // Domingo
                  FlSpot(1, 14), // Lunes
                  FlSpot(2, 12), // Martes
                  FlSpot(3, 13), // Miércoles
                  FlSpot(4, 7),  // Jueves
                  FlSpot(5, 17), // Viernes
                  FlSpot(6, 21), // Sábado
                ],
                isCurved: true,
                color: const Color(0xFF5BA951), // Línea de masa pesada
                barWidth: 4,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

