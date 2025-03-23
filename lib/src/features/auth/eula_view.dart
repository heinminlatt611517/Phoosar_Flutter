import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EULAView extends StatelessWidget {
  const EULAView({super.key});

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://phoosar.com/privacy-policy');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('End-User License Agreement'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'END-USER LICENSE AGREEMENT (EULA)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'This End-User License Agreement ("Agreement") is a legal agreement between you (either an individual or a single entity) and Myanmar Online Creations ("Company," "we," "our," or "us") for the use of the [Phoosar] ("App"). By installing, accessing, or using the App, you agree to comply with and be bound by the terms of this Agreement.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'If you do not agree to the terms of this Agreement, do not install, access, or use the App.',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24.0),

            // License Grant
            const Text(
              '1. License Grant',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'We grant you a non-exclusive, non-transferable, limited license to install and use the App on your mobile device or other device that is compatible with the App ("Authorized Device"). You may use the App only for personal, non-commercial purposes, and subject to all the terms and conditions of this Agreement.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Restrictions
            const Text(
              '2. Restrictions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'You may not:\n\n'
                  '• Modify, alter, reverse-engineer, decompile, or disassemble the App or any part of it.\n'
                  '• Sell, lease, sublicense, distribute, or otherwise transfer the App to third parties.\n'
                  '• Use the App for any unlawful purpose or in violation of any applicable laws or regulations.\n'
                  '• Remove, alter, or obscure any proprietary notices or labels on the App.\n'
                  '• Use the App to infringe on any intellectual property rights or the privacy of others.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Ownership
            const Text(
              '3. Ownership',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'The App is owned and operated by Myanmar Online Creations, and all intellectual property rights in the App (including any software, designs, images, and other content) are owned by Myanmar Online Creations or its licensors. Your use of the App does not transfer any ownership rights.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Privacy and Data Collection
            const Text(
              '4. Privacy and Data Collection',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'The App collects personal information as described in our Privacy Policy. By using the App, you consent to the collection, use, and sharing of your data as outlined in the Privacy Policy.\n\n'
                        'For detailed information, please refer to our ',
                  ),
                  TextSpan(
                    text: 'Privacy Policy.',
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = _launchURL,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // User-Generated Content
            const Text(
              '5. User-Generated Content',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'If the App allows you to submit content (such as text, images, or other media), you agree that:\n\n'
                  '• You have all necessary rights to the content.\n'
                  '• You will not submit content that violates the rights of others, is unlawful, or is objectionable.\n'
                  '• We may moderate, remove, or block access to content that violates these terms.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Zero Tolerance for Abusive Content
            const Text(
              '6. Zero Tolerance for Objectionable Content and Abusive Users',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'We maintain a zero-tolerance policy for abusive behavior, harassment, or inappropriate content. By using the App, you agree to the following:\n\n'
                  '• Abusive Behavior: You will not engage in any form of abusive behavior or harassment towards other users, whether through text, images, or any other means within the App.\n'
                  '• Inappropriate Content: You agree not to post or share any content that is illegal, offensive, discriminatory, or harmful to others.\n'
                  '• User Blocking: The App allows users to block other users who engage in abusive behavior or violate our policies. We also provide a reporting mechanism to flag inappropriate content and users.\n'
                  '• Penalties: If you are found to be in violation of these terms, we may suspend or permanently ban your account from accessing the App.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Prohibited Activities
            const Text(
              '7. Prohibited Activities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'You may not use the App to:\n\n'
                  '• Engage in abusive, harassing, or unlawful behavior.\n'
                  '• Solicit, encourage, or facilitate illegal activities, including but not limited to illegal dating behavior, harassment, or exploitation.\n'
                  '• Engage in spamming or unsolicited communication.\n'
                  '• Engage in any other activity that could harm the integrity, functionality, or reputation of the App.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Termination
            const Text(
              '8. Termination',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'We may terminate or suspend your access to the App at any time, without notice, for any violation of this Agreement or any other reason. Upon termination, all rights granted to you under this Agreement will immediately cease, and you must delete or uninstall the App from your Authorized Device.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Disclaimer of Warranties
            const Text(
              '9. Disclaimer of Warranties',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'The App is provided "as is" and without warranties of any kind, either express or implied, including but not limited to the implied warranties of merchantability, fitness for a particular purpose, or non-infringement. We do not warrant that the App will meet your requirements or be uninterrupted or error-free.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Limitation of Liability
            const Text(
              '10. Limitation of Liability',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'To the maximum extent permitted by applicable law, we will not be liable for any indirect, incidental, special, consequential, or punitive damages arising from your use of the App, even if we have been advised of the possibility of such damages. Our total liability, if any, will not exceed the amount you paid for the App.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Indemnification
            const Text(
              '11. Indemnification',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'You agree to indemnify, defend, and hold harmless Myanmar Online Creations from and against any claims, liabilities, damages, losses, and expenses (including legal fees) arising from your use of the App or any violation of this Agreement.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Governing Law
            const Text(
              '12. Governing Law',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'This Agreement will be governed by and construed in accordance with the laws of Myanmar, without regard to its conflict of law principles. You agree to submit to the exclusive jurisdiction of the courts located in Myanmar for the resolution of any disputes arising under this Agreement.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Amendments
            const Text(
              '13. Amendments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'We may modify this Agreement at any time. Any changes will be posted within the App or on our website. Your continued use of the App after the changes are posted will constitute your acceptance of the modified Agreement.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Contact Information
            const Text(
              '14. Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'For more information and any questions pls email us hello@phoosar.com or mail us at:\n\n'
                  'Myanmar Online Creations\n'
                  'No.22/24, Yaw Min Gyi Road, Dagon Township, Yangon, Myanmar',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
