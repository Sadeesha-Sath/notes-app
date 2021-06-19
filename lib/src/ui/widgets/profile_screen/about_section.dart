import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/profile_screen_listtile.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ProfileScreenListTile(
            title: "About Us",
            icon: Icons.info_outline_rounded,
            onTap: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (context, anim1, anim2) {
                  return AboutDialog(
                    applicationIcon: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 7.5),
                      height: 75,
                      child: Image(
                        image: AssetImage('assets/app_icon.png'),
                      ),
                    ),
                    applicationName: "Notes App",
                    applicationVersion: "0.1.0",
                    applicationLegalese:
                        'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.',
                  );
                },
                transitionDuration: Duration(milliseconds: 260),
                barrierDismissible: !Platform.isIOS,
                barrierLabel: "",
                transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
                  opacity: CurvedAnimation(
                    curve: Curves.easeInOutCubic,
                    parent: anim1,
                  ),
                  child: ScaleTransition(
                    scale: CurvedAnimation(curve: Curves.easeInOutCubic, parent: anim1),
                    child: child,
                  ),
                ),
              );
            },
          ),
          ProfileScreenListTile(
            title: "Rate Us",
            icon: Icons.star_outline_outlined,
            onTap: () {},
          ),
          ProfileScreenListTile(
            title: "View Licences",
            // icon: Icons.document_scanner_outlined,
            icon: CupertinoIcons.doc_text,
            onTap: () {
              showLicensePage(
                context: context,
                applicationIcon: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 100,
                  child: Image(
                    image: AssetImage('assets/app_icon.png'),
                  ),
                ),
                applicationName: "Notes App",
                applicationVersion: "0.1.0",
                applicationLegalese:
                    'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.',
              );
            },
          ),
        ],
      ),
    );
  }
}
