import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../services/course_service.dart';
import '../services/session_service.dart';
import '../models/user.dart';
import '../models/course.dart';
import '../models/session.dart';
import '../widgets/active_session_timer.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final CourseService _courseService = CourseService();
  final SessionService _sessionService = SessionService();
  
  late TabController _tabController;
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
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
        title: const Text(
          'Espace Professeur',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00609C),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _handleLogout,
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: const [
                SessionsTab(),
                CoursesTab(),
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
            Tab(icon: Icon(Icons.directions_run), text: 'Courses'),
            Tab(icon: Icon(Icons.map), text: 'Parcours'),
          ],
        ),
      ),
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
        _sessions = sessions;
        // Trouver toutes les sessions actives (sessionStart != null ET sessionEnd == null)
        _activeSessions = sessions.where((s) => s.isActive).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _createSession() async {
    final result = await context.push('/teacher-create-session');
    if (result != null && result is Session) {
      // Recharger la liste
      await _loadSessions();
    }
  }

  Future<void> _showCloseSessionDialog(Session session) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clôturer la session'),
        content: Text(
          'Voulez-vous vraiment clôturer la session "${session.sessionName}" ?\n\nCette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clôturer'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final success = await _sessionService.closeSession(session.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Session clôturée'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadSessions();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la clôture'),
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

    final completedSessions = _sessions.where((s) => s.isCompleted).toList();

    return Stack(
      children: [
        // Contenu principal
        Column(
          children: [
            // Sessions actives (afficher toutes les sessions actives)
            if (_activeSessions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 100),
                  itemCount: _activeSessions.length,
                  itemBuilder: (context, index) {
                    return ActiveSessionTimer(
                      session: _activeSessions[index],
                      onTap: () => _showCloseSessionDialog(_activeSessions[index]),
                    );
                  },
                ),
              ),

            // Si pas de sessions actives, afficher les sessions terminées
            if (_activeSessions.isEmpty)
              Expanded(
                child: completedSessions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, size: 80, color: const Color(0xFF00609C).withValues(alpha: 0.5)),
                            const SizedBox(height: 16),
                            const Text(
                              'Aucune course terminée',
                              style: TextStyle(fontSize: 18, color: Color(0xFF00609C)),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadSessions,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 100),
                          itemCount: completedSessions.length,
                          itemBuilder: (context, index) {
                            final session = completedSessions[index];
                            final duration = session.sessionEnd!.difference(session.sessionStart!);
                            final hours = duration.inHours;
                            final minutes = duration.inMinutes.remainder(60);

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      ),
              ),
          ],
        ),

        // Bouton "Créer une session" fixé en bas et centré
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
                onPressed: _createSession,
                icon: const Icon(Icons.add, size: 28),
                label: const Text('Créer une course'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6731F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
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
        return 'Brouillon';
      case 'placement_ready':
        return 'Placement en cours';
      case 'ready':
        return 'Prêt';
      case 'in_progress':
        return 'En cours';
      case 'completed':
        return 'Terminé';
      case 'finished':
        return 'Archivé';
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
            Icon(Icons.inbox, size: 80, color: const Color(0xFF00609C).withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'Aucun parcours',
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
