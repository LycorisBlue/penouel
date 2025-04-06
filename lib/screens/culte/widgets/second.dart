import 'package:flutter/material.dart';
import 'package:penouel/core/constants/colors.dart';
import 'package:penouel/core/constants/icons.dart';
import 'package:penouel/core/constants/sizes.dart';
import 'package:penouel/core/constants/texts.dart';
import 'package:penouel/services/navigation_service.dart';

/// Widget pour afficher les détails d'un culte
class CulteDetailView extends StatelessWidget {
  final String date;
  final String theme;
  final String time;
  final String? orateur;
  final String? lieu;
  final String? resume;
  final int? nombrePresents;
  final int? nombreTotalMembres;
  final VoidCallback? onEditTap;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onPresenceTap;
  final bool userCanEdit;

  const CulteDetailView({
    Key? key,
    required this.date,
    required this.theme,
    required this.time,
    this.orateur,
    this.lieu,
    this.resume,
    this.nombrePresents,
    this.nombreTotalMembres,
    this.onEditTap,
    this.onDeleteTap,
    this.onPresenceTap,
    this.userCanEdit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête avec date et actions
        Container(
          padding: EdgeInsets.all(AppSizes.paddingLarge),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: AppTextStyles.heading3.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  if (userCanEdit)
                    Row(
                      children: [
                        if (onEditTap != null)
                          IconButton(
                            icon: IconManager.getIcon(
                              'edit',
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 20,
                            ),
                            onPressed: onEditTap,
                            tooltip: 'Modifier',
                          ),
                        if (onDeleteTap != null)
                          IconButton(
                            icon: IconManager.getIcon(
                              'delete',
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 20,
                            ),
                            onPressed: onDeleteTap,
                            tooltip: 'Supprimer',
                          ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: AppSizes.paddingSmall),
              Text(
                time,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: AppSizes.paddingMedium),

        // Thème principal
        Container(
          padding: EdgeInsets.all(AppSizes.paddingMedium),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thème',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppSizes.paddingSmall / 2),
              Text(
                theme,
                style: AppTextStyles.heading3,
              ),
            ],
          ),
        ),

        SizedBox(height: AppSizes.paddingMedium),

        // Informations complémentaires
        Container(
          padding: EdgeInsets.all(AppSizes.paddingMedium),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (orateur != null) ...[
                _buildInfoRow(
                  context,
                  'Orateur',
                  orateur!,
                  'profile',
                ),
                SizedBox(height: AppSizes.paddingSmall),
              ],
              if (lieu != null) ...[
                _buildInfoRow(
                  context,
                  'Lieu',
                  lieu!,
                  'location_on_outlined',
                ),
                SizedBox(height: AppSizes.paddingSmall),
              ],
              if (nombrePresents != null && nombreTotalMembres != null) ...[
                _buildInfoRow(
                  context,
                  'Présence',
                  '$nombrePresents/$nombreTotalMembres membres',
                  'check_circle_outline',
                ),
                SizedBox(height: AppSizes.paddingSmall),
                LinearProgressIndicator(
                  value: nombrePresents! / nombreTotalMembres!,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  color: Theme.of(context).colorScheme.primary,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                if (onPresenceTap != null) ...[
                  SizedBox(height: AppSizes.paddingSmall),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: onPresenceTap,
                      icon: IconManager.getIcon(
                        'check',
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
                      label: Text(
                        'Gérer les présences',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),

        SizedBox(height: AppSizes.paddingMedium),

        // Résumé du message
        if (resume != null && resume!.isNotEmpty)
          Container(
            padding: EdgeInsets.all(AppSizes.paddingMedium),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Résumé du message',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: AppSizes.paddingSmall),
                Text(
                  resume!,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, String iconName) {
    return Row(
      children: [
        IconManager.getIcon(
          iconName,
          color: Theme.of(context).colorScheme.primary,
          size: 18,
        ),
        SizedBox(width: AppSizes.paddingSmall),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}

/// Widget pour le formulaire de création/modification d'un culte
class CulteFormView extends StatelessWidget {
  final TextEditingController themeController;
  final TextEditingController? lieuController;
  final TextEditingController? orateurController;
  final TextEditingController? resumeController;
  final DateTime selectedDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Function(DateTime) onDateChanged;
  final Function(TimeOfDay) onStartTimeChanged;
  final Function(TimeOfDay) onEndTimeChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final bool isLoading;
  final String actionButtonText;
  final GlobalKey<FormState> formKey;

  const CulteFormView({
    Key? key,
    required this.themeController,
    this.lieuController,
    this.orateurController,
    this.resumeController,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.onDateChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    required this.onSave,
    required this.onCancel,
    this.isLoading = false,
    this.actionButtonText = 'Enregistrer',
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sélecteurs de date et heure
          Container(
            padding: EdgeInsets.all(AppSizes.paddingMedium),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date et heure',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: AppSizes.paddingMedium),
                
                // Sélecteur de date
                InkWell(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (pickedDate != null) {
                      onDateChanged(pickedDate);
                    }
                  },
                  child: _buildSelectorField(
                    context,
                    'Date',
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    'calendar_today',
                  ),
                ),
                
                SizedBox(height: AppSizes.paddingMedium),
                
                // Sélecteurs d'heure
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: startTime,
                          );
                          if (pickedTime != null) {
                            onStartTimeChanged(pickedTime);
                          }
                        },
                        child: _buildSelectorField(
                          context,
                          'Début',
                          '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}',
                          'history',
                          false,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.paddingMedium),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: endTime,
                          );
                          if (pickedTime != null) {
                            onEndTimeChanged(pickedTime);
                          }
                        },
                        child: _buildSelectorField(
                          context,
                          'Fin',
                          '${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}',
                          'history',
                          false,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: AppSizes.paddingMedium),

          // Champs textuels
          Container(
            padding: EdgeInsets.all(AppSizes.paddingMedium),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informations du culte',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: AppSizes.paddingMedium),
                
                // Thème (obligatoire)
                TextFormField(
                  controller: themeController,
                  decoration: InputDecoration(
                    labelText: 'Thème du culte',
                    hintText: 'Ex: La puissance de la prière',
                    prefixIcon: IconManager.getIcon(
                      'title_outlined',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un thème pour le culte';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: AppSizes.paddingMedium),
                
                // Orateur (optionnel)
                if (orateurController != null)
                  TextFormField(
                    controller: orateurController,
                    decoration: InputDecoration(
                      labelText: 'Orateur',
                      hintText: 'Ex: Pasteur Thomas',
                      prefixIcon: IconManager.getIcon(
                        'profile',
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                
                if (orateurController != null)
                  SizedBox(height: AppSizes.paddingMedium),
                
                // Lieu (optionnel)
                if (lieuController != null)
                  TextFormField(
                    controller: lieuController,
                    decoration: InputDecoration(
                      labelText: 'Lieu',
                      hintText: 'Ex: Salle principale',
                      prefixIcon: IconManager.getIcon(
                        'location_on_outlined',
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: AppSizes.paddingMedium),

          // Résumé (optionnel)
          if (resumeController != null)
            Container(
              padding: EdgeInsets.all(AppSizes.paddingMedium),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Résumé du message',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingMedium),
                  TextFormField(
                    controller: resumeController,
                    decoration: InputDecoration(
                      hintText: 'Saisissez un résumé du message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                      ),
                    ),
                    maxLines: 5,
                    minLines: 3,
                  ),
                ],
              ),
            ),

          SizedBox(height: AppSizes.paddingLarge),

          // Boutons d'action
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isLoading ? null : onCancel,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.paddingMedium),
                  ),
                  child: Text('Annuler'),
                ),
              ),
              SizedBox(width: AppSizes.paddingMedium),
              Expanded(
                child: ElevatedButton(
                  onPressed: isLoading ? null : onSave,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.paddingMedium),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(actionButtonText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorField(BuildContext context, String label, String value, String iconName, [bool fullWidth = true]) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.paddingSmall,
        horizontal: AppSizes.paddingMedium,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Row(
        children: [
          IconManager.getIcon(
            iconName,
            color: Theme.of(context).colorScheme.primary,
            size: 18,
          ),
          SizedBox(width: AppSizes.paddingSmall),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget pour afficher un message quand aucun culte n'est disponible
class EmptyCulteView extends StatelessWidget {
  final VoidCallback? onCreateTap;
  final bool canCreate;

  const EmptyCulteView({
    Key? key,
    this.onCreateTap,
    this.canCreate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconManager.getIconData('calendar_today'),
            size: 60,
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'Aucune séance disponible',
            style: AppTextStyles.heading3.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Text(
            'Il n\'y a aucune séance programmée pour le moment.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (canCreate && onCreateTap != null) ...[
            SizedBox(height: AppSizes.paddingLarge),
            ElevatedButton.icon(
              onPressed: onCreateTap,
              icon: Icon(Icons.add),
              label: Text('Créer une séance'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingLarge,
                  vertical: AppSizes.paddingMedium,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}