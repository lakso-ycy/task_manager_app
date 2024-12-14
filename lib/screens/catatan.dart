import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Map<String, dynamic>> _notes = [];
  final Map<String, Color> _tags = {
    'Work': const Color(0xFFADF7B6),
    'Personal': const Color(0xFFFFEE9399),
    'Urgent': Colors.red,
    'Other': Colors.grey,
  };

  String? _selectedTag;
  Color _newTagColor = Colors.blue;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagNameController = TextEditingController();
  final List<Map<String, dynamic>> _checklist = [];

  bool _isEditing = false;
  int _editingIndex = -1;

  void _addTag() {
    final newTagName = _tagNameController.text.trim();
    if (newTagName.isNotEmpty && !_tags.containsKey(newTagName)) {
      setState(() {
        _tags[newTagName] = _newTagColor;
      });
      _tagNameController.clear();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tag name is empty or already exists.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _removeTag(String tagName) {
    setState(() {
      _tags.remove(tagName);

      // Ubah tag pada catatan yang menggunakan tag tersebut menjadi "Other"
      for (var note in _notes) {
        if (note['tag'] == tagName) {
          note['tag'] = 'Other';
        }
      }
    });
  }

  void _showAddTagsDialog() {
    _tagNameController.clear();
    _newTagColor = Colors.blue;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Manage Tags', style: TextStyle(fontFamily: 'Poppins')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tagNameController,
                decoration: const InputDecoration(labelText: 'Tag Name'),
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Tag Color: ', style: TextStyle(fontFamily: 'Poppins')),
                  Expanded(
                    child: DropdownButton<Color>(
                      value: _newTagColor,
                      onChanged: (value) {
                        setStateDialog(() {
                          _newTagColor = value!;
                        });
                      },
                      items: [
                        Colors.teal,
                        Colors.orange,
                        Colors.red,
                        Colors.blue,
                        Colors.green,
                        Colors.purple,
                        Colors.yellow,
                      ].map((color) {
                        return DropdownMenuItem(
                          value: color,
                          child: Container(
                            height: 20,
                            width: 20,
                            color: color,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addTag,
                child: const Text('Add Tag', style: TextStyle(fontFamily: 'Poppins')),
              ),
              const Divider(),
              const Text('Existing Tags:', style: TextStyle(fontFamily: 'Poppins')),
              const SizedBox(height: 10),
              ..._tags.keys.map((tag) {
                return ListTile(
                  title: Text(tag, style: const TextStyle(fontFamily: 'Poppins')),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeTag(tag),
                  ),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close', style: TextStyle(fontFamily: 'Poppins')),
            ),
          ],
        ),
      ),
    );
  }

  void _addOrEditNote() {
    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty) {
      setState(() {
        if (_isEditing) {
          _notes[_editingIndex] = {
            'title': _titleController.text,
            'content': _contentController.text,
            'tag': _selectedTag ?? 'Other',
            'checklist': _checklist.toList(),
          };
          _isEditing = false;
          _editingIndex = -1;
        } else {
          _notes.add({
            'title': _titleController.text,
            'content': _contentController.text,
            'tag': _selectedTag ?? 'Other',
            'checklist': _checklist.toList(),
          });
        }
      });
      _titleController.clear();
      _contentController.clear();
      _selectedTag = null;
      _checklist.clear();
      Navigator.of(context).pop();
    }
  }

  void _showAddOrEditNoteDialog([int? index]) {
    if (index != null) {
      _isEditing = true;
      _editingIndex = index;
      final note = _notes[index];
      _titleController.text = note['title'];
      _contentController.text = note['content'];
      _selectedTag = note['tag'];
      _checklist.clear();
      _checklist.addAll(note['checklist']);
    } else {
      _isEditing = false;
      _editingIndex = -1;
      _titleController.clear();
      _contentController.clear();
      _selectedTag = null;
      _checklist.clear();
    }

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(_isEditing ? 'Edit Note' : 'Add New Note', style: const TextStyle(fontFamily: 'Poppins')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 4,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tag:', style: TextStyle(fontFamily: 'Poppins')),
                  DropdownButton<String>(
                    value: _selectedTag,
                    onChanged: (value) {
                      setStateDialog(() {
                        _selectedTag = value;
                      });
                    },
                    items: _tags.keys.map((tag) {
                      return DropdownMenuItem(
                        value: tag,
                        child: Text(tag, style: const TextStyle(fontFamily: 'Poppins')),
                      );
                    }).toList(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _showAddTagsDialog();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Checklist:', style: TextStyle(fontFamily: 'Poppins')),
              ..._checklist.map((item) {
                return Row(
                  children: [
                    Checkbox(
                      value: item['checked'],
                      onChanged: (value) {
                        setStateDialog(() {
                          item['checked'] = value;
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: item['text']),
                        onChanged: (text) {
                          item['text'] = text;
                        },
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setStateDialog(() {
                          _checklist.remove(item);
                        });
                      },
                    ),
                  ],
                );
              }),
              TextButton(
                onPressed: () {
                  setStateDialog(() {
                    _checklist.add({'text': 'New Item', 'checked': false});
                  });
                },
                child: const Text('Add Item', style: TextStyle(fontFamily: 'Poppins')),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel', style: TextStyle(fontFamily: 'Poppins')),
            ),
            ElevatedButton(
              onPressed: _addOrEditNote,
              child: Text(_isEditing ? 'Save' : 'Add', style: const TextStyle(fontFamily: 'Poppins')),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  Color _getTagColor(String tag) {
    return _tags[tag] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: const Text(
            'Notes with Checklist',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color(0X99BDE0FE),
      ),
      body: _notes.isEmpty
          ? const Center(
              child: Text(
                'No notes available! Add some notes.',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            )
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (ctx, index) {
                final note = _notes[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  color: _getTagColor(note['tag']),
                  child: ExpansionTile(
                    title: Text(
                      note['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    subtitle: Text(
                      note['content'],
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                    children: [
                      ...note['checklist'].map<Widget>((item) {
                        return ListTile(
                          leading: Checkbox(
                            value: item['checked'],
                            onChanged: (value) {
                              setState(() {
                                item['checked'] = value;
                              });
                            },
                          ),
                          title: Text(
                            item['text'],
                            style: const TextStyle(fontFamily: 'Poppins'),
                          ),
                        );
                      }).toList(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showAddOrEditNoteDialog(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteNote(index),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOrEditNoteDialog,
        backgroundColor: const Color(0X99BDE0FE),
        child: const Icon(Icons.add),
      ),
    );
  }
}
