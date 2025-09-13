import 'package:equatable/equatable.dart';
import '../data/note_model.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotesRequested extends NoteEvent {
  const LoadNotesRequested();
}

class AddNoteRequested extends NoteEvent {
  final Note note;
  const AddNoteRequested(this.note);

  @override
  List<Object?> get props => [note];
}

class UpdateNoteRequested extends NoteEvent {
  final Note note;
  const UpdateNoteRequested(this.note);

  @override
  List<Object?> get props => [note];
}

class DeleteNoteRequested extends NoteEvent {
  final int noteId;
  const DeleteNoteRequested(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

