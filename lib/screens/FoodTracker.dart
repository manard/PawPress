import 'package:flutter/material.dart';

class FoodTracker extends StatefulWidget {
  final int petID;

  const FoodTracker({Key? key, required this.petID}) : super(key: key);

  @override
  _FoodTrackerState createState() => _FoodTrackerState();
}

class _FoodTrackerState extends State<FoodTracker> {
  final _formKey = GlobalKey<FormState>();
  String? feedingFrequency;
  String? feedingFrequencyOther;
  List<TimeOfDay> feedingTimeList = [];
  List<String> foodTypes = [];
  String? otherFoodType;
  List<String> healthConditions = [];
  String? otherHealthCondition;
  List<String> allergies = [];
  String? otherAllergy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Nutrition Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pet ID Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Tracking Nutrition for Pet #${widget.petID}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Feeding Frequency Section
                  _buildSectionHeader(
                    icon: Icons.schedule,
                    title: 'Feeding Schedule',
                  ),
                  _buildQuestionText(
                    'How many times do you feed your pet each day?',
                  ),
                  _buildRadioOptions(['Once', 'Twice', 'Three times', 'Other']),
                  if (feedingFrequency == 'Other')
                    _buildTextField(
                      label: 'Please specify feeding frequency',
                      onChanged: (value) => feedingFrequencyOther = value,
                    ),
                  const SizedBox(height: 16),

                  // Feeding Times
                  _buildQuestionText('Select feeding times:'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildAddButton(
                        label: '+ Add Time',
                        onPressed: () async {
                          TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              feedingTimeList.add(picked);
                            });
                          }
                        },
                      ),
                      ...feedingTimeList.map((time) => _buildTimeChip(time)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Food Types Section
                  _buildSectionHeader(
                    icon: Icons.fastfood,
                    title: 'Diet Composition',
                  ),
                  _buildQuestionText(
                    'What type(s) of food do you usually give your pet?',
                  ),
                  _buildCheckboxGrid([
                    'Dry food',
                    'Wet food',
                    'Raw food',
                    'Home-cooked meals',
                    'Other',
                  ]),
                  if (foodTypes.contains('Other'))
                    _buildTextField(
                      label: 'Enter other food type',
                      onChanged: (value) => otherFoodType = value,
                    ),
                  const SizedBox(height: 24),

                  // Health Section
                  _buildSectionHeader(
                    icon: Icons.medical_services,
                    title: 'Health Considerations',
                  ),
                  _buildQuestionText(
                    'Does your pet have any medical conditions that affect its diet?',
                  ),
                  _buildCheckboxGrid([
                    'Obesity',
                    'Diabetes',
                    'Allergies',
                    'Kidney issues',
                    'None',
                    'Other',
                  ]),
                  if (healthConditions.contains('Other'))
                    _buildTextField(
                      label: 'Enter other health condition',
                      onChanged: (value) => otherHealthCondition = value,
                    ),
                  const SizedBox(height: 16),

                  // Allergies
                  _buildQuestionText(
                    'Is your pet allergic to any specific foods?',
                  ),
                  _buildCheckboxGrid([
                    'Chicken',
                    'Fish',
                    'Grains',
                    'Dairy',
                    'Other',
                  ]),
                  if (allergies.contains('Other'))
                    _buildTextField(
                      label: 'Enter other allergy',
                      onChanged: (value) => otherAllergy = value,
                    ),
                  const SizedBox(height: 32),

                  // Submit Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle form submission
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Save Nutrition Profile',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildRadioOptions(List<String> options) {
    return Column(
      children:
          options.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: feedingFrequency,
              contentPadding: EdgeInsets.zero,
              dense: true,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              onChanged: (value) {
                setState(() {
                  feedingFrequency = value;
                });
              },
            );
          }).toList(),
    );
  }

  Widget _buildCheckboxGrid(List<String> options) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children:
          options.map((option) {
            return FilterChip(
              label: Text(option),
              selected:
                  option == 'Other'
                      ? (allergies.contains('Other') ||
                          foodTypes.contains('Other') ||
                          healthConditions.contains('Other'))
                      : (allergies.contains(option) ||
                          foodTypes.contains(option) ||
                          healthConditions.contains(option)),
              onSelected: (selected) {
                setState(() {
                  if (allergies.contains(option)) {
                    if (selected) {
                      allergies.add(option);
                    } else {
                      allergies.remove(option);
                    }
                  } else if (foodTypes.contains(option)) {
                    if (selected) {
                      foodTypes.add(option);
                    } else {
                      foodTypes.remove(option);
                    }
                  } else if (healthConditions.contains(option)) {
                    if (selected) {
                      healthConditions.add(option);
                    } else {
                      healthConditions.remove(option);
                    }
                  } else {
                    // Determine which list to add to based on context
                    if (option == 'Other') {
                      // This is a simplified approach - you might need to adjust
                      // based on which section this checkbox is in
                      if (selected) {
                        foodTypes.add(option);
                      } else {
                        foodTypes.remove(option);
                      }
                    } else {
                      // Default to food types if we can't determine
                      if (selected) {
                        foodTypes.add(option);
                      } else {
                        foodTypes.remove(option);
                      }
                    }
                  }
                });
              },
              backgroundColor: Colors.white,
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color:
                    (allergies.contains(option) ||
                            foodTypes.contains(option) ||
                            healthConditions.contains(option))
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color:
                      (allergies.contains(option) ||
                              foodTypes.contains(option) ||
                              healthConditions.contains(option))
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildTextField({
    required String label,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildAddButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      avatar: Icon(Icons.add, size: 18, color: Theme.of(context).primaryColor),
      onPressed: onPressed,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _buildTimeChip(TimeOfDay time) {
    return Chip(
      label: Text(
        time.format(context),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      deleteIcon: Icon(Icons.close, size: 18, color: Colors.grey.shade600),
      onDeleted: () {
        setState(() {
          feedingTimeList.remove(time);
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
