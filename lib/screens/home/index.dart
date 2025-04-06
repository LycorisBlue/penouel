import 'package:flutter/material.dart';
import 'package:penouel/core/constants/icons.dart';
import 'package:penouel/core/constants/sizes.dart';
import 'package:penouel/core/constants/texts.dart';
import 'package:penouel/services/navigation_service.dart';
import 'package:penouel/widgets/app_drawer.dart';
import 'widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Données utilisées pour afficher le contenu (simulées pour l'interface)
  final String _userName = "Fulgence MEDI";
  final List<String> _userPermissions = ['view_seances', 'view_presence', 'view_discipolat', 'view_events', 'view_stats'];

  // Exemples de données pour les statistiques
  final int _totalMembers = 120;
  final int _presentMembers = 85;
  final double _attendanceRate = 70.8;

  // Exemple de données pour les événements
  final List<EventItem> _upcomingEvents = [
    EventItem(
      title: "Rassemblement de prière",
      date: "18 avril 2025 - 18:30",
      location: "Salle principale",
      description: "Réunion pour intercéder et prier ensemble pour notre communauté.",
    ),
    EventItem(
      title: "Sortie d'évangélisation",
      date: "20 avril 2025 - 14:00",
      location: "Place centrale",
      description: "Distribution de tracts et partage de la Parole avec les passants.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Initialiser les tailles responsives
    AppSizes.initialize(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord', style: AppTextStyles.heading3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Action pour afficher les notifications
            },
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: Routes.home,
        userName: _userName,
        userRole: 'Membre permanent',
        userPermissions: _userPermissions,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action rapide principale (peut être configurée selon le rôle)
          _showQuickActionDialog();
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshDashboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bannière de bienvenue
                WelcomeBanner(userName: _userName),

                SizedBox(height: AppSizes.paddingLarge),

                // Prochaine séance
                NextSessionCard(
                  date: "Dimanche 13 avril 2025",
                  theme: "La force de la prière communautaire",
                  time: "10:00 - 12:00",
                  speaker: "Pasteur Thomas",
                ),

                SizedBox(height: AppSizes.paddingLarge),

                // Statistiques de présence
                if (_userPermissions.contains('view_stats')) ...[
                  AttendanceStatsCard(
                    totalMembers: _totalMembers,
                    presentMembers: _presentMembers,
                    attendanceRate: _attendanceRate,
                  ),

                  SizedBox(height: AppSizes.paddingLarge),
                ],

                // Titre de section Accès rapide
                Text("Accès rapide", style: AppTextStyles.heading3),

                SizedBox(height: AppSizes.paddingMedium),

                // Grille d'accès rapide
                QuickAccessGrid(items: _getQuickAccessItems()),

                SizedBox(height: AppSizes.paddingLarge),

                // Événements à venir
                if (_userPermissions.contains('view_events')) ...[
                  UpcomingEventsCard(events: _upcomingEvents),

                  SizedBox(height: AppSizes.paddingLarge),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Séances'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Présence'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {
          // Navigation entre les écrans principaux
          _handleBottomNavigation(index);
        },
      ),
    );
  }

  // Génère les éléments d'accès rapide en fonction des permissions de l'utilisateur
  List<QuickAccessItem> _getQuickAccessItems() {
    List<QuickAccessItem> items = [];

    // Séances
    if (_userPermissions.contains('view_seances')) {
      items.add(QuickAccessItem(icon: 'calendar_today', label: 'Séances', onTap: () => Routes.navigateTo('/seances')));
    }

    // Présence
    if (_userPermissions.contains('view_presence')) {
      items.add(QuickAccessItem(icon: 'check_circle_outline', label: 'Présence', onTap: () => Routes.navigateTo('/presence')));
    }

    // Discipolat
    if (_userPermissions.contains('view_discipolat')) {
      items.add(QuickAccessItem(icon: 'school', label: 'Discipolat', onTap: () => Routes.navigateTo('/discipolat')));
    }

    // Événements
    if (_userPermissions.contains('view_events')) {
      items.add(QuickAccessItem(icon: 'message', label: 'Événements', onTap: () => Routes.navigateTo('/events')));
    }

    // Statistiques
    if (_userPermissions.contains('view_stats')) {
      items.add(QuickAccessItem(icon: 'insert_chart', label: 'Statistiques', onTap: () => Routes.navigateTo('/stats')));
    }

    // Profil
    items.add(QuickAccessItem(icon: 'profile', label: 'Profil', onTap: () => Routes.navigateTo('/profile')));

    return items;
  }

  // Gère la navigation via la barre inférieure
  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        // Déjà sur l'accueil
        break;
      case 1:
        Routes.navigateTo('/seances');
        break;
      case 2:
        Routes.navigateTo('/presence');
        break;
      case 3:
        Routes.navigateTo('/profile');
        break;
    }
  }

  // Dialogue pour les actions rapides
  void _showQuickActionDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder:
          (context) => Container(
            padding: EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Actions rapides', style: AppTextStyles.heading3, textAlign: TextAlign.center),
                const Divider(),
                if (_userPermissions.contains('view_seances'))
                  _buildQuickActionItem(context, 'Créer une séance', 'calendar_today', () {
                    Navigator.pop(context);
                    Routes.navigateTo('/seances/create');
                  }),
                if (_userPermissions.contains('view_presence'))
                  _buildQuickActionItem(context, 'Pointer présence', 'check_circle_outline', () {
                    Navigator.pop(context);
                    Routes.navigateTo('/presence/add');
                  }),
                if (_userPermissions.contains('view_events'))
                  _buildQuickActionItem(context, 'Créer un événement', 'message', () {
                    Navigator.pop(context);
                    Routes.navigateTo('/events/create');
                  }),
                if (_userPermissions.contains('view_discipolat'))
                  _buildQuickActionItem(context, 'Évaluer un disciple', 'school', () {
                    Navigator.pop(context);
                    Routes.navigateTo('/discipolat/evaluate');
                  }),
              ],
            ),
          ),
    );
  }

  // Élément de la liste des actions rapides
  Widget _buildQuickActionItem(BuildContext context, String title, String icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(IconManager.getIconData(icon), color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(vertical: AppSizes.paddingSmall, horizontal: AppSizes.paddingMedium),
    );
  }

  // Simulation de rafraîchissement des données
  Future<void> _refreshDashboard() async {
    // Simuler un chargement
    await Future.delayed(const Duration(seconds: 1));

    // Dans une vraie application, vous rechargeriez les données ici
    if (mounted) {
      setState(() {
        // Mettre à jour les données si nécessaire
      });
    }
  }
}
