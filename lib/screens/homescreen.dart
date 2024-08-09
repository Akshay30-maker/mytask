import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../blocs/homepage_news/homepage_news_bloc.dart';
import '../constatnts/appbar.dart';
import '../constatnts/color_constants.dart';
import '../constatnts/constants.dart';
import '../constatnts/no_internet_screen.dart';
import '../screens/helper/theme_provider.dart';
import 'news_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsApiBloc newsApiBloc = NewsApiBloc();

  @override
  void initState() {
    newsApiBloc.add(NewsApiData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: commonAppBar(context),
      body: BlocProvider(
        create: (context) => newsApiBloc,
        child: BlocBuilder<NewsApiBloc, NewsApiState>(
          builder: (context, state) {
            if (state is NewsApiLoading) {
              print("Getting News.....");
              return Center(
                child: CircularProgressIndicator(
                  color: themeProvider.isDarkMode ? DarkPrimaryColor : LightPrimaryColor,
                ),
              );
            }
            if (state is NewsApiLoaded) {
              print('--------------------');
              print("I am in Loaded state");
              print('--------------------');
              return ListView.builder(
                itemCount: state.newsModel.articles?.length ?? 0,
                itemBuilder: (context, index) {
                  final articles = state.newsModel.articles;
                  if (articles != null && articles.length > index) {
                    final article = articles[index];
                    final urlToImage = article.urlToImage ?? '';
                    final title = article.title ?? '';
                    final description = article.description ?? '';
                    final publishedAt = article.publishedAt ?? '';
                    final name = article.source?.name ?? '';
                    final content = article.content ?? '';
                    final url = article.url ?? '';
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailsScreen(
                              img: urlToImage,
                              description: description,
                              title: title,
                              publishedAt: publishedAt,
                              name: name,
                              content: content,
                              url: url,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeProvider.isDarkMode ? DarkSecondaryColor : LightPrimaryColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  ),
                                  child: FadeInImage(
                                    placeholder: AssetImage('assets/Spinner-2.gif'),
                                    image: NetworkImage(
                                      urlToImage.isNotEmpty ? urlToImage : Appimage.defaultImageUrl,
                                    ),
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return Image.asset(Appimage.defaultImageUrl); // Fallback image on error
                                    },
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: double.infinity,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Nunito-SemiBold',
                                    // color: themeProvider.isDarkMode ? Colors.amber[800] : Colors.blue,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Nunito-SemiBold',
                                    // color: themeProvider.isDarkMode ? Colors.amber[800] : Colors.blue,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      color: Colors.red,
                    );
                  }
                },
              );
            }
            if (state is NewsApiError) {
              return NoInternetScreen();
            }
            return Center(
              child: CircularProgressIndicator(
                color: themeProvider.isDarkMode ? DarkPrimaryColor : LightPrimaryColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
