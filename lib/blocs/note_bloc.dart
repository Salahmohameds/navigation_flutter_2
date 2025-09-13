import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/note_database.dart';
import '../data/note_model.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteDatabase _noteDatabase;

  NoteBloc({NoteDatabase? noteDatabase})
      : _noteDatabase = noteDatabase ?? NoteDatabase(),
        super(const NotesInitial()) {
    on<LoadNotesRequested>(_onLoadNotes);
    on<AddNoteRequested>(_onAddNote);
    on<UpdateNoteRequested>(_onUpdateNote);
    on<DeleteNoteRequested>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(
    LoadNotesRequested event,
    Emitter<NoteState> emit,
  ) async {
    emit(const NotesLoading());
    try {
      final List<Note> notes = await _noteDatabase.getAllNotes();
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(const NotesError('Failed to load notes'));
    }
  }

  Future<void> _onAddNote(
    AddNoteRequested event,
    Emitter<NoteState> emit,
  ) async {
    final currentState = state;
    emit(const NotesLoading());
    try {
      await _noteDatabase.insertNote(event.note);
      final List<Note> notes = await _noteDatabase.getAllNotes();
      emit(NotesLoaded(notes));
    } catch (e) {
      // Attempt to preserve previous data when possible
      if (currentState is NotesLoaded) {
        emit(currentState);
      }
      emit(const NotesError('Failed to add note'));
    }
  }

  Future<void> _onUpdateNote(
    UpdateNoteRequested event,
    Emitter<NoteState> emit,
  ) async {
    final currentState = state;
    emit(const NotesLoading());
    try {
      await _noteDatabase.updateNote(event.note);
      final List<Note> notes = await _noteDatabase.getAllNotes();
      emit(NotesLoaded(notes));
    } catch (e) {
      if (currentState is NotesLoaded) {
        emit(currentState);
      }
      emit(const NotesError('Failed to update note'));
    }
  }

  Future<void> _onDeleteNote(
    DeleteNoteRequested event,
    Emitter<NoteState> emit,
  ) async {
    final currentState = state;
    emit(const NotesLoading());
    try {
      await _noteDatabase.deleteNote(event.noteId);
      final List<Note> notes = await _noteDatabase.getAllNotes();
      emit(NotesLoaded(notes));
    } catch (e) {
      if (currentState is NotesLoaded) {
        emit(currentState);
      }
      emit(const NotesError('Failed to delete note'));
    }
  }
}


