import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/note_model.dart';
import '../data/note_database.dart';
import '../components/note_card.dart';
import '../components/custom_button.dart';
import 'add_edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _database = NoteDatabase();
  List<Note> _notes = [];
  bool _isLoading = true;
  String _userName = '';

  // Colorful background colors for notes
  final List<Color> _noteColors = [
    const Color(0xFFFFF59D), // Light yellow
    const Color(0xFFC8E6C9), // Light green
    const Color(0xFFE1BEE7), // Light purple
    const Color(0xFFBBDEFB), // Light blue
    const Color(0xFFFFCDD2), // Light red/coral
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadNotes();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('username') ?? 'User';
    });
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notes = await _database.getAllNotes();
      
      // If no notes exist, create some sample notes
      if (notes.isEmpty) {
        await _createSampleNotes();
        final newNotes = await _database.getAllNotes();
        setState(() {
          _notes = newNotes;
          _isLoading = false;
        });
      } else {
        setState(() {
          _notes = notes;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading notes: $e')),
        );
      }
    }
  }

  Future<void> _createSampleNotes() async {
    final sampleNotes = [
      Note(
        title: 'title 5',
        content: 'content',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Note(
        title: 'title4',
        content: 'content',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Note(
        title: 'title 3',
        content: 'content',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Note(
        title: 'title2',
        content: 'content?',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Note(
        title: 'title',
        content: 'content',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    for (final note in sampleNotes) {
      await _database.insertNote(note);
    }
  }

  Future<void> _deleteNote(int id) async {
    try {
      await _database.deleteNote(id);
      _loadNotes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting note: $e')),
        );
      }
    }
  }

  Future<void> _navigateToAddEditNote(Note? note) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditNoteScreen(note: note),
      ),
    );

    if (result == true) {
      _loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $_userName!'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.note_add,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No notes yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap the + button to add your first note',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Add Note',
                        onPressed: () => _navigateToAddEditNote(null),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotes,
                  child: ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      final colorIndex = index % _noteColors.length;
                      return NoteCard(
                        title: note.title,
                        content: note.content,
                        backgroundColor: _noteColors[colorIndex],
                        onTap: () => _navigateToAddEditNote(note),
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Note'),
                              content: const Text('Are you sure you want to delete this note?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _deleteNote(note.id!);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditNote(null),
        backgroundColor: const Color(0xFF1976D2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}