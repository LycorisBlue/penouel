import 'package:flutter/material.dart';
import 'package:penouel/core/constants/icons.dart';
import 'package:penouel/core/constants/sizes.dart';
import 'package:penouel/core/constants/texts.dart';
import 'package:penouel/services/navigation_service.dart';

/// Widget pour la bannière de bienvenue en haut du tableau de bord
class WelcomeBanner extends StatelessWidget {
  final String userName;

  const WelcomeBanner({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        boxShadow: [
          BoxShadow(color: Theme.of(context).colorScheme.shadow.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenue,',
            style: AppTextStyles.bodyLarge.copyWith(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9)),
          ),
          Text(
            userName,
            style: AppTextStyles.heading2.copyWith(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// Widget pour afficher les informations sur la prochaine séance
class NextSessionCard extends StatelessWidget {
  final String date;
  final String theme;
  final String time;
  final String? speaker;

  const NextSessionCard({Key? key, required this.date, required this.theme, required this.time, this.speaker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        boxShadow: [
          BoxShadow(color: Theme.of(context).colorScheme.shadow.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconManager.getIcon('calendar_today', color: Theme.of(context).colorScheme.primary, size: 22),
                SizedBox(width: AppSizes.paddingSmall),
                Text('Prochaine séance', style: AppTextStyles.heading3.copyWith(color: Theme.of(context).colorScheme.primary)),
              ],
            ),
            Divider(color: Theme.of(context).colorScheme.surfaceVariant, height: AppSizes.paddingLarge * 2),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(date, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(height: AppSizes.paddingSmall / 2),
                      Text(time, style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Action pour voir les détails de la séance
                    Routes.navigateTo('/seances');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: AppSizes.paddingMedium),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSmall)),
                  ),
                  child: Text('Détails', style: AppTextStyles.buttonText),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingMedium),
            Text('Thème :', style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            SizedBox(height: AppSizes.paddingSmall / 2),
            Text(theme, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            if (speaker != null) ...[
              SizedBox(height: AppSizes.paddingSmall),
              Text('Orateur :', style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              SizedBox(height: AppSizes.paddingSmall / 2),
              Text(speaker!, style: AppTextStyles.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget pour les statistiques de présence
class AttendanceStatsCard extends StatelessWidget {
  final int totalMembers;
  final int presentMembers;
  final double attendanceRate;

  const AttendanceStatsCard({Key? key, required this.totalMembers, required this.presentMembers, required this.attendanceRate})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        boxShadow: [
          BoxShadow(color: Theme.of(context).colorScheme.shadow.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconManager.getIcon('check_circle_outline', color: Theme.of(context).colorScheme.primary, size: 22),
                SizedBox(width: AppSizes.paddingSmall),
                Text(
                  'Statistiques de présence',
                  style: AppTextStyles.heading3.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(context, 'Total', totalMembers.toString(), Icons.people),
                _buildStatColumn(context, 'Présents', presentMembers.toString(), Icons.person),
                _buildStatColumn(context, 'Taux', '${attendanceRate.toStringAsFixed(1)}%', Icons.percent),
              ],
            ),
            SizedBox(height: AppSizes.paddingMedium),
            LinearProgressIndicator(
              value: attendanceRate / 100,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              color: _getProgressColor(context, attendanceRate),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary.withOpacity(0.7), size: 24),
        SizedBox(height: AppSizes.paddingSmall),
        Text(value, style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: AppSizes.paddingSmall / 2),
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Color _getProgressColor(BuildContext context, double rate) {
    if (rate >= 80) {
      return Colors.green;
    } else if (rate >= 60) {
      return Theme.of(context).colorScheme.primary;
    } else if (rate >= 40) {
      return Theme.of(context).colorScheme.secondary;
    } else {
      return Theme.of(context).colorScheme.error;
    }
  }
}

/// Widget d'accès rapide aux fonctionnalités principales
class QuickAccessGrid extends StatelessWidget {
  final List<QuickAccessItem> items;

  const QuickAccessGrid({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: AppSizes.paddingMedium,
        mainAxisSpacing: AppSizes.paddingMedium,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _QuickAccessCard(icon: item.icon, label: item.label, onTap: item.onTap);
      },
    );
  }
}

/// Élément d'accès rapide
class QuickAccessItem {
  final String icon;
  final String label;
  final VoidCallback onTap;

  QuickAccessItem({required this.icon, required this.label, required this.onTap});
}

/// Carte d'accès rapide
class _QuickAccessCard extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAccessCard({Key? key, required this.icon, required this.label, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          boxShadow: [
            BoxShadow(color: Theme.of(context).colorScheme.shadow.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2)),
          ],
        ),
        padding: EdgeInsets.all(AppSizes.paddingSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconManager.getIcon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
            SizedBox(height: AppSizes.paddingSmall),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget pour afficher les événements à venir
class UpcomingEventsCard extends StatelessWidget {
  final List<EventItem> events;

  const UpcomingEventsCard({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        boxShadow: [
          BoxShadow(color: Theme.of(context).colorScheme.shadow.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconManager.getIcon('message', color: Theme.of(context).colorScheme.primary, size: 22),
                    SizedBox(width: AppSizes.paddingSmall),
                    Text(
                      'Événements à venir',
                      style: AppTextStyles.heading3.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // Naviguer vers la page des événements
                    Routes.navigateTo('/events');
                  },
                  child: Text('Voir tous', style: AppTextStyles.link),
                ),
              ],
            ),
            Divider(color: Theme.of(context).colorScheme.surfaceVariant, height: AppSizes.paddingLarge * 2),
            events.isEmpty
                ? _buildEmptyEvents(context)
                : Column(children: events.map((event) => _EventListItem(event: event)).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyEvents(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSizes.paddingLarge),
      alignment: Alignment.center,
      child: Column(
        children: [
          IconManager.getIcon('calendar_today', color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5), size: 32),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'Aucun événement à venir',
            style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Modèle de données pour un événement
class EventItem {
  final String title;
  final String date;
  final String location;
  final String? description;

  EventItem({required this.title, required this.date, required this.location, this.description});
}

/// Widget pour afficher un événement dans la liste
class _EventListItem extends StatelessWidget {
  final EventItem event;

  const _EventListItem({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.paddingMedium),
      child: InkWell(
        onTap: () {
          // Afficher plus de détails sur l'événement
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: Container(
          padding: EdgeInsets.all(AppSizes.paddingMedium),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            border: Border.all(color: Theme.of(context).colorScheme.surfaceVariant, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconManager.getIcon('calendar_today', color: Theme.of(context).colorScheme.secondary, size: 16),
                  ),
                  SizedBox(width: AppSizes.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          event.date,
                          style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (event.description != null) ...[
                SizedBox(height: AppSizes.paddingSmall),
                Text(event.description!, style: AppTextStyles.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
              SizedBox(height: AppSizes.paddingSmall),
              Row(
                children: [
                  IconManager.getIcon('location_on_outlined', color: Theme.of(context).colorScheme.onSurfaceVariant, size: 16),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.location,
                      style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
