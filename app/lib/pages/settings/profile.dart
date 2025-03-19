import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/components/snackbar.dart';
import '../../scopedModel/app_model.dart';

class ProfileScreen extends StatefulWidget {
  final AppModel appModel;
  const ProfileScreen({super.key, required this.appModel});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late String selectedAvatar;
  bool isLoading = false;
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedAvatar = widget.appModel.userData['gender'] == 'male'
        ? 'assets/images/man.png'
        : 'assets/images/profile_female.png';
    nameController.text = widget.appModel.userData['name'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: main(),
      ),
    );
  }

  Widget main() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(color: Color(0xffF3F4FC)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            top(),
            SizedBox(height: 20),
            icon(),
            SizedBox(height: 20),
            field('Name', nameController),
            SizedBox(height: 30),
            saveButton(),
          ],
        ),
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

  Widget icon() {
    return GestureDetector(
      onTap: () => openAvatarDialog(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(selectedAvatar, height: 80),
            SizedBox(height: 5),
            Text(
              'Change Avatar',
              style: TextStyle(color: Color(0xff00AB5E), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void openAvatarDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Avatar'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              avatarOption('assets/images/man.png'),
              SizedBox(width: 10),
              avatarOption('assets/images/profile_female.png'),
            ],
          ),
        );
      },
    );
  }

  Widget avatarOption(String avatarPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAvatar = avatarPath;
        });
        var value = avatarPath == 'assets/images/man.png' ? 'male' : 'female';
        widget.appModel.updateUser('gender', value);
        widget.appModel.getUser();
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: selectedAvatar == avatarPath ? Colors.green : Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(avatarPath, height: 80),
      ),
    );
  }

  Widget field(String text, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(color: Color(0xffA8A9B6), fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0x96C2C3CD), width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff00AB5E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () async {
          setState(() {
            isLoading = true;
          });

          try {
            await widget.appModel.updateUser('name', nameController.text);
            showComingSoonSnackBar(context, 'Changes saved');
          } catch (e) {
            showComingSoonSnackBar(context, 'Failed to save changes. Try again.');
          } finally {
            Future.delayed(Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            });
          }
        },
        child: isLoading
            ? SizedBox(
          height: 15,
          width: 15,
          child: CircularProgressIndicator(color: Colors.white),
        )
            : Text(
          'Save',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }


}
