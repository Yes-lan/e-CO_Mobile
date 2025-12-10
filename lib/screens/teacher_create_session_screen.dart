import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../services/session_service.dart';
import '../generated/l10n/app_localizations.dart';

class TeacherCreateSessionScreen extends StatefulWidget {
  const TeacherCreateSessionScreen({super.key});

  @override
  State<TeacherCreateSessionScreen> createState() => _TeacherCreateSessionScreenState();
}

class _TeacherCreateSessionScreenState extends State<TeacherCreateSessionScreen> {
  final CourseService _courseService = CourseService();
  final SessionService _sessionService = SessionService();
  final TextEditingController _nameController = TextEditingController();
  
  List<Course> _readyCourses = [];
  Course? _selectedCourse;
  bool _isLoading = true;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _loadReadyCourses();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadReadyCourses() async {
    setState(() => _isLoading = true);
    try {
      final courses = await _courseService.getCourses();
      // Filtrer seulement les parcours "ready"
      final readyCourses = courses
          .where((c) => c.status == 'ready')
          .toList();
      
      setState(() {
        _readyCourses = readyCourses;
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

  Future<void> _createAndStartSession() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un nom'), backgroundColor: Colors.orange),
      );
      return;
    }

    if (_selectedCourse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un parcours'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      final session = await _sessionService.createSession(
        sessionName: _nameController.text.trim(),
        courseId: _selectedCourse!.id,
        autoStart: true,
      );

      setState(() => _isCreating = false);

      if (session != null && mounted) {
        // Retourner à l'écran précédent avec la session créée
        context.pop(session);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la création'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() => _isCreating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createRace),
        backgroundColor: const Color(0xFF00609C),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _readyCourses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noCourseReady,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.mustCreatePlaceBefore,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => context.pop(),
                        child: Text(l10n.back),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Nom de la session
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.raceName,
                          hintText: l10n.raceNameHint,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.event),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Sélection du parcours
                      Text(
                        l10n.selectCourse,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Parcours prêts (plus récents en premier)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      
                      // Liste des parcours
                      ...(_readyCourses.map((course) {
                        final isSelected = _selectedCourse?.id == course.id;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          color: isSelected ? const Color(0xFF00609C).withValues(alpha: 0.1) : null,
                          child: ListTile(
                            leading: Icon(
                              Icons.route,
                              color: isSelected ? const Color(0xFF00609C) : Colors.grey,
                            ),
                            title: Text(
                              course.name,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(
                              course.description ?? 'Pas de description',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check_circle, color: Color(0xFF00609C))
                                : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
                            onTap: () {
                              setState(() => _selectedCourse = course);
                            },
                          ),
                        );
                      }).toList()),
                      
                      const SizedBox(height: 32),
                      
                      // Bouton créer et lancer
                      ElevatedButton.icon(
                        onPressed: _isCreating ? null : _createAndStartSession,
                        icon: _isCreating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.play_arrow),
                        label: Text(_isCreating ? 'Création...' : l10n.createRace),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF6731F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
