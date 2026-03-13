import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';

import 'widgets/admin_report_card.dart';

class AdminReportsView extends StatefulWidget {
  const AdminReportsView({super.key});

  @override
  State<AdminReportsView> createState() => _AdminReportsViewState();
}

class _AdminReportsViewState extends State<AdminReportsView> {
  final _client = Supabase.instance.client;
  List<Map<String, dynamic>> _reports = [];
  bool _isLoading = true;
  String _filter = 'all';
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _loadReports();
    _subscribeRealtime();
  }

  @override
  void dispose() {
    if (_channel != null) _client.removeChannel(_channel!);
    super.dispose();
  }

  Future<void> _loadReports() async {
    try {
      final data = await _client
          .from('task_reports')
          .select('*, tasks(title), volunteers(full_name)')
          .order('created_at', ascending: false);
      if (mounted) {
        setState(() {
          _reports = List<Map<String, dynamic>>.from(data as List);
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _subscribeRealtime() {
    _channel = _client
        .channel('task_reports_admin')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'task_reports',
          callback: (_) => _loadReports(),
        )
        .subscribe();
  }

  List<Map<String, dynamic>> get _filteredReports {
    if (_filter == 'all') return _reports;
    return _reports.where((r) => r['status'] == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تقارير المهام',
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s16,
            color: ColorManager.blueOne900,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: AppHeight.s48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: AppWidth.s16,
                vertical: AppHeight.s8,
              ),
              reverse: true,
              children: [
                _FilterChip(
                  label: 'الكل',
                  selected: _filter == 'all',
                  onTap: () => setState(() => _filter = 'all'),
                ),
                SizedBox(width: AppWidth.s8),
                _FilterChip(
                  label: 'قيد المراجعة',
                  selected: _filter == 'pending',
                  onTap: () => setState(() => _filter = 'pending'),
                ),
                SizedBox(width: AppWidth.s8),
                _FilterChip(
                  label: 'موافق عليه',
                  selected: _filter == 'approved',
                  onTap: () => setState(() => _filter = 'approved'),
                ),
                SizedBox(width: AppWidth.s8),
                _FilterChip(
                  label: 'مرفوض',
                  selected: _filter == 'rejected',
                  onTap: () => setState(() => _filter = 'rejected'),
                ),
              ],
            ),
          ),
          // Reports list
          Expanded(
            child: _isLoading
                ? const LoadingIndicator()
                : _filteredReports.isEmpty
                    ? Center(
                        child: Text(
                          'لا توجد تقارير',
                          style: getMediumStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s14,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppWidth.s16,
                          vertical: AppHeight.s8,
                        ),
                        itemCount: _filteredReports.length,
                        itemBuilder: (context, i) => AdminReportCard(
                          report: _filteredReports[i],
                          onUpdated: _loadReports,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

// ─── Filter chip ───────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF00ABD2)
              : const Color(0xFF0C203B),
          borderRadius: BorderRadius.circular(AppRadius.s20),
          border: Border.all(
            color: selected
                ? const Color(0xFF00ABD2)
                : const Color(0xFF1E3A5F),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: selected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}
