import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../services/course_service.dart';
import '../services/session_service.dart';
import '../models/user.dart';
import '../models/course.dart';
import '../models/session.dart';
import '../widgets/active_session_timer.dart';
import '../l10n/app_localizations.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final CourseService _courseService = CourseService();
  final SessionService _sessionService = SessionService();

  late TabController _tabController;
  User? _currentUser;
  bool _isLoading = true;
  int _activeSessionsKey = 0; // Clé pour forcer le rebuild

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    final user = await _authService.getSavedUser();
    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.logoutConfirmTitle),
        content: Text(AppLocalizations.of(context)!.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: Text(AppLocalizations.of(context)!.logout, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.logout();
      if (mounted) {
        context.go('/choice');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.teacherHomeTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00609C),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _handleLogout,
            tooltip: AppLocalizations.of(context)!.logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                const CoursesTab(),
                ActiveSessionsTab(
                  key: ValueKey(_activeSessionsKey),
                  onRefresh: () {
                    setState(() {
                      _activeSessionsKey++;
                    });
                  },
                ),
                const SessionsTab(),
              ],
            ),
      bottomNavigationBar: Container(
        color: const Color(0xFF00609C),
        child: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFF6731F),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.map), text: 'Parcours'),
            Tab(icon: Icon(Icons.play_circle), text: 'En cours'),
            Tab(icon: Icon(Icons.directions_run), text: 'Courses'),
          ],
        ),
      ),
    );
  }
}

// Tab Courses Actives (En cours)
class ActiveSessionsTab extends StatefulWidget {
  final VoidCallback? onRefresh;

  const ActiveSessionsTab({super.key, this.onRefresh});

  @override
  State<ActiveSessionsTab> createState() => _ActiveSessionsTabState();
}

class _ActiveSessionsTabState extends State<ActiveSessionsTab> {
  final SessionService _sessionService = SessionService();
  List<Session> _activeSessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActiveSessions();
  }

  Future<void> _loadActiveSessions() async {
    setState(() => _isLoading = true);
    try {
      final sessions = await _sessionService.getActiveSessions();
      setState(() {
        _activeSessions = sessions;
        _isLoading = false;
      });
      print('✅ ${_activeSessions.length} courses actives chargées');
    } catch (e) {
      print('❌ Erreur chargement courses actives: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _endSession(Session session) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terminer la course'),
        content: Text('Terminer la course "${session.sessionName}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Terminer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _sessionService.endSession(session.id);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Course terminée')));
          _loadActiveSessions();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_activeSessions.isEmpty) {
      return Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_available, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Aucune course en cours',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Créez une nouvelle course pour commencer',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Bouton "Créer une course" fixé en bas
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await context.push(
                      '/teacher-create-session',
                    );
                    // Recharger en forçant un rebuild complet
                    print('🔄 Retour création course, result: $result');
                    await Future.delayed(const Duration(milliseconds: 300));
                    if (mounted) {
                      widget.onRefresh?.call();
                    }
                  },
                  icon: const Icon(Icons.add, size: 28),
                  label: const Text('Créer une course'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6731F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 32,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _loadActiveSessions,
          child: ListView.builder(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 100, // Espace pour le bouton
            ),
            itemCount: _activeSessions.length,
            itemBuilder: (context, index) {
              final session = _activeSessions[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    context.push('/teacher/course-placement', extra: session);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_circle,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session.sessionName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (session.courseName != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      session.courseName!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'EN COURS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${session.nbRunner} participant(s)',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.access_time,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            if (session.sessionStart != null)
                              _SimpleTimer(startTime: session.sessionStart!)
                            else
                              const Text(
                                'Pas de date',
                                style: TextStyle(color: Colors.red),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _endSession(session),
                              icon: const Icon(Icons.stop, size: 18),
                              label: const Text('Terminer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.push(
                                  '/teacher/course-placement',
                                  extra: session,
                                );
                              },
                              icon: const Icon(Icons.visibility, size: 18),
                              label: const Text('Voir'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00609C),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                  ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Bouton "Créer une course" fixé en bas
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await context.push('/teacher-create-session');
                  // Forcer un rebuild complet
                  await Future.delayed(const Duration(milliseconds: 300));
                  if (mounted) {
                    widget.onRefresh?.call();
                  }
                },
                icon: const Icon(Icons.add, size: 28),
                label: const Text('Créer une course'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6731F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 32,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Tab Sessions
class SessionsTab extends StatefulWidget {
  const SessionsTab({super.key});

  @override
  State<SessionsTab> createState() => _SessionsTabState();
}

class _SessionsTabState extends State<SessionsTab> {
  final SessionService _sessionService = SessionService();
  List<Session> _sessions = [];
  List<Session> _activeSessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() => _isLoading = true);
    try {
      final sessions = await _sessionService.getSessions();
      setState(() {
        // Afficher uniquement les courses terminées (sessionEnd != null)
        _sessions = sessions.where((s) => s.sessionEnd != null).toList();
        _activeSessions = sessions.where((s) => s.isActive).toList();
        _isLoading = false;
      });
      print('📋 ${_sessions.length} courses terminées chargées');
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.error(e)), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _showCloseSessionDialog(Session session) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.closeSession),
        content: Text(
          AppLocalizations.of(context)!.closeSessionConfirm(session.sessionName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final success = await _sessionService.closeSession(session.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.sessionClosed),
            backgroundColor: Colors.green,
          ),
        );
        await _loadSessions();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.closeSessionError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // _sessions contient déjà uniquement les courses terminées (filtrées dans _loadSessions)
    final completedSessions = _sessions;

    if (completedSessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: const Color(0xFF00609C).withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucune course terminée',
              style: TextStyle(fontSize: 18, color: Color(0xFF00609C)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSessions,
      child: ListView.builder(
        padding: const EdgeInsets.only(
          top: 8,
          left: 16,
          right: 16,
          bottom: 100,
        ),
        itemCount: completedSessions.length,
        itemBuilder: (context, index) {
          final session = completedSessions[index];
          final duration = session.sessionEnd!.difference(
            session.sessionStart!,
          );
          final hours = duration.inHours;
          final minutes = duration.inMinutes.remainder(60);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check_circle, color: Colors.green),
              ),
              title: Text(
                session.sessionName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${session.nbRunner} participant(s)'),
                  Text(
                    'Durée: ${hours}h ${minutes}min',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigation vers détails session
              },
            ),
          );
        },
      ),
    );
  }
}

// Tab Parcours
class CoursesTab extends StatefulWidget {
  const CoursesTab({super.key});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  final CourseService _courseService = CourseService();
  List<Course> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);
    try {
      final courses = await _courseService.getCourses();
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.error(e)), backgroundColor: Colors.red),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'draft':
        return Colors.orange; // Brouillon = Orange
      case 'placement_ready':
        return Colors.orange; // Placement en cours = Orange
      case 'ready':
        return Colors.green; // Prêt = Vert
      case 'in_progress':
        return Colors.blue; // En cours = Bleu
      case 'completed':
        return Colors.green; // Terminé = Vert
      case 'finished':
        return Colors.red; // Archivé = Rouge
      default:
        return const Color(0xFF00609C);
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'draft':
        return AppLocalizations.of(context)!.draft;
      case 'placement_ready':
        return AppLocalizations.of(context)!.placementInProgress;
      case 'ready':
        return AppLocalizations.of(context)!.ready;
      case 'in_progress':
        return AppLocalizations.of(context)!.inProgress;
      case 'completed':
        return AppLocalizations.of(context)!.completed;
      case 'finished':
        return AppLocalizations.of(context)!.archived;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 80,
              color: const Color(0xFF00609C).withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noCourses,
              style: const TextStyle(fontSize: 18, color: Color(0xFF00609C)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCourses,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(course.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.map, color: _getStatusColor(course.status)),
              ),
              title: Text(
                course.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(course.description),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(course.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(course.status),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(course.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                // Point 4: Attendre le retour et recharger les cours
                await context.push('/teacher-course-placement', extra: course);
                // Recharger la liste apr\u00e8s le retour
                _loadCourses();
              },
            ),
          );
        },
      ),
    );
  }
}

// Widget Timer Simple sans rebuild constant
class _SimpleTimer extends StatefulWidget {
  final DateTime startTime;

  const _SimpleTimer({required this.startTime});

  @override
  State<_SimpleTimer> createState() => _SimpleTimerState();
}

class _SimpleTimerState extends State<_SimpleTimer> {
  late Timer _timer;
  String _timeString = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _updateTime();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final duration = DateTime.now().difference(widget.startTime);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    if (mounted) {
      setState(() {
        _timeString = '$hours:$minutes:$seconds';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeString,
      style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600),
    );
  }
}
