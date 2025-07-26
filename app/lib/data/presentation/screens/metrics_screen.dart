import 'package:app/data/presentation/providers/metrics.provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// --- Main Screen Widget with Custom Tab Implementation ---

class MetricsScreen extends StatefulWidget {
  const MetricsScreen({super.key});

  @override
  State<MetricsScreen> createState() => _MetricsScreenState();
}

class _MetricsScreenState extends State<MetricsScreen> {
  // Use a simple index for state instead of a TabController
  int _selectedIndex = 0;

  /// Builds a single custom tab item.
  Widget _buildTabItem({required String title, required int index}) {
    final bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: isSelected ? AppColors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the custom tab bar using a Row of custom items.
  Widget _buildCustomTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          _buildTabItem(title: 'My Metrics', index: 0),
          const SizedBox(width: 8),
          _buildTabItem(title: 'Family', index: 1),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // List of pages to be displayed by the custom tab bar.
    final List<Widget> pages = [
      const MyMetricsPage(),
      const FamilyMetricsPage(),
    ];

    // The root widget is now a Column, perfect for an app shell's body.
    return Column(
      children: [
        _buildCustomTabBar(),
        Expanded(
          // Display the page corresponding to the selected index.
          child: IndexedStack(index: _selectedIndex, children: pages),
        ),
      ],
    );
  }
}

// --- "My Metrics" Tab Content ---

class MyMetricsPage extends ConsumerWidget {
  const MyMetricsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMetricsValue = ref.watch(metricsDataProvider);
    final List<Widget> metricWidgets = [
      _buildKeyMetricsGrid(),
      asyncMetricsValue.when(
        data: (data) {
          return Text(data[0].metricType);
        },
        error: (err, stack) =>
            const Text("Hello There!!", style: TextStyle(fontSize: 32)),
        loading: () => Text("Loading.."),
      ),
      ChartCard(
        title: 'Medicine Adherence',
        subtitle: 'Last 7 days compliance',
        icon: Icons.trending_up_rounded,
        iconColor: AppColors.success,
        child: _buildMedicineAdherenceChart(),
      ),
      ChartCard(
        title: 'Medicine Inventory',
        subtitle: 'Stock levels by category',
        icon: Icons.inventory_2_rounded,
        iconColor: AppColors.warning,
        child: _buildInventoryChart(),
      ),
      ChartCard(
        title: 'Medicine Categories',
        subtitle: 'Distribution of your vault',
        icon: Icons.pie_chart_rounded,
        iconColor: AppColors.primary,
        child: _buildMedicineCategoriesChart(),
      ),
    ];

    return AnimationLimiter(
      child: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: metricWidgets.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 400),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: metricWidgets[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKeyMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          '92%',
          'Adherence',
          AppColors.primaryLight,
          AppColors.primary,
        ),
        _buildStatCard(
          '3',
          'Due Today',
          AppColors.accent.withOpacity(0.25),
          AppColors.warning,
        ),
        _buildStatCard(
          '5',
          'Low Stock',
          AppColors.error.withOpacity(0.2),
          AppColors.error,
        ),
        _buildStatCard(
          '4',
          'Members',
          AppColors.secondary.withOpacity(0.25),
          AppColors.secondary,
        ),
      ],
    );
  }
}

// --- "Family Metrics" Tab Content ---

class FamilyMetricsPage extends StatefulWidget {
  const FamilyMetricsPage({super.key});

  @override
  State<FamilyMetricsPage> createState() => _FamilyMetricsPageState();
}

class _FamilyMetricsPageState extends State<FamilyMetricsPage> {
  final List<String> _familyMembers = [
    'All Members',
    'Mom',
    'Dad',
    'Sister',
    'Grandpa',
  ];
  late String _selectedMember;

  @override
  void initState() {
    super.initState();
    _selectedMember = _familyMembers.first;
  }

  Widget _buildMemberSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedMember,
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: 'Select Member',
          labelStyle: AppTextStyles.label,
        ),
        items: _familyMembers.map((String member) {
          return DropdownMenuItem<String>(
            value: member,
            child: Text(
              member,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() => _selectedMember = newValue);
          }
        },
        icon: const Icon(
          Icons.arrow_drop_down_rounded,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildKeyMetricsGrid() {
    Map<String, String> data;
    switch (_selectedMember) {
      case 'Mom':
        data = {
          'score': '85%',
          'adherence': '95%',
          'alerts': '0',
          'low_stock': '1',
        };
        break;
      case 'Dad':
        data = {
          'score': '78%',
          'adherence': '80%',
          'alerts': '1',
          'low_stock': '3',
        };
        break;
      case 'Sister':
        data = {
          'score': '95%',
          'adherence': '98%',
          'alerts': '0',
          'low_stock': '0',
        };
        break;
      case 'Grandpa':
        data = {
          'score': '72%',
          'adherence': '85%',
          'alerts': '2',
          'low_stock': '4',
        };
        break;
      case 'All Members':
      default:
        data = {
          'score': '85%',
          'adherence': '88%',
          'alerts': '2',
          'low_stock': '5',
        };
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.25,
      children: [
        _buildStatCard(
          data['score']!,
          'Avg. Score',
          AppColors.primaryLight,
          AppColors.primary,
        ),
        _buildStatCard(
          data['adherence']!,
          'Adherence',
          AppColors.success.withOpacity(0.15),
          AppColors.success,
        ),
        _buildStatCard(
          data['alerts']!,
          'Alerts',
          AppColors.accent.withOpacity(0.25),
          AppColors.warning,
        ),
        _buildStatCard(
          data['low_stock']!,
          'Low Stock',
          AppColors.error.withOpacity(0.2),
          AppColors.error,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> metricWidgets = [
      _buildMemberSelector(),
      _buildKeyMetricsGrid(),
      ChartCard(
        title: 'Health Score',
        subtitle: 'Score for $_selectedMember',
        icon: Icons.family_restroom_rounded,
        iconColor: AppColors.primary,
        child: _buildFamilyHealthChart(_selectedMember),
      ),
    ];

    return AnimationLimiter(
      child: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: metricWidgets.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 400),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: metricWidgets[index]),
            ),
          );
        },
      ),
    );
  }
}

// --- Shared Widgets, Helpers, and Theme (Placed here for completeness) ---

Widget _buildStatCard(
  String value,
  String label,
  Color bgColor,
  Color textColor,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(color: textColor.withOpacity(0.8)),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

class ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  const ChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.cardSubtitle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(height: 200, child: child),
        ],
      ),
    );
  }
}

// Chart Builders and Helpers
Widget _buildMedicineAdherenceChart() {
  return LineChart(
    LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: _getTitlesData(),
      borderData: FlBorderData(show: false),
      lineTouchData: const LineTouchData(enabled: false),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 85),
            FlSpot(1, 92),
            FlSpot(2, 78),
            FlSpot(3, 95),
            FlSpot(4, 88),
            FlSpot(5, 90),
            FlSpot(6, 87),
          ],
          isCurved: true,
          color: AppColors.success,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.success.withOpacity(0.3),
                AppColors.success.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildInventoryChart() {
  final barGroups = [
    _createBarGroup(0, 75, AppColors.warning),
    _createBarGroup(1, 45, AppColors.warning),
    _createBarGroup(2, 90, AppColors.success),
    _createBarGroup(3, 60, AppColors.warning),
    _createBarGroup(4, 30, AppColors.error),
  ];
  return BarChart(
    BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 100,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => AppColors.textPrimary,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            const categories = ['Pain', 'Heart', 'Diabetes', 'Vitamins', 'BP'];
            return BarTooltipItem(
              '${categories[groupIndex]}\n${rod.toY.round()} units',
              AppTextStyles.body.copyWith(color: AppColors.white, fontSize: 12),
            );
          },
        ),
      ),
      titlesData: _getTitlesData(
        bottomLabels: ['Pain', 'Heart', 'Diabetes', 'Vitamins', 'BP'],
        leftInterval: 25,
        leftSuffix: '',
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 25,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.grey[200]!, strokeWidth: 1),
      ),
      barGroups: barGroups,
    ),
  );
}

Widget _buildFamilyHealthChart(String selectedMember) {
  List<BarChartGroupData> barGroups;
  List<String> bottomLabels;

  switch (selectedMember) {
    case 'Mom':
      barGroups = [_createBarGroup(0, 85, AppColors.success)];
      bottomLabels = ['Mom'];
      break;
    case 'Dad':
      barGroups = [_createBarGroup(0, 78, AppColors.warning)];
      bottomLabels = ['Dad'];
      break;
    case 'Sister':
      barGroups = [_createBarGroup(0, 95, AppColors.success)];
      bottomLabels = ['Sister'];
      break;
    case 'Grandpa':
      barGroups = [_createBarGroup(0, 72, AppColors.warning)];
      bottomLabels = ['Grandpa'];
      break;
    case 'All Members':
    default:
      barGroups = [
        _createBarGroup(0, 92, AppColors.success),
        _createBarGroup(1, 85, AppColors.success),
        _createBarGroup(2, 78, AppColors.warning),
        _createBarGroup(3, 95, AppColors.success),
        _createBarGroup(4, 72, AppColors.warning),
      ];
      bottomLabels = ['You', 'Mom', 'Dad', 'Sister', 'Grandpa'];
  }

  return BarChart(
    BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 100,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => AppColors.textPrimary,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${bottomLabels[groupIndex]}\n${rod.toY.round()}% Score',
              AppTextStyles.body.copyWith(color: AppColors.white, fontSize: 12),
            );
          },
        ),
      ),
      titlesData: _getTitlesData(
        bottomLabels: bottomLabels,
        leftInterval: 25,
        leftSuffix: '%',
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 25,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.grey[200]!, strokeWidth: 1),
      ),
      barGroups: barGroups,
    ),
  );
}

Widget _buildMedicineCategoriesChart() {
  return IntrinsicHeight(
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(enabled: true),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              startDegreeOffset: -90,
              sections: _getPieChartSections(),
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLegendItem('Chronic Care', '35%', AppColors.primary),
              _buildLegendItem('Supplements', '25%', AppColors.secondary),
              _buildLegendItem('Pain Relief', '20%', AppColors.warning),
              _buildLegendItem('Emergency', '12%', AppColors.error),
              _buildLegendItem(
                'Other',
                '8%',
                AppColors.textSecondary.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

List<PieChartSectionData> _getPieChartSections() {
  final sections = [
    (35.0, AppColors.primary),
    (25.0, AppColors.secondary),
    (20.0, AppColors.warning),
    (12.0, AppColors.error),
    (8.0, AppColors.textSecondary.withOpacity(0.5)),
  ];
  return sections
      .map(
        (data) => PieChartSectionData(
          value: data.$1,
          color: data.$2,
          title: '${data.$1.toInt()}%',
          radius: 35,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
          titlePositionPercentageOffset: 0.6,
        ),
      )
      .toList();
}

Widget _buildLegendItem(String title, String value, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(value, style: AppTextStyles.label),
      ],
    ),
  );
}

BarChartGroupData _createBarGroup(int x, double y, Color color) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        color: color,
        width: 16,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
    ],
  );
}

FlTitlesData _getTitlesData({
  List<String>? bottomLabels,
  double leftInterval = 20,
  String leftSuffix = '%',
}) {
  final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final labels = bottomLabels ?? days;

  return FlTitlesData(
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        interval: leftInterval,
        getTitlesWidget: (value, meta) {
          if (value == meta.max || value == meta.min) return Container();
          return Text(
            '${value.toInt()}$leftSuffix',
            style: AppTextStyles.label,
          );
        },
      ),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: (value, meta) {
          final index = value.toInt();
          if (index >= labels.length) return Container();
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(labels[index], style: AppTextStyles.label),
          );
        },
      ),
    ),
  );
}

// --- App Theme (Placed here for completeness) ---

class AppColors {
  static const primary = Color(0xFF006D77);
  static const primaryLight = Color(0xFFE2F3F4);
  static const secondary = Color(0xFF83C5BE);
  static const accent = Color(0xFFFFD60A);
  static const background = Color(0xFFF7F9FA);
  static const textPrimary = Color(0xFF223242);
  static const textSecondary = Color(0xFF6E7E8D);
  static const white = Colors.white;
  static const success = Color(0xFF2D9A5E);
  static const warning = Color(0xFFF4A261);
  static const error = Color(0xFFE76F51);
}

class AppTextStyles {
  static const headline1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const cardSubtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  static const label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );
}
