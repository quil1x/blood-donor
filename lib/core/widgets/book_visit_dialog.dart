import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/data/models/blood_center_model.dart';

class BookVisitDialog extends StatefulWidget {
  final BloodCenterModel bloodCenter;
  final VoidCallback? onBooked;

  const BookVisitDialog({
    super.key,
    required this.bloodCenter,
    this.onBooked,
  });

  @override
  State<BookVisitDialog> createState() => _BookVisitDialogState();
}

class _BookVisitDialogState extends State<BookVisitDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedBloodType = 'A+';
  bool _isLoading = false;

  final List<String> _bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.blueAccent,
              onPrimary: Colors.white,
              onSurface: AppColors.lightTextPrimary,
            ),
            textTheme: Theme.of(context).textTheme.copyWith(
              bodyLarge: const TextStyle(color: AppColors.lightTextPrimary),
              bodyMedium: const TextStyle(color: AppColors.lightTextPrimary),
              labelLarge: const TextStyle(color: AppColors.lightTextPrimary),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.blueAccent,
              onPrimary: Colors.white,
              onSurface: AppColors.lightTextPrimary,
            ),
            textTheme: Theme.of(context).textTheme.copyWith(
              bodyLarge: const TextStyle(color: AppColors.lightTextPrimary),
              bodyMedium: const TextStyle(color: AppColors.lightTextPrimary),
              labelLarge: const TextStyle(color: AppColors.lightTextPrimary),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _bookVisit() async {
    if (_formKey.currentState!.validate() && 
        _selectedDate != null && 
        _selectedTime != null) {
      setState(() {
        _isLoading = true;
      });

      
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Візит успішно заплановано на ${_formatDate(_selectedDate!)} о ${_formatTime(_selectedTime!)}',
            ),
            backgroundColor: AppColors.blueAccent,
          ),
        );

        widget.onBooked?.call();
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.calendar_badge_plus,
                    color: AppColors.blueAccent,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: const Text(
                      'Записатися на візит',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.bloodCenter.name,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 24),
              
              
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.lightTextPrimary),
                decoration: InputDecoration(
                  labelText: 'Повне ім\'я',
                  labelStyle: const TextStyle(color: AppColors.lightTextSecondary),
                  prefixIcon: const Icon(CupertinoIcons.person, color: AppColors.blueAccent),
                  filled: true,
                  fillColor: AppColors.lightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.lightBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.lightBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.blueAccent),
                  ),
                ),
                validator: (value) => value?.isEmpty == true ? 'Введіть ім\'я' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _phoneController,
                style: const TextStyle(color: AppColors.lightTextPrimary),
                decoration: InputDecoration(
                  labelText: 'Номер телефону',
                  labelStyle: const TextStyle(color: AppColors.lightTextSecondary),
                  prefixIcon: const Icon(CupertinoIcons.phone, color: AppColors.blueAccent),
                  filled: true,
                  fillColor: AppColors.lightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.lightBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.lightBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.blueAccent),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value?.isEmpty == true ? 'Введіть телефон' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: AppColors.lightTextPrimary),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: AppColors.lightTextSecondary),
                  prefixIcon: const Icon(CupertinoIcons.mail, color: AppColors.blueAccent),
                  filled: true,
                  fillColor: AppColors.lightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.lightBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.lightBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.blueAccent),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => 
                    value?.isEmpty == true ? 'Введіть email' :
                    !value!.contains('@') ? 'Невірний email' : null,
              ),
              const SizedBox(height: 16),
              
              
              DropdownButtonFormField<String>(
                value: _selectedBloodType,
                style: const TextStyle(color: AppColors.lightTextPrimary),
                decoration: InputDecoration(
                  labelText: 'Група крові',
                  labelStyle: const TextStyle(color: AppColors.lightTextSecondary),
                  prefixIcon: const Icon(CupertinoIcons.drop, color: AppColors.blueAccent),
                  filled: true,
                  fillColor: AppColors.lightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.lightBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.lightBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.blueAccent),
                  ),
                ),
                items: _bloodTypes.map((String bloodType) {
                  return DropdownMenuItem<String>(
                    value: bloodType,
                    child: Text(bloodType, style: const TextStyle(color: AppColors.lightTextPrimary)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBloodType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightBorder),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.calendar, color: AppColors.blueAccent),
                            const SizedBox(width: 12),
                            Text(
                              _selectedDate != null 
                                  ? _formatDate(_selectedDate!)
                                  : 'Оберіть дату',
                              style: TextStyle(
                                color: _selectedDate != null 
                                    ? AppColors.lightTextPrimary 
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: _selectTime,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightBorder),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.clock, color: AppColors.blueAccent),
                            const SizedBox(width: 12),
                            Text(
                              _selectedTime != null 
                                  ? _formatTime(_selectedTime!)
                                  : 'Оберіть час',
                              style: TextStyle(
                                color: _selectedTime != null 
                                    ? AppColors.lightTextPrimary 
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.lightTextSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Скасувати',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _bookVisit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Записатися',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
