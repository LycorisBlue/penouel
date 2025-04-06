import 'package:flutter/material.dart';
import 'package:penouel/core/constants/sizes.dart';
import 'package:penouel/core/constants/texts.dart';
import 'package:penouel/core/utils/snackbar_utils.dart';
import 'package:penouel/screens/culte/widgets/first.dart';
import 'package:penouel/screens/culte/widgets/second.dart';
import 'package:penouel/services/navigation_service.dart';
import 'package:penouel/widgets/app_drawer.dart';

class CulteScreen extends StatefulWidget {
  const CulteScreen({Key? key}) : super(key: key);

  @override
  State<CulteScreen> createState() => _CulteScreenState();
}

class _CulteScreenState extends State<CulteScreen> {
  // Controllers pour le formulaire
  final TextEditingController _themeController = TextEditingController();
  final TextEditingController _orateurController = TextEditingController();
  final TextEditingController _lieuController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // État de l'écran
  CulteScreenMode _currentMode = CulteScreenMode.list;
  bool _isLoading = false;
  bool _showCalendar = false;
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  int? _selectedCulteId;

  // Données simulées
  final List<Map<String, dynamic>> _cultes = [
    {
      'id': 1,
      'date': DateTime.now().add(const Duration(days: 2)),
      'theme': 'L\'importance de la prière communautaire',
      'heure_debut': const TimeOfDay(hour: 10, minute: 0),
      'heure_fin': const TimeOfDay(hour: 12, minute: 0),
      'orateur': 'Pasteur Thomas',
      'lieu': 'Salle principale',
      'resume': 'Un message sur l\'importance de la prière en communauté et son impact sur la vie spirituelle.',
      'nombre_presents': null,
      'nombre_total': 120,
    },
    {
      'id': 2,
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'theme': 'La foi qui déplace les montagnes',
      'heure_debut': const TimeOfDay(hour: 10, minute: 0),
      'heure_fin': const TimeOfDay(hour: 12, minute: 0),
      'orateur': 'Évangéliste Paul',
      'lieu': 'Salle principale',
      'resume': 'Exploration biblique du concept de foi et comment l\'appliquer dans notre vie quotidienne.',
      'nombre_presents': 78,
      'nombre_total': 120,
    },
    {
      'id': 3,
      'date': DateTime.now().add(const Duration(days: 9)),
      'theme': 'Être sel et lumière dans le monde',
      'heure_debut': const TimeOfDay(hour: 10, minute: 0),
      'heure_fin': const TimeOfDay(hour: 12, minute: 0),
      'orateur': 'Frère Jacques',
      'lieu': 'Salle principale',
      'resume': '',
      'nombre_presents': null,
      'nombre_total': 120,
    },
  ];

  // Permissions de l'utilisateur (simulées)
  final List<String> _userPermissions = ['view_seances', 'create_seances', 'edit_seances', 'view_presence'];

  @override
  void dispose() {
    _themeController.dispose();
    _orateurController.dispose();
    _lieuController.dispose();
    _resumeController.dispose();
    super.dispose();
  }

  // Vérifier les permissions de l'utilisateur
  bool _hasPermission(String permission) {
    return _userPermissions.contains(permission);
  }

  // Obtenir la liste des dates qui ont des séances
  List<DateTime> _getDatesAvecSeances() {
    return _cultes.map((culte) => culte['date'] as DateTime).toList();
  }

  // Obtenir les cultes pour une date spécifique
  List<Map<String, dynamic>> _getCultesForDate(DateTime date) {
    return _cultes.where((culte) {
      final culteDate = culte['date'] as DateTime;
      return culteDate.year == date.year && culteDate.month == date.month && culteDate.day == date.day;
    }).toList();
  }

  // Obtenir un culte par son id
  Map<String, dynamic>? _getCulteById(int id) {
    try {
      return _cultes.firstWhere((culte) => culte['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Formatter le temps pour l'affichage
  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Formatter la date pour l'affichage dans la liste
  String _formatDateForList(DateTime date) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return "Aujourd'hui";
    } else if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return "Demain";
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return "Hier";
    } else {
      // Format: "15 Avril" (ou autre format selon vos préférences)
      final monthNames = [
        'Janvier',
        'Février',
        'Mars',
        'Avril',
        'Mai',
        'Juin',
        'Juillet',
        'Août',
        'Septembre',
        'Octobre',
        'Novembre',
        'Décembre',
      ];
      return '${date.day} ${monthNames[date.month - 1]}';
    }
  }

  // Formatter la date complète pour l'affichage détaillé
  String _formatDateFull(DateTime date) {
    final dayNames = ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'];
    final monthNames = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];

    return '${dayNames[date.weekday % 7]} ${date.day} ${monthNames[date.month - 1]} ${date.year}';
  }

  // Vérifier si une date est dans le passé
  bool _isDateInPast(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(DateTime(now.year, now.month, now.day));
  }

  // Formater les heures pour affichage
  String _formatTimeRange(TimeOfDay start, TimeOfDay end) {
    return '${_formatTimeOfDay(start)} - ${_formatTimeOfDay(end)}';
  }

  // Initialiser le formulaire avec les valeurs d'un culte existant
  void _initFormWithCulte(Map<String, dynamic> culte) {
    _themeController.text = culte['theme'];
    _orateurController.text = culte['orateur'] ?? '';
    _lieuController.text = culte['lieu'] ?? '';
    _resumeController.text = culte['resume'] ?? '';
    _selectedDate = culte['date'];
  }

  // Réinitialiser le formulaire
  void _resetForm() {
    _themeController.clear();
    _orateurController.clear();
    _lieuController.clear();
    _resumeController.clear();
    _selectedDate = DateTime.now();
  }

  // Sauvegarder un culte (création ou modification)
  void _saveCulte() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // Simuler un délai réseau
    Future.delayed(const Duration(seconds: 1), () {
      if (_currentMode == CulteScreenMode.create) {
        // Ajouter un nouveau culte
        final newCulte = {
          'id': _cultes.length + 1,
          'date': _selectedDate,
          'theme': _themeController.text,
          'heure_debut': const TimeOfDay(hour: 10, minute: 0),
          'heure_fin': const TimeOfDay(hour: 12, minute: 0),
          'orateur': _orateurController.text.isNotEmpty ? _orateurController.text : null,
          'lieu': _lieuController.text.isNotEmpty ? _lieuController.text : null,
          'resume': _resumeController.text.isNotEmpty ? _resumeController.text : null,
          'nombre_presents': null,
          'nombre_total': 120,
        };

        _cultes.add(newCulte);

        if (mounted) {
          SnackBarUtils.showSuccess(context, 'Culte créé avec succès');
          setState(() {
            _isLoading = false;
            _currentMode = CulteScreenMode.list;
          });
        }
      } else if (_currentMode == CulteScreenMode.edit && _selectedCulteId != null) {
        // Modifier un culte existant
        final index = _cultes.indexWhere((c) => c['id'] == _selectedCulteId);
        if (index != -1) {
          _cultes[index]['theme'] = _themeController.text;
          _cultes[index]['date'] = _selectedDate;
          _cultes[index]['orateur'] = _orateurController.text.isNotEmpty ? _orateurController.text : null;
          _cultes[index]['lieu'] = _lieuController.text.isNotEmpty ? _lieuController.text : null;
          _cultes[index]['resume'] = _resumeController.text.isNotEmpty ? _resumeController.text : null;

          if (mounted) {
            SnackBarUtils.showSuccess(context, 'Culte modifié avec succès');
            setState(() {
              _isLoading = false;
              _currentMode = CulteScreenMode.detail;
            });
          }
        }
      }
    });
  }

  // Gérer la navigation via la barre inférieure
  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        Routes.navigateTo(Routes.home);
        break;
      case 1:
        // Déjà sur l'écran des séances
        break;
      case 2:
        Routes.navigateTo('/presence');
        break;
      case 3:
        Routes.navigateTo('/profile');
        break;
    }
  }

  // Supprimer un culte
  void _deleteCulte(int id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Êtes-vous sûr de vouloir supprimer ce culte ?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _cultes.removeWhere((culte) => culte['id'] == id);
                    _currentMode = CulteScreenMode.list;
                    _selectedCulteId = null;
                  });
                  SnackBarUtils.showSuccess(context, 'Culte supprimé avec succès');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: const Text('Supprimer'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialiser les tailles responsives
    AppSizes.initialize(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(), style: AppTextStyles.heading3),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer()),
        ),
        actions: _getAppBarActions(),
      ),
      drawer: AppDrawer(
        currentRoute: '/seances',
        userName: 'Fulgence MEDI',
        userRole: 'Membre permanent',
        userPermissions: _userPermissions,
      ),
      floatingActionButton:
          _hasPermission('create_seances') && _currentMode == CulteScreenMode.list
              ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _currentMode = CulteScreenMode.create;
                    _resetForm();
                  });
                },
                child: const Icon(Icons.add),
              )
              : null,
      body: SafeArea(child: Padding(padding: EdgeInsets.all(AppSizes.paddingLarge), child: _buildContent())),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Position 1 pour l'écran des séances
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

  // Construire le contenu principal en fonction du mode
  Widget _buildContent() {
    switch (_currentMode) {
      case CulteScreenMode.list:
        return _buildListView();
      case CulteScreenMode.detail:
        return _buildDetailView();
      case CulteScreenMode.create:
      case CulteScreenMode.edit:
        return _buildFormView();
    }
  }

  // Obtenir le titre de l'AppBar en fonction du mode
  String _getAppBarTitle() {
    switch (_currentMode) {
      case CulteScreenMode.list:
        return 'Gestion des Cultes';
      case CulteScreenMode.detail:
        return 'Détails du Culte';
      case CulteScreenMode.create:
        return 'Nouveau Culte';
      case CulteScreenMode.edit:
        return 'Modifier le Culte';
    }
  }

  // Obtenir les actions de l'AppBar en fonction du mode
  List<Widget> _getAppBarActions() {
    if (_currentMode == CulteScreenMode.list) {
      return [
        IconButton(
          icon: Icon(_showCalendar ? Icons.list : Icons.calendar_month),
          onPressed: () {
            setState(() {
              _showCalendar = !_showCalendar;
            });
          },
          tooltip: _showCalendar ? 'Afficher la liste' : 'Afficher le calendrier',
        ),
      ];
    } else if (_currentMode == CulteScreenMode.detail) {
      return [];
    } else {
      return [];
    }
  }

  // Construire la vue liste
  Widget _buildListView() {
    if (_cultes.isEmpty) {
      return EmptyCulteView(
        canCreate: _hasPermission('create_seances'),
        onCreateTap:
            _hasPermission('create_seances')
                ? () {
                  setState(() {
                    _currentMode = CulteScreenMode.create;
                    _resetForm();
                  });
                }
                : null,
      );
    }

    return Column(
      children: [
        CulteHeader(
          title: _showCalendar ? 'Calendrier' : 'Liste des cultes',
          onFilterTap: () {
            // Implémenter le filtrage
          },
          onSearchTap: () {
            // Implémenter la recherche
          },
        ),

        SizedBox(height: AppSizes.paddingMedium),

        if (_showCalendar) ...[
          CalendrierMensuel(
            moisCourant: _currentMonth,
            datesAvecSeances: _getDatesAvecSeances(),
            dateSelectionnee: _selectedDate,
            onSelectDate: (date) {
              setState(() {
                _selectedDate = date;
                _currentMonth = DateTime(date.year, date.month, 1);
              });
            },
          ),

          SizedBox(height: AppSizes.paddingMedium),

          // Titre pour les cultes de la date sélectionnée
          Text(
            'Cultes du ${_formatDateFull(_selectedDate)}',
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),

          SizedBox(height: AppSizes.paddingSmall),

          // Liste des cultes pour la date sélectionnée
          Expanded(
            child:
                _getCultesForDate(_selectedDate).isEmpty
                    ? Center(child: Text('Aucun culte prévu pour cette date'))
                    : ListView.builder(
                      itemCount: _getCultesForDate(_selectedDate).length,
                      itemBuilder: (context, index) {
                        final culte = _getCultesForDate(_selectedDate)[index];
                        return CulteListItem(
                          date: _formatDateForList(culte['date']),
                          theme: culte['theme'],
                          time: _formatTimeRange(culte['heure_debut'], culte['heure_fin']),
                          orateur: culte['orateur'],
                          isPast: _isDateInPast(culte['date']),
                          onTap: () {
                            setState(() {
                              _selectedCulteId = culte['id'];
                              _currentMode = CulteScreenMode.detail;
                            });
                          },
                        );
                      },
                    ),
          ),
        ] else ...[
          // Liste de tous les cultes
          Expanded(
            child: ListView.builder(
              itemCount: _cultes.length,
              itemBuilder: (context, index) {
                final culte = _cultes[index];
                return CulteListItem(
                  date: _formatDateForList(culte['date']),
                  theme: culte['theme'],
                  time: _formatTimeRange(culte['heure_debut'], culte['heure_fin']),
                  orateur: culte['orateur'],
                  isPast: _isDateInPast(culte['date']),
                  onTap: () {
                    setState(() {
                      _selectedCulteId = culte['id'];
                      _currentMode = CulteScreenMode.detail;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  // Construire la vue détaillée
  Widget _buildDetailView() {
    final culte = _getCulteById(_selectedCulteId!);

    if (culte == null) {
      // Gérer le cas où le culte n'existe pas
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Ce culte n\'existe plus ou a été supprimé.'),
            SizedBox(height: AppSizes.paddingMedium),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentMode = CulteScreenMode.list;
                });
              },
              child: const Text('Retour à la liste'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bouton de retour en haut
          TextButton.icon(
            onPressed: () {
              setState(() {
                _currentMode = CulteScreenMode.list;
              });
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Retour à la liste'),
          ),

          SizedBox(height: AppSizes.paddingMedium),

          // Vue détaillée du culte
          CulteDetailView(
            date: _formatDateFull(culte['date']),
            theme: culte['theme'],
            time: _formatTimeRange(culte['heure_debut'], culte['heure_fin']),
            orateur: culte['orateur'],
            lieu: culte['lieu'],
            resume: culte['resume'],
            nombrePresents: culte['nombre_presents'],
            nombreTotalMembres: culte['nombre_total'],
            userCanEdit: _hasPermission('edit_seances'),
            onEditTap:
                _hasPermission('edit_seances')
                    ? () {
                      setState(() {
                        _currentMode = CulteScreenMode.edit;
                        _initFormWithCulte(culte);
                      });
                    }
                    : null,
            onDeleteTap: _hasPermission('edit_seances') ? () => _deleteCulte(culte['id']) : null,
            onPresenceTap:
                _hasPermission('view_presence')
                    ? () {
                      // Naviguer vers l'écran de présence pour ce culte
                      Routes.navigateTo('/presence?culteId=${culte['id']}');
                    }
                    : null,
          ),
        ],
      ),
    );
  }

  // Construire la vue formulaire
  Widget _buildFormView() {
    final isEditMode = _currentMode == CulteScreenMode.edit;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bouton de retour en haut
          TextButton.icon(
            onPressed: () {
              setState(() {
                _currentMode = isEditMode ? CulteScreenMode.detail : CulteScreenMode.list;
              });
            },
            icon: const Icon(Icons.arrow_back),
            label: Text('Retour ${isEditMode ? 'aux détails' : 'à la liste'}'),
          ),

          SizedBox(height: AppSizes.paddingMedium),

          // Formulaire
          CulteFormView(
            themeController: _themeController,
            orateurController: _orateurController,
            lieuController: _lieuController,
            resumeController: _resumeController,
            selectedDate: _selectedDate,
            startTime: const TimeOfDay(hour: 10, minute: 0),
            endTime: const TimeOfDay(hour: 12, minute: 0),
            onDateChanged: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
            onStartTimeChanged: (time) {
              // Implémenter le changement d'heure de début
            },
            onEndTimeChanged: (time) {
              // Implémenter le changement d'heure de fin
            },
            onSave: _saveCulte,
            onCancel: () {
              setState(() {
                _currentMode = isEditMode ? CulteScreenMode.detail : CulteScreenMode.list;
              });
            },
            isLoading: _isLoading,
            actionButtonText: isEditMode ? 'Mettre à jour' : 'Créer',
            formKey: _formKey,
          ),
        ],
      ),
    );
  }
}

// Énumération pour les différents modes d'affichage
enum CulteScreenMode { list, detail, create, edit }
