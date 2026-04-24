import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/dashboard_model.dart';
import '../../core/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../core/dashboard_service.dart';

class SystemItemCard extends StatelessWidget {
  final MenuItem item;

  const SystemItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyan.shade50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            // Tampilkan indikator loading transparan
            showDialog(
              context: context,
              barrierDismissible: false,
              barrierColor: Colors.white.withOpacity(0.5),
              builder: (BuildContext context) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                );
              },
            );

            try {
              // Ambil token dari AuthProvider
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final token = authProvider.currentUser?.token;

              if (token == null) {
                throw Exception('No authentication token found');
              }

              // Panggil API getSsoTicket
              final dashboardService = DashboardService();
              final ssoTicket = await dashboardService.fetchSsoTicket(token);

              // Tutup dialog loading
              if (context.mounted) {
                Navigator.of(context).pop();
              }

              // Gabungkan URL repo dengan sso ticket
              final fullUrl = '${item.content.repo}/sso/verify?ticket=$ssoTicket';
              final uri = Uri.parse(fullUrl);

              if (kIsWeb) {
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, webOnlyWindowName: '_self');
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not open ${item.module.moduleName}')),
                    );
                  }
                }
              } else {
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not open ${item.module.moduleName}')),
                    );
                  }
                }
              }
            } catch (e) {
              // Tutup dialog loading jika terjadi error
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal mendapatkan akses: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.module.moduleName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.module.moduleDescription,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Click to Access System',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.launch_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
