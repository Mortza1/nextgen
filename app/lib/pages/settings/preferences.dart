import 'package:flutter/material.dart';

import '../../scopedModel/app_model.dart';

class PreferenceScreen extends StatefulWidget {
  final AppModel appModel;
  const PreferenceScreen({super.key, required this.appModel});

  @override
  PreferenceScreenState createState() => PreferenceScreenState();
}

class PreferenceScreenState extends State<PreferenceScreen> {
  // Define state variables to hold the toggle states for each option
  bool isVoiceAssistantEnabled = false;
  bool areNotificationsEnabled = false;
  bool isColorEnabled = false;
  bool isGamificationEnabled = false;

  // Store individual loading states for each setting
  Map<String, bool> isLoading = {
    'voice_assistant': false,
    'notifications': false,
    'gamification': false,
  };

  @override
  void initState() {
    super.initState();
    isVoiceAssistantEnabled = widget.appModel.userData['settings']['preferences']['voice_assistant'];
    areNotificationsEnabled = widget.appModel.userData['settings']['preferences']['Notifications'];
    isGamificationEnabled = widget.appModel.userData['settings']['preferences']['gamification'];
  }

  Future<void> toggleSetting(String key, bool currentValue, List<String> path) async {
    setState(() {
      isLoading[key] = true; // Show loading for the specific toggle
    });

    // Update settings in backend
    await widget.appModel.updateSettings(!currentValue, path);

    // Fetch the updated user data from backend
    await widget.appModel.getUser();

    // Update the local state with new user settings
    setState(() {
      isVoiceAssistantEnabled = widget.appModel.userData['settings']['preferences']['voice_assistant'];
      areNotificationsEnabled = widget.appModel.userData['settings']['preferences']['Notifications'];
      isGamificationEnabled = widget.appModel.userData['settings']['preferences']['gamification'];
      isLoading[key] = false; // Hide loading for the specific toggle
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: main(),
    );
  }

  Widget main() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Color(0xffF3F4FC)),
      child: Column(
        children: [
          SizedBox(height: 40),
          top(),
          SizedBox(height: 20),
          options(),
        ],
      ),
    );
  }

  Widget top() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffD2D2DA), width: 2))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, size: 20, color: Color(0xffC2C3CD)),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Preferences',
                    style: TextStyle(
                        color: Color(0xffAFB0BA),
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget options() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'App Experience',
              style: TextStyle(color: Color(0xffA1A2AA)),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.223,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffC2C3CD), width: 2),
                borderRadius: BorderRadius.circular(22)),
            child: Column(
              children: [
                buildOptionRow(
                  title: 'Voice assistant',
                  isEnabled: isVoiceAssistantEnabled,
                  isLoading: isLoading['voice_assistant']!,
                  onTap: () => toggleSetting('voice_assistant', isVoiceAssistantEnabled, ['preferences', 'voice_assistant']),
                ),
                buildOptionRow(
                  title: 'Notifications',
                  isEnabled: areNotificationsEnabled,
                  isLoading: isLoading['notifications']!,
                  onTap: () => toggleSetting('notifications', areNotificationsEnabled, ['preferences', 'Notifications']),
                ),
                buildOptionRow(
                  title: 'Gamification',
                  isEnabled: isGamificationEnabled,
                  isLoading: isLoading['gamification']!,
                  isLast: true,
                  onTap: () => toggleSetting('gamification', isGamificationEnabled, ['preferences', 'gamification']),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionRow({
    required String title,
    required bool isEnabled,
    required bool isLoading,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: (MediaQuery.of(context).size.height * 0.29) / 4,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffC2C3CD), width: isLast ? 0 : 2))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: Color(0xffA1A2AA), fontWeight: FontWeight.bold, fontSize: 17),
            ),
            isLoading
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 3, color: Colors.orange),
            )
                : IconButton(
              onPressed: onTap,
              icon: Icon(
                isEnabled ? Icons.toggle_on : Icons.toggle_off,
                color: isEnabled ? Colors.green : Colors.black,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
