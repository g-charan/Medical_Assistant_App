import 'package:app/data/models/profile.models.dart';
import 'package:app/data/presentation/providers/profile.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;
  bool _isInitialized = false; // Track if form has been initialized
  bool _hasTriggeredSave = false; // Track if save button was actually pressed
  Profile? _lastSavedProfile; // Keep track of the last saved profile data

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // Function to initialize form fields with actual profile data
  void _initializeFormFields(Profile? profile) {
    if (_isInitialized) return; // Prevent re-initialization

    setState(() {
      _nameController.text = profile?.name ?? '';
      _phoneController.text = profile?.phone ?? '';

      // Fix: Ensure gender matches exactly with dropdown values
      final gender = profile?.gender;
      if (gender != null && ['Male', 'Female', 'Other'].contains(gender)) {
        _selectedGender = gender;
      } else {
        _selectedGender = null;
      }

      // Handle date of birth
      if (profile?.dateOfBirth != null && profile!.dateOfBirth.isNotEmpty) {
        try {
          _selectedDate = DateTime.parse(profile.dateOfBirth);
          _dobController.text = profile.dateOfBirth;
        } catch (e) {
          // If date parsing fails, leave empty
          _dobController.text = '';
          _selectedDate = null;
        }
      } else {
        _dobController.text = '';
        _selectedDate = null;
      }

      _isInitialized = true;
    });
  }

  // NEW: Function to update form fields with saved data immediately
  void _updateFormWithSavedData(Profile savedProfile) {
    setState(() {
      _nameController.text = savedProfile.name;
      _phoneController.text = savedProfile.phone;
      _selectedGender = savedProfile.gender.isEmpty
          ? null
          : savedProfile.gender;

      if (savedProfile.dateOfBirth.isNotEmpty) {
        try {
          _selectedDate = DateTime.parse(savedProfile.dateOfBirth);
          _dobController.text = savedProfile.dateOfBirth;
        } catch (e) {
          _dobController.text = '';
          _selectedDate = null;
        }
      } else {
        _dobController.text = '';
        _selectedDate = null;
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Set flag to indicate save was triggered
      _hasTriggeredSave = true;

      final Profile payload = Profile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        gender: _selectedGender ?? "",
        dateOfBirth: _dobController.text,
      );

      // Store the payload for immediate UI update
      _lastSavedProfile = payload;

      ref.read(profileUpdateNotifierProvider.notifier).updateProfile(payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the profile data provider to get current profile
    final profileAsyncValue = ref.watch(profileDataProvider);

    // FIXED: Listen to update provider for success/error messages
    ref.listen<AsyncValue<void>>(profileUpdateNotifierProvider, (
      previous,
      next,
    ) {
      // Only show error if there's actually an error AND we have a previous state
      if (next.hasError && previous != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
        // Reset save trigger flag on error
        setState(() {
          _hasTriggeredSave = false;
        });
      }

      // FIXED: Only show success message when transitioning from loading to success
      if (_hasTriggeredSave &&
          previous != null &&
          previous.isLoading &&
          !next.isLoading &&
          next.hasValue &&
          !next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // SOLUTION: Immediately update the form with the saved data
        if (_lastSavedProfile != null) {
          _updateFormWithSavedData(_lastSavedProfile!);
        }

        // Reset flags
        setState(() {
          _hasTriggeredSave = false;
        });

        // Refresh profile data in background for future loads
        ref.invalidate(profileDataProvider);
      }
    });

    final profileUpdateState = ref.watch(profileUpdateNotifierProvider);
    final isLoading = profileUpdateState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: profileAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading profile: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isInitialized = false; // Allow re-initialization
                  });
                  ref.invalidate(profileDataProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (profile) {
          // Initialize form fields when profile data is available (only on first load)
          if (!_isInitialized) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _initializeFormFields(profile);
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'Enter your full name',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Phone Field
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_outlined),
                      hintText: 'Enter your phone number',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.wc_outlined),
                      hintText: 'Select your gender',
                    ),
                    items: ['Male', 'Female', 'Other']
                        .map(
                          (label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your gender';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Date of Birth Field
                  TextFormField(
                    controller: _dobController,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      hintText: 'Select your date of birth',
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your date of birth';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  ElevatedButton(
                    onPressed: isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
