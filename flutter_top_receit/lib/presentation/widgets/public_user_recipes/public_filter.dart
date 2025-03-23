import 'package:flutter/material.dart';

class FilterModal extends StatefulWidget {
  final Function(bool filterByFollowing) onFilterApplied;

  const FilterModal({
    Key? key,
    required this.onFilterApplied,
  }) : super(key: key);

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  final TextEditingController _titleController = TextEditingController();
  String? _selectedStepsFilter;
  String? _selectedIngredientsFilter;
  bool _filterByFollows = false;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Filtrar por usuarios seguidos'), // traducir
                  Switch(
                    value: _filterByFollows,
                    onChanged: (value) {
                      setState(() {
                        _filterByFollows = value;
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onFilterApplied(_filterByFollows);
                  Navigator.of(context).pop();
                },
                child: const Text("Aplicar Filtros"), // traducir
              ),
            ],
          ),
        );
      },
    );
  }
}
