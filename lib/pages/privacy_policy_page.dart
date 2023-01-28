import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PrivacyPolicyPage extends StatelessWidget {
  static const String routeName = 'privacyPolicyRoute';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 16.0,
        ),
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'Army NonCom Tools built the ACFT Calculator app as a Freemium app. This Serivce is provided by Army NonCom Tools at no '
                      'cost and is intended for use as is. This page is used to inform visitors regarding our policies with the collection, use, '
                      'and disclosure of Personal Information if anyone decided to use our Service. If you choose to use our Service, then you '
                      'agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used '
                      'for providing and improving the Service. We will not use or share your information with anyone except as described in this '
                      'Privacy Policy.'),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Information Collection and Use',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'For a better experience, while using our Service, we may require you to provide us with certain personally identifiable '
                      'information, including but not limited to Name, Email Address, Device Information, Cookies, Geographical Information, and '
                      'Advertising Id. The information that we request will be retained by us and used as described in this privacy policy. '
                      '\nThe app does use third party services that may collect information used to identify you.'
                      '\nLink to privacy policy of third party service providers used by the app'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: const Text(
                      'Google Play Services',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue),
                      textAlign: TextAlign.start,
                    ),
                    onTap: () {
                      launchUrlString(
                          'https://www.google.com/policies/privacy/');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: const Text(
                      'AdMob',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue),
                      textAlign: TextAlign.start,
                    ),
                    onTap: () {
                      launchUrlString(
                          'https://support.google.com/admob/answer/6128543?hl=en');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: const Text(
                      'Firebase Analytics',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue),
                      textAlign: TextAlign.start,
                    ),
                    onTap: () {
                      launchUrlString(
                          'https://firebase.google.com/policies/analytics');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Log Data',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'We want to inform you that whenever you use our Service, in a case of an error in the app we collect data and '
                      'information (through third party products) on your phone called Log Data. This Log Data may include information such as '
                      'your device Internet Protocol (IP) address, device name, operating system version, the configuration of the app '
                      'when utilizing our Service, the time and date of your use of the Service, and other statistics.'),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Cookies',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are '
                      'sent to your browser from the websites that you visit and are stored on your device\'s internal memory. This Service does '
                      'not use these cookies explicitly. However, the app may use third party code and libraries that use cookies to '
                      'collect information and improve their services. You have the option to either accept or refuse these cookies and know when '
                      'a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of '
                      'this Service.'),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Service Providers',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'We may employ third-party companies and individuals due to the following reasons:\n'
                      '\n•	To facilitate our Service;'
                      '\n•	To provide the Service on our behalf;'
                      '\n•	To perform Service-related services; or'
                      '\n•	To assist us in analyzing how our Service is used.'
                      '\n\nWe want to inform users of this Service that these third parties have access to your Personal Information. The reason '
                      'is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information '
                      'for any other purpose.'),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Security',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable '
                      'means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% '
                      'secure and reliable, and we cannot guarantee its absolute security.'),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Links to Other Sites',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. '
                      'Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these '
                      'websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party '
                      'sites or services.'),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Children\'s Privacy',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'This Service is not directed toward children and we do not collect or store information on children. If you are a parent '
                      'or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able '
                      'to do necessary actions. '),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Changes to This Privacy Policy',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any '
                      'changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective '
                      'immediately after they are posted on this page. '),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Contact Us',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at armynoncomtools@gmail.com.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
