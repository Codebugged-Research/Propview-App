import 'dart:convert';
import 'dart:io';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:propview/config.dart';

import 'package:propview/constants/uiConstants.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/authService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Admin/Profile/ExportAttendance.dart';
import 'package:propview/views/NotifcationScreen.dart';
import 'package:propview/views/loginScreen.dart';
import 'package:propview/views/updateScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user;
  bool isLoading = false;
  bool clearLoader = false;
  bool isNewVisible = true;
  bool isCurrentVisible = true;

  final formkey = new GlobalKey<FormState>();
  final picker = ImagePicker();
  var cacheData = APICacheManager();

  String currentPassword;
  String newPassword;

  TextEditingController currentPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    user = await UserService.getUser();
    imageCache.clearLiveImages();
    imageCache.clear();
    setState(() {
      isLoading = false;
    });
  }

  updatePasswordRequest() async {
    if (currentPasswordController.text == user.password) {
      setState(() {
        user.password = newPasswordController.text;
      });
      bool isUpdated = await UserService.updateUser(jsonEncode(user.toJson()));
      Routing.makeRouting(context, routeMethod: 'pop');
      if (isUpdated) {
        showInSnackBar(context, 'Password Updated Successfully!', 4000);
        cacheData.deleteCache("getUser");
      } else
        showInSnackBar(
            context, 'Failed to update the password! Try again.', 4000);
    } else {
      showInSnackBar(context, 'Current Password not matched! Try again.', 4000);
    }
  }

  Widget profileInfo(
      String labelText, String labelValue, IconData icon, Function function) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text('$labelText',
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
      subtitle: Text(
        '$labelValue',
        style: TextStyle(fontSize: 15, color: Colors.black),
      ),
      onTap: function,
    );
  }

  Future compress(img) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    final result = await FlutterImageCompress.compressAndGetFile(
      img.path,
      path.join(dir, user.userId.toString() + ".jpeg"),
      format: CompressFormat.jpeg,
      quality: 40,
    );
    return result;
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File img = await compress(pickedFile);
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade100,
              content: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 80,
                backgroundImage: FileImage(img),
              ),
              actions: [
                MaterialButton(
                  onPressed: () async {
                    var request = http.MultipartRequest(
                        'POST', Uri.parse(Config.UPLOAD_IMAGE_ENDPOINT));
                    request.files.add(
                      await http.MultipartFile.fromPath('upload', img.path),
                    );
                    var res = await request.send();
                    if (res.statusCode == 200) {
                      imageCache.clear();
                      imageCache.clearLiveImages();
                      setState(() {});
                      Navigator.of(context).pop();
                      getData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("Profile Picture updated successfully!!!"),
                        ),
                      );
                    } else {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Failed to update the Profile Picture! Try again."),
                        ),
                      );
                    }
                  },
                  child: Text("Update"),
                )
              ],
            );
          },
        ),
      );
    } else {
      print('No image selected.\!');
    }
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? circularProgressWidget()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Color(0xff314B8C),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(27.0),
                          bottomRight: Radius.circular(27.0),
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: InkWell(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          tileColor: Colors.transparent,
                          trailing: InkWell(
                            child: Icon(
                              Icons.notifications_active,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => NotificationScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 36),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 80,
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                              height: 160,
                              width: 160,
                              fit: BoxFit.cover,
                              placeholder: "assets/loader.gif",
                              image:
                                  "${Config.STORAGE_ENDPOINT}${user.userId}.jpeg",
                              imageErrorBuilder: (BuildContext context,
                                  Object exception, StackTrace stackTrace) {
                                return CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 80,
                                  backgroundImage: AssetImage(
                                    "assets/dummy.png",
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text('${user.name}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.46)),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 50),
                          child: InkWell(
                            onTap: () {
                              getImage();
                            },
                            child: Container(
                              height: 35,
                              width: 175,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Update Profile Picture',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  profileInfo('Name', '${user.name}', Icons.person, () {}),
                  profileInfo('Phone Number', '${user.officialNumber}',
                      Icons.call, () {}),
                  profileInfo(
                      'Email', '${user.officialEmail}', Icons.mail, () {}),
                  profileInfo(
                    'Access Level',
                    '${user.userType.replaceFirst(user.userType.substring(0, 1), user.userType.substring(0, 1).toUpperCase())}',
                    Icons.security,
                    () {},
                  ),
                  profileInfo(
                    'Export Attendance',
                    'Choose a date range',
                    Icons.import_export,
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ExportAttendance(),
                        ),
                      );
                    },
                  ),
                  profileInfo(
                      'Reset Cache', 'Clear the cache data', Icons.clear,
                      () async {
                    setState(() {
                      clearLoader = true;
                    });
                    await cacheData.emptyCache();
                    setState(() {
                      clearLoader = false;
                    });
                  }),
                  clearLoader ? circularProgressWidget() : Container(),
                  profileInfo('Logout', '', Icons.exit_to_app_rounded,
                      () async {
                    AuthService.clearAuth();
                    await cacheData.emptyCache();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }),
                  profileInfo('Update', '', Icons.mail, () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpdateScreen(),
                    ));
                  }),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child:
                        Center(child: Text("Version: " + Config.APP_VERISON)),
                  ),
                  updatePasswordButton(context),
                  SizedBox(height: UIConstants.fitToHeight(24, context)),
                ],
              ),
            ));
  }

  Widget updatePasswordButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: MaterialButton(
        minWidth: 360,
        height: 55,
        color: Color(0xff314B8C),
        onPressed: () async {
          await passwordModalSheet(context);
        },
        child: Text("Update Password",
            style: Theme.of(context).primaryTextTheme.subtitle1),
      ),
    );
  }

  passwordModalSheet(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) =>
                  Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: UIConstants.fitToHeight(16, context)),
                      Text(
                        'Update Password',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline6
                            .copyWith(
                                color: Color(0xff314B8C),
                                fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: UIConstants.fitToHeight(16, context)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Container(
                          child: Form(
                              key: formkey,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    inputWidget(
                                        currentPasswordController,
                                        "Please Enter your Current Password",
                                        isCurrentVisible,
                                        "Current Password",
                                        'Current Password', (value) {
                                      currentPassword = value;
                                    }, stateSetter),
                                    SizedBox(
                                        height: UIConstants.fitToHeight(
                                            18, context)),
                                    inputWidget(
                                        newPasswordController,
                                        "Please Enter your New Password",
                                        isNewVisible,
                                        "New Password",
                                        'New Password', (value) {
                                      newPassword = value;
                                    }, stateSetter),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      SizedBox(height: UIConstants.fitToHeight(24, context)),
                      updatePassword(context),
                      SizedBox(height: UIConstants.fitToHeight(24, context)),
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget inputWidget(
      TextEditingController textEditingController,
      String validation,
      bool isVisible,
      String label,
      String hint,
      save,
      StateSetter stateSetter) {
    return TextFormField(
      style: TextStyle(fontSize: 15.0, color: Color(0xFF000000)),
      controller: textEditingController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(fontSize: 15.0, color: Color(0xff9FA0AD)),
        labelStyle: TextStyle(fontSize: 15.0, color: Color(0xFF000000)),
        suffixIcon: IconButton(
            onPressed: () {
              stateSetter(() {
                isVisible = !isVisible;
              });
            },
            icon: Icon(!isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.black)),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff314B8C)),
            borderRadius: BorderRadius.circular(12.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff314B8C)),
            borderRadius: BorderRadius.circular(12.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff314B8C)),
            borderRadius: BorderRadius.circular(12.0)),
      ),
      obscureText: isVisible,
      validator: (value) => value.isEmpty ? validation : null,
      onSaved: save,
    );
  }

  Widget updatePassword(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: UIConstants.fitToWidth(296, context),
        child: MaterialButton(
            onPressed: () async {
              await updatePasswordRequest();
            },
            color: Color(0xff314B8C),
            splashColor: Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text('Update Password',
                style: Theme.of(context)
                    .primaryTextTheme
                    .button
                    .copyWith(fontWeight: FontWeight.w800, fontSize: 16))),
      ),
    );
  }
}
