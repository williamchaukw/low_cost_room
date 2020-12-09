import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/news.dart';

class NewsScreen extends StatefulWidget {
  static final route = '/news';
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool _isInitialized = false;

  Widget _newsCard(String title, String descrption, String image, String url) {
    return Card(
      child: ListTile(
          leading: CircleAvatar(
            backgroundImage: image != null
                ? NetworkImage(image)
                : AssetImage('assets/images/newspaper.png'),
          ),
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Text(title, softWrap: true),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final newsProvider = Provider.of<News>(context);

    if (!_isInitialized) {
      newsProvider.getAllNews().then((_) {
        setState(() {
          _isInitialized = true;
        });
      });
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          // height: deviceSize.height,
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                height: deviceSize.height / 3.5,
                child: Image.asset('assets/images/newspaper.png'),
              ),
              // RaisedButton(
              //   onPressed: () => newsProvider.getAllNews(),
              //   child: Text('Update news'),
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(8))),
              // ),
              SizedBox(height: 10),
              Container(
                height: deviceSize.height / 2,
                child: _isInitialized
                    ? ListView.builder(
                        shrinkWrap: false,
                        itemCount: newsProvider.newsList.length,
                        itemBuilder: (context, length) {
                          return _newsCard(
                            newsProvider.newsList[length].title,
                            newsProvider.newsList[length].description,
                            newsProvider.newsList[length].image,
                            newsProvider.newsList[length].url,
                          );
                        })
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
