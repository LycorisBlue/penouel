import 'package:flutter/material.dart';
import 'package:penouel/core/constants/colors.dart';
import 'package:penouel/core/constants/icons.dart';
import 'package:penouel/core/constants/sizes.dart';
import 'package:penouel/core/constants/texts.dart';
import 'package:intl/intl.dart';

/// Widget d'en-tête pour l'écran des cultes avec titre et actions
class CulteHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onFilterTap;
  final VoidCallback? onSearchTap;

  const CulteHeader({Key? key, required this.title, this.onFilterTap, this.onSearchTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSizes.paddingMedium, horizontal: AppSizes.paddingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        boxShadow: [
          BoxShadow(color: Theme.of(context).colorScheme.shadow.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconManager.getIcon('calendar_today', color: Theme.of(context).colorScheme.primary, size: 22),
              SizedBox(width: AppSizes.paddingSmall),
              Text(title, style: AppTextStyles.heading3.copyWith(color: Theme.of(context).colorScheme.primary)),
            ],
          ),
          Row(
            children: [
              if (onFilterTap != null)
                IconButton(
                  icon: IconManager.getIcon('category_outlined', color: Theme.of(context).colorScheme.onSurfaceVariant),
                  onPressed: onFilterTap,
                  tooltip: 'Filtrer',
                ),
              if (onSearchTap != null)
                IconButton(
                  icon: IconManager.getIcon('search', color: Theme.of(context).colorScheme.onSurfaceVariant),
                  onPressed: onSearchTap,
                  tooltip: 'Rechercher',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget pour afficher un élément de culte dans une liste
class CulteListItem extends StatelessWidget {
  final String date;
  final String theme;
  final String time;
  final String? orateur;
  final bool isPast;
  final VoidCallback onTap;

  const CulteListItem({
    Key? key,
    required this.date,
    required this.theme,
    required this.time,
    this.orateur,
    required this.isPast,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.paddingMedium),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          border: Border.all(
            color: isPast ? Theme.of(context).colorScheme.surfaceVariant : Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(color: Theme.of(context).colorScheme.shadow.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Indicateur de date
                  Container(
                    padding: EdgeInsets.all(AppSizes.paddingSmall),
                    decoration: BoxDecoration(
                      color:
                          isPast
                              ? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5)
                              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Column(
                      children: [
                        Text(
                          date.split(' ')[0], // Jour
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color:
                                isPast ? Theme.of(context).colorScheme.onSurfaceVariant : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          date.split(' ')[1], // Mois
                          style: AppTextStyles.bodySmall.copyWith(
                            color:
                                isPast ? Theme.of(context).colorScheme.onSurfaceVariant : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSizes.paddingMedium),

                  // Contenu principal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          theme,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color:
                                isPast ? Theme.of(context).colorScheme.onSurfaceVariant : Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: AppSizes.paddingSmall / 2),
                        Row(
                          children: [
                            IconManager.getIcon('history', color: Theme.of(context).colorScheme.onSurfaceVariant, size: 14),
                            SizedBox(width: 4),
                            Text(
                              time,
                              style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                        if (orateur != null) ...[
                          SizedBox(height: AppSizes.paddingSmall / 2),
                          Row(
                            children: [
                              IconManager.getIcon('profile', color: Theme.of(context).colorScheme.onSurfaceVariant, size: 14),
                              SizedBox(width: 4),
                              Text(
                                orateur!,
                                style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Indicateur d'état ou action
                  Icon(
                    isPast ? Icons.check_circle_outline : Icons.arrow_forward_ios,
                    color: isPast ? Theme.of(context).colorScheme.onSurfaceVariant : Theme.of(context).colorScheme.primary,
                    size: 20,
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

/// Widget de calendrier mensuel pour visualiser les séances
class CalendrierMensuel extends StatelessWidget {
  final DateTime moisCourant;
  final List<DateTime> datesAvecSeances;
  final DateTime? dateSelectionnee;
  final Function(DateTime) onSelectDate;

  const CalendrierMensuel({
    Key? key,
    required this.moisCourant,
    required this.datesAvecSeances,
    this.dateSelectionnee,
    required this.onSelectDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calcul du premier jour du mois
    final firstDayOfMonth = DateTime(moisCourant.year, moisCourant.month, 1);

    // Décalage pour commencer au jour de la semaine approprié (0 = lundi, 6 = dimanche)
    final dayOfWeekOffset = (firstDayOfMonth.weekday - 1) % 7;

    // Nombre de jours dans le mois
    final daysInMonth = DateTime(moisCourant.year, moisCourant.month + 1, 0).day;

    // Liste des jours de la semaine (format court)
    final weekdays = ['Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa', 'Di'];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        boxShadow: [
          BoxShadow(color: Theme.of(context).colorScheme.shadow.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        children: [
          // Entête avec le mois et les contrôles de navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: IconManager.getIcon('arrow_back', size: 20),
                onPressed: () => onSelectDate(DateTime(moisCourant.year, moisCourant.month - 1, 1)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                DateFormat('MMMM yyyy', 'fr_FR').format(moisCourant),
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: IconManager.getIcon('arrow_forward', size: 20),
                onPressed: () => onSelectDate(DateTime(moisCourant.year, moisCourant.month + 1, 1)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingMedium),

          // Jours de la semaine
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                weekdays
                    .map(
                      (day) => SizedBox(
                        width: 30,
                        child: Text(
                          day,
                          style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    .toList(),
          ),
          SizedBox(height: AppSizes.paddingSmall),

          // Grille des jours
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
            itemCount: (dayOfWeekOffset + daysInMonth),
            itemBuilder: (context, index) {
              // Espaces vides pour les jours avant le début du mois
              if (index < dayOfWeekOffset) {
                return const SizedBox.shrink();
              }

              // Jours du mois
              final day = index - dayOfWeekOffset + 1;
              final date = DateTime(moisCourant.year, moisCourant.month, day);

              // Vérifier si ce jour a une séance
              final hasSeance = datesAvecSeances.any((d) => d.year == date.year && d.month == date.month && d.day == date.day);

              // Vérifier si ce jour est sélectionné
              final isSelected =
                  dateSelectionnee != null &&
                  dateSelectionnee!.year == date.year &&
                  dateSelectionnee!.month == date.month &&
                  dateSelectionnee!.day == date.day;

              // Vérifier si ce jour est aujourd'hui
              final isToday =
                  DateTime.now().year == date.year && DateTime.now().month == date.month && DateTime.now().day == date.day;

              return GestureDetector(
                onTap: () => onSelectDate(date),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Theme.of(context).colorScheme.primary
                            : hasSeance
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    border: isToday ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1) : null,
                  ),
                  child: Center(
                    child: Text(
                      day.toString(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : hasSeance
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
                        fontWeight: hasSeance || isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
