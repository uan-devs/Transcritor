import 'package:flutter/material.dart';

class DatePickerField extends StatefulWidget {
  const DatePickerField({
    super.key,
    this.label,
    this.initialDate,
    this.minimumDate,
    this.maximumDate,
    this.enable = true,
    this.onChanged,
  });

  final String? label;
  final DateTime? initialDate;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final bool enable;
  final ValueChanged<DateTime>? onChanged;

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime(
      DateTime.now().year - 28,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(
        text: _selectedDate.toLocal().toString().split('/')[0],
      ),
      readOnly: true,
      enabled: widget.enable,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      onFieldSubmitted: (_) => setState(() {}),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.calendar_today),
        suffixIcon: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {},
        ),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onTap: !widget.enable
          ? null
          : () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: widget.minimumDate ?? DateTime(
                  DateTime.now().year - 100,
                ),
                lastDate: widget.maximumDate ?? DateTime(
                  DateTime.now().year - 18,
                ),
              );
              if (picked != null && picked != _selectedDate) {
                widget.onChanged?.call(picked);
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
    );
  }
}
