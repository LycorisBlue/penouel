import 'package:flutter/material.dart';
import 'package:penouel/core/constants/icons.dart';
import 'package:penouel/core/constants/sizes.dart';
import 'package:penouel/core/constants/texts.dart';
import 'package:penouel/services/navigation_service.dart';

/// Tiroir de navigation latéral pour l'application
/// Fournit un accès aux différentes sections de l'application
class AppDrawer extends StatelessWidget {
  final String? currentRoute;
  final String userName;
  final String userRole;
  final List<String>? userPermissions;

  const AppDrawer({
    Key? key,
    this.currentRoute,
    this.userName = 'Utilisateur',
    this.userRole = 'Membre',
    this.userPermissions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildMenuItems(context),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.surfaceVariant,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo de profil (cercle avec initiales)
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              _getInitials(userName),
              style: AppTextStyles.heading3.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          SizedBox(height: AppSizes.paddingMedium),
          
          // Nom de l'utilisateur
          Text(
            userName,
            style: AppTextStyles.heading3,
            overflow: TextOverflow.ellipsis,
          ),
          
          // Rôle de l'utilisateur
          Text(
            userRole,
            style: AppTextStyles.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    // Définition des éléments du menu
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Tableau de bord
        _DrawerMenuItem(
          icon: 'home',
          title: 'Tableau de bord',
          isSelected: currentRoute == Routes.home,
          onTap: () => _navigateTo(context, Routes.home),
        ),
        
        // Gestion des séances
        if (_hasPermission('view_seances'))
          _DrawerMenuItem(
            icon: 'calendar_today',
            title: 'Gestion des séances',
            isSelected: currentRoute == '/seances',
            onTap: () => _navigateTo(context, '/seances'),
          ),
        
        // Pointage de présence
        if (_hasPermission('view_presence'))
          _DrawerMenuItem(
            icon: 'check_circle_outline',
            title: 'Pointage de présence',
            isSelected: currentRoute == '/presence',
            onTap: () => _navigateTo(context, '/presence'),
          ),
        
        // Discipolat (membres permanents uniquement)
        if (_hasPermission('view_discipolat'))
          _DrawerMenuItem(
            icon: 'school',
            title: 'Discipolat',
            isSelected: currentRoute == '/discipolat',
            onTap: () => _navigateTo(context, '/discipolat'),
          ),
        
        // Événements & Évangélisation
        if (_hasPermission('view_events'))
          _DrawerMenuItem(
            icon: 'message',
            title: 'Événements & Évangélisation',
            isSelected: currentRoute == '/events',
            onTap: () => _navigateTo(context, '/events'),
          ),
        
        // Statistiques & Reporting
        if (_hasPermission('view_stats'))
          _DrawerMenuItem(
            icon: 'insert_chart',
            title: 'Statistiques & Reporting',
            isSelected: currentRoute == '/stats',
            onTap: () => _navigateTo(context, '/stats'),
          ),
        
        // Gestion des membres (Admin uniquement)
        if (_hasPermission('manage_users'))
          _DrawerMenuItem(
            icon: 'profile',
            title: 'Gestion des membres',
            isSelected: currentRoute == '/members',
            onTap: () => _navigateTo(context, '/members'),
          ),
        
        // Séparateur
        Divider(
          color: Theme.of(context).colorScheme.surfaceVariant,
          thickness: 1,
          height: AppSizes.paddingLarge * 2,
          indent: AppSizes.paddingLarge,
          endIndent: AppSizes.paddingLarge,
        ),
        
        // Profil utilisateur
        _DrawerMenuItem(
          icon: 'profile',
          title: 'Profil utilisateur',
          isSelected: currentRoute == '/profile',
          onTap: () => _navigateTo(context, '/profile'),
        ),
        
        // Paramètres
        _DrawerMenuItem(
          icon: 'settings',
          title: 'Paramètres',
          isSelected: currentRoute == Routes.settings,
          onTap: () => _navigateTo(context, Routes.settings),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.surfaceVariant,
            width: 1,
          ),
        ),
      ),
      child: _DrawerMenuItem(
        icon: 'logout',
        title: 'Déconnexion',
        onTap: () => _logout(context),
        isDestructive: true,
      ),
    );
  }

  // Méthode pour obtenir les initiales du nom
  String _getInitials(String name) {
    if (name.isEmpty) return '';
    
    List<String> nameParts = name.split(' ');
    String initials = '';
    
    if (nameParts.isNotEmpty) {
      if (nameParts[0].isNotEmpty) {
        initials += nameParts[0][0];
      }
      
      if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
        initials += nameParts[1][0];
      }
    }
    
    return initials.toUpperCase();
  }

  // Méthode pour vérifier si l'utilisateur a une permission donnée
  bool _hasPermission(String permission) {
    // Si aucune permission n'est définie, on considère qu'il a accès
    // Cela permet de désactiver temporairement le système de permissions
    if (userPermissions == null) return true;
    
    return userPermissions!.contains(permission);
  }

  // Méthode de navigation
  void _navigateTo(BuildContext context, String route) {
    // Fermer le drawer avant de naviguer
    Navigator.pop(context);
    
    // Naviguer vers la route demandée
    if (currentRoute != route) {
      Routes.navigateTo(route);
    }
  }

  // Méthode de déconnexion
  void _logout(BuildContext context) {
    // Fermer le drawer
    Navigator.pop(context);
    
    // Afficher une boîte de dialogue de confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Simuler une déconnexion
              Routes.navigateAndRemoveAll(Routes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}

/// Élément du menu du drawer
class _DrawerMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isDestructive;

  const _DrawerMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSelected = false,
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color textColor = isDestructive
        ? Theme.of(context).colorScheme.error
        : isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface;

    final Color backgroundColor = isSelected
        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
        : Colors.transparent;

    return Material(
      color: backgroundColor,
      child: ListTile(
        leading: IconManager.getIcon(
          icon,
          color: textColor,
          size: 22,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: textColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLarge,
          vertical: AppSizes.paddingSmall,
        ),
        horizontalTitleGap: 8,
        dense: true,
      ),
    );
  }
}