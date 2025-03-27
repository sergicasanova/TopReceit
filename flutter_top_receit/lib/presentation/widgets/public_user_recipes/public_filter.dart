import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterModal extends StatefulWidget {
  final Function(bool filterByFollowing) onFilterApplied;

  // ignore: use_super_parameters
  const FilterModal({
    Key? key,
    required this.onFilterApplied,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
                  Text(AppLocalizations.of(context)!.filter_followed_users),
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
                child: Text(AppLocalizations.of(context)!.apply_filters_button),
              ),
            ],
          ),
        );
      },
    );
  }
}
