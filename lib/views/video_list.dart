import 'package:flutter/material.dart';
import '../net/httpclient.dart';
import '../net/http_config.dart';
import '../models/news.dart';
import 'dart:convert';
import 'news_detail.dart';
import '../util/imageutil.dart';

class VideoListPage extends StatefulWidget {
  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage>{
  ScrollController _scrollController = ScrollController();
  NewsList videolist;
  int size = 0;

  _getMoreData(){
    HttpClient.request(VIDEO_API).then((res){
      Map<String,dynamic> subjects  = json.decode(res.data) as Map;
      setState(() {
        this.videolist = NewsList.fromJson(subjects);
        this.size = videolist.result.length;
      });
    });
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1)).then((e){
      setState(() {
        //  newslist.result.clear();
        _getMoreData();
      });
    });
  }

  @override
  void initState(){
    super.initState();
    _getMoreData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new RefreshIndicator(
        onRefresh: _onRefresh,
        child: new ListView.separated(
          itemCount: size,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index){
            return GestureDetector(
              onTap: (){
                 Navigator.push(context, MaterialPageRoute(
                      builder: (context) => new NewsDetailPage(news:videolist.result[index])
                 )
                );
              },
              child: Card(
                margin: EdgeInsets.only(left: 5,right: 5,top: 0,bottom: 0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                              child: Image.network(videolist.result[index].image, fit: BoxFit.fill),
                              decoration: BoxDecoration(color: Colors.black54)
                          ),
                          Container(
                            child: Text(videolist.result[index].title,
                              style: TextStyle(fontSize:20,color: Colors.white,shadows:[
                                BoxShadow(color: Colors.black54,offset: Offset(0.1,0.1), blurRadius: 5.0)
                              ])),
                          )

                        ],
                      )
                    ),
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 10.0,
                              backgroundImage: AssetImage(getAvatarPath(videolist.result[index].source))
                            ),
                            Text(' ',style: TextStyle(fontSize:18),),
                            Text(videolist.result[index].authorName,
                              style: TextStyle(fontSize:18),),
                          ],
                        ),
                        Text('',style: TextStyle(fontSize:18),),
                        Text("${videolist.result[index].playCount}次播放",
                          style: TextStyle(fontSize:18),),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    ),

//                  Icon(Icons.people),
//                  Text(newslist.result[index].authorName,
//                    overflow: TextOverflow.ellipsis,
//                    style: TextStyle(fontSize:18),)
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
      ),
    );

    //return buildGridView();
  }




}


