
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constatnts/color_constants.dart';
import '../constatnts/constants.dart';
import 'google_news_screen.dart';
import 'helper/theme_provider.dart';

class NewsDetailsScreen extends StatefulWidget {
  final String img;
  final String description;
  final String title;
  final String publishedAt;
  final String name;
  final String content;
  final String url;

  const NewsDetailsScreen({
    super.key,
    required this.img,
    required this.description,
    required this.title,
    required this.publishedAt,
    required this.name,
    required this.content,
    required this.url,
  });

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        //toolbarHeight: 50,
        iconTheme: IconThemeData(
        ),
        backgroundColor: themeProvider.isDarkMode ? DarkPrimaryColor : LightPrimaryColor,
        title: Text('News Detail Screen',
            style: TextStyle( fontFamily: 'Nunito-ExtraBold',fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 210,
                margin: EdgeInsets.only(top: 5, bottom: 15, left: 1, right: 1),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.img != null && widget.img.isNotEmpty ? widget.img : Appimage.defaultImageUrl,
                    ),
                    fit: BoxFit.fill,
                  ),),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Center(
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center, // Aligns children to the center
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "${widget.name} | ${widget.publishedAt}",
                          style: TextStyle(
                            fontFamily: 'Nunito-light',
                            fontSize: 14,
                            color: Color(0xff757575),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 8, left: 5, right: 5),
                decoration: BoxDecoration(),
                child: Text(
                  "${widget.title}",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Nunito-Bold',
                    ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(
                  "${widget.description}\n",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                      fontFamily: 'Nunito-Medium',
                    color: Color(0xff757575),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(
                  "${widget.content}",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      fontFamily: 'Nunito-Medium',
                      color: Color(0xff757575)),
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                alignment: Alignment.centerLeft,
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoogleNewsScreen(
                            url: widget.url,
                            title: widget.title,
                            name: widget.name,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Read Full Article',
                      style: TextStyle(color: Color(0xffef5252),fontFamily: 'Nunito-ExtraBold', fontSize: 20,decoration: TextDecoration.underline,decorationColor: Color(0xffef5252),),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
