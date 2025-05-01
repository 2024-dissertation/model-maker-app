import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/ui/themed/themed_card.dart';
import 'package:frontend/ui/themed/themed_icon.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutModal extends StatefulWidget {
  const AboutModal({super.key});

  @override
  State<AboutModal> createState() => _AboutModalState();
}

class _AboutModalState extends State<AboutModal> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        largeTitle: Text('About Me'),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppPadding.md),
          child: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppPadding.lg + 4),
              ThemedCard(
                child: ThemedText(
                  "Feel free to reach out to me on any of the platforms below! Accepting work offers and collaborations.",
                ),
              ),
              _buildContactRow(
                RemixIcons.github_fill,
                "Personal Github",
                "https://github.com/Soup666",
              ),
              _buildContactRow(
                RemixIcons.linkedin_fill,
                "Everbit Linkedin",
                "https://www.linkedin.com/company/everbit-software/",
              ),
              _buildContactRow(
                RemixIcons.linkedin_fill,
                "Personal Linkedin",
                "https://www.linkedin.com/in/sam-laister/",
              ),
              _buildContactRow(
                RemixIcons.mail_fill,
                "Work Email",
                "mailto:saml@everbit.dev",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text, String url) {
    return ThemedCard(
      onTap: () async {
        final Uri _url = Uri.parse(url);
        if (!await launchUrl(_url)) {
          Fluttertoast.showToast(
            msg: "Could not open link",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      },
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Column(
              spacing: 4,
              children: [
                Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ThemedIcon(
                      icon: icon,
                      size: 24,
                    ),
                    ThemedText(text),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    ThemedText(
                      url,
                      color: TextColor.muted,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: ThemedIcon(
              icon: RemixIcons.arrow_right_s_line,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
