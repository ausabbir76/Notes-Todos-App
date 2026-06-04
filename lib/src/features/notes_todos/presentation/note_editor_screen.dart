import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/layout/app_scale.dart';
import '../../../app/theme/theme_controller.dart';
import '../../../app/widgets/neon_background.dart';
import '../domain/note_item.dart';
import 'widgets/editor_chrome.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({this.note, super.key});

  final NoteItem? note;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  final FocusNode _titleFocusNode = FocusNode();
   
  final List<_NoteState> _history = [];
  Timer? _historyDebounce;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    
    // Initial state
    _history.add(_NoteState(
      title: _titleController.text,
      content: _contentController.text,
    ));

    _titleController.addListener(_scheduleRecordState);
    _contentController.addListener(_scheduleRecordState);
  }

  void _scheduleRecordState() {
    _historyDebounce?.cancel();
    _historyDebounce = Timer(const Duration(milliseconds: 250), _recordState);
  }

  void _recordState() {
    final currentState = _NoteState(
      title: _titleController.text,
      content: _contentController.text,
    );
    
    if (_history.isEmpty || _history.last != currentState) {
      if (_history.length > 100) _history.removeAt(0);
      _history.add(currentState);
      if (mounted) setState(() {});
    }
  }

  void _undo() {
    if (_history.length <= 1) return;
    
    // Remove current state
    _history.removeLast();
    final prevState = _history.last;
    
    // Temporarily remove listeners to avoid recording the undo as a new state
    _historyDebounce?.cancel();
    _titleController.removeListener(_scheduleRecordState);
    _contentController.removeListener(_scheduleRecordState);
    
    setState(() {
      _titleController.text = prevState.title;
      _contentController.text = prevState.content;
      // Put cursor at end
      _titleController.selection = TextSelection.fromPosition(
        TextPosition(offset: _titleController.text.length),
      );
      _contentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _contentController.text.length),
      );
    });
    
    _titleController.addListener(_scheduleRecordState);
    _contentController.addListener(_scheduleRecordState);
  }

  @override
  void dispose() {
    _historyDebounce?.cancel();
    _titleController.removeListener(_scheduleRecordState);
    _contentController.removeListener(_scheduleRecordState);
    _titleController.dispose();
    _contentController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController().currentTheme;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: EditorTopBar(
        theme: theme,
        title: widget.note == null ? 'New Note' : '.....',
        onBack: () => Navigator.of(context).pop(),
        onSave: _save,
        onUndo: _history.length > 1 ? _undo : null,
      ),
      bottomNavigationBar: EditorBottomTitleBar(
        theme: theme,
        titleController: _titleController,
        titleFocusNode: _titleFocusNode,
      ),
      body: NeonBackground(
        theme: theme,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final topPadding = MediaQuery.of(context).padding.top + AppScale.size(12);
            final bottomPadding = MediaQuery.of(context).padding.bottom + AppScale.size(12);
            final minContainerHeight = (constraints.maxHeight - topPadding - bottomPadding)
                    .clamp(0.0, double.infinity)
                    .toDouble();

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                top: topPadding,
                bottom: bottomPadding,
                left: AppScale.size(20),
                right: AppScale.size(20),
              ),
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minContainerHeight),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: theme.getEntryItemDecoration(false),
                      ),
                    ),
                    Padding(
                      padding: AppScale.only(top: 20, left: 20, right: 20, bottom: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _contentController,
                            maxLines: null,
                            minLines: 5,
                            keyboardType: TextInputType.multiline,
                            textAlignVertical: TextAlignVertical.top,
                            style: theme.entrySubtitleStyle.copyWith(fontSize: 16, height: 1.5),
                            decoration: InputDecoration(
                              hintText: 'Content',
                              hintStyle: theme.entrySubtitleStyle.copyWith(
                                fontSize: 17,
                                color: theme.appBarIconColor.withValues(alpha: 0.3),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                    EditorTimestamp(
                      theme: theme,
                      timestamp: widget.note?.createdAt ?? DateTime.now(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _save() {
    Navigator.of(context).pop(
      NoteEditorResult(
        title: _titleController.text,
        content: _contentController.text,
      ),
    );
  }
}

class NoteEditorResult {
  const NoteEditorResult({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;
}

class _NoteState {
  const _NoteState({required this.title, required this.content});
  final String title;
  final String content;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _NoteState &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          content == other.content;

  @override
  int get hashCode => title.hashCode ^ content.hashCode;
}
