import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/services/ab_test_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ABTestMetricsScreen extends StatelessWidget {
  const ABTestMetricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final report = appProvider.metrics.getReport();
    final currentVariant = appProvider.variant;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Teste A/B', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurrentVariant(currentVariant),
              const SizedBox(height: 24),
              _buildMetricCard(
                title: 'Variante A (Controle)',
                subtitle: 'Foco em Agendamento',
                report: report['control']!,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              _buildMetricCard(
                title: 'Variante B (Tratamento)',
                subtitle: 'Foco em Promoções',
                report: report['treatment']!,
                color: const Color(0xFF8B0000),
              ),
              const SizedBox(height: 24),
              _buildConversionComparison(report),
              const SizedBox(height: 24),
              _buildResetButton(context, appProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentVariant(ABVariant variant) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: variant == ABVariant.treatment
                  ? const Color(0xFF8B0000).withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.science_rounded,
              color: variant == ABVariant.treatment ? const Color(0xFF8B0000) : AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sua Variante Atual', style: AppTextStyles.caption),
                Text(
                  variant == ABVariant.treatment ? 'Variante B (Tratamento)' : 'Variante A (Controle)',
                  style: AppTextStyles.heading3.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String subtitle,
    required Map<String, dynamic> report,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 15)),
                    Text(subtitle, style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Visitas', report['views'].toString(), Icons.visibility_rounded),
              _buildStatItem('Cliques', report['clicks'].toString(), Icons.touch_app_rounded),
              _buildStatItem('Conversões', report['bookings'].toString(), Icons.check_circle_rounded),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Taxa de Conversão',
                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${report['conversion']}%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.textTertiary),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.heading3.copyWith(fontSize: 20)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildConversionComparison(Map<String, dynamic> report) {
    final controlRate = double.tryParse(report['control']['conversion']) ?? 0;
    final treatmentRate = double.tryParse(report['treatment']['conversion']) ?? 0;
    final winner = controlRate > treatmentRate
        ? 'A'
        : treatmentRate > controlRate
            ? 'B'
            : 'Empate';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Comparação de Conversão', style: AppTextStyles.heading3.copyWith(fontSize: 15)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('Controle (A)', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text('${controlRate.toStringAsFixed(1)}%',
                        style: AppTextStyles.heading2.copyWith(
                            color: winner == 'A' ? AppColors.primary : AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: winner == 'Empate'
                      ? AppColors.textTertiary.withValues(alpha: 0.1)
                      : AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  winner == 'Empate' ? 'Empate' : 'Vencedor: $winner',
                  style: AppTextStyles.label.copyWith(
                    color: winner == 'Empate' ? AppColors.textSecondary : AppColors.accentDark,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('Tratamento (B)', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text('${treatmentRate.toStringAsFixed(1)}%',
                        style: AppTextStyles.heading2.copyWith(
                            color: winner == 'B' ? const Color(0xFF8B0000) : AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(BuildContext context, AppProvider appProvider) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Limpar Métricas?'),
              content: const Text('Todos os dados de teste A/B serão apagados.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Limpar', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            await appProvider.clearMetrics();
          }
        },
        icon: const Icon(Icons.delete_outline_rounded, size: 18),
        label: const Text('Limpar Métricas'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}