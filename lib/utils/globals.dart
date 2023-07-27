import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

String userID = '';
String messagingKey =
    'key=AAAAv-dPM7I:APA91bFcdTCtpzQmVN9lfsM1ukJdQEjS7dQSqRxp0Mjvtek7MnpnGAyNsyq0HZY_e_wajOTlCKY29NmVmFqoC2MwVz0MxBG1UmQMOP3oCs7AQjhik359H11ADiZKcO_P3W7VWk5n0bot';
const MESSAGES_COLLECTION = "messages";
const USER_COLLECTION = "users";
const CONTACT_COLLECTION = "contact";
const STORY_COLLECTION = 'story';
const CHAT_REQUEST = 'chatRequest';
const ADMIN = 'admin';
const GROUP_COLLECTION = 'groups';
const GROUP_CHATS = 'chats';
const GROUP_GROUPCHATS = 'groupChats';
const DEVICE_COLLECTION = 'device';
const CHAT_DATA_IMAGES = "chatImages";
const STORY_DATA_IMAGES = "storyImages";
const GROUP_PROFILE_IMAGE = "groupProfileImage";
const GROUP_PROFILE_IMAGES = "groupChatImages";

const CURRENT_GROUP_ID = "current_group_chat_id";

Widget noProfileImageFound({double? height, double? width, bool isNoRadius = false, bool isGroup = false}) {
  return Image.asset(isGroup ? 'assets/group_user.jpg' : 'assets/user.jpg', height: height, width: width, fit: BoxFit.cover)
      .cornerRadiusWithClipRRect(isNoRadius ? 0 : height! / 2);
}

const TEXT = "TEXT";
const IMAGE = "IMAGE";
const VIDEO = "VIDEO";
const AUDIO = "AUDIO";
const DOC = "DOC";
const STICKER = "STICKER";
const LOCATION = "LOCATION";
const VOICE_NOTE = "VOICE_NOTE";
//endregion

const TYPE_AUDIO = "audio";
const TYPE_VIDEO = "video";
const TYPE_Image = "image";
const TYPE_DOC = "doc";
const TYPE_LOCATION = "current_location";
const TYPE_VOICE_NOTE = "voice_note";
const TYPE_STICKER = "sticker";

int mChatFontSize = 16;

const FONT_SIZE_INDEX = "FONT_SIZE_INDEX";
const FONT_SIZE_PREF = "FONT_SIZE_PREF";
const IS_ENTER_KEY = "IS_ENTER_KEY";
const SELECTED_WALLPAPER = "SELECTED_WALLPAPER";
bool mIsEnterKey = false;
String mSelectedImage = "assets/default_wallpaper.png";
String mSelectedImageDark = "assets/default_wallpaper_dark.jpg";
const USER_PROFILE_IMAGE = "userProfileImage";

enum MessageType { TEXT, IMAGE, VIDEO, AUDIO, STICKER, DOC, LOCATION, VOICE_NOTE }

String formatDateString(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);

  return dateTime.timeAgo;
}

//Pagination Setting
const PER_PAGE_CHAT_COUNT = 50;
Widget iconsBackgroundWidget(BuildContext context, {String? name, IconData? iconData, Color? color}) {
  return Container(
    width: context.width() / 3 - 32,
    color: context.scaffoldBackgroundColor,
    child: Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(child: SizedBox(height: 28, width: 28), backgroundColor: color, radius: 28),
            Positioned(
              top: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(56),
                      ),
                      color: Colors.black.withOpacity(0.2),
                    ),
                    width: 28,
                    height: 28,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(56),
                      ),
                      color: Colors.black.withOpacity(0.2),
                    ),
                    width: 28,
                    height: 28,
                  ),
                ],
              ),
            ),
            Icon(iconData, size: 28, color: Colors.white),
          ],
        ),
        8.height,
        Text(name.validate(), style: secondaryTextStyle(color: textSecondaryColor)),
      ],
    ),
  );
}

bool isRTL = false;
const chatMsgRadius = 12.0;
