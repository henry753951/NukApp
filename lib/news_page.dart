// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:unicons/unicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:requests/requests.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'theme.dart';
import 'user.dart';
import 'login.dart';
import 'account.dart';

import 'new_window.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class New {
  String title = "Just Test New";
  String time = "Just Test time";
  String url = "Just Test url";

  New(this.title, this.time, this.url);
  factory New.fromJson(dynamic json) {
    return New(
        json['title'] as String, json['time'] as String, json['url'] as String);
  }
}

class _NewsPageState extends State<NewsPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  late TabController _tabController;
  var cacheData = {
    "公告": {'loading': true, 'data': <New>[], 'more': ''},
    "研討會": {'loading': true, 'data': <New>[], 'more': ''},
    "演講活動": {'loading': true, 'data': <New>[], 'more': ''},
    "推廣教育": {'loading': true, 'data': <New>[], 'more': ''},
    "各單位公告": {'loading': true, 'data': <New>[], 'more': ''},
    "徵才": {'loading': true, 'data': <New>[], 'more': ''},
  };

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 6, vsync: this);
    refresh();
    print(cacheData);
  }

  refresh() async {
    await get_data("公告");
    setState(() {});
    await get_data("研討會");
    setState(() {});
    await get_data("演講活動");
    setState(() {});
    await get_data("推廣教育");
    setState(() {});
    await get_data("各單位公告");
    setState(() {});
    await get_data("徵才");
    setState(() {});
  }

  get_data(String type) async {
    List<New> newsList = [];
    try {
      var url = 'https://nuk-app.herokuapp.com/api/v1/get_news?type=${type}';
      var response = await Requests.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = response.json();
        var jsonNesList = jsonResponse['news'] as List;
        cacheData[type]!['more'] = jsonResponse['more_href'];
        newsList = jsonNesList
            .map((jsonNesList) => New.fromJson(jsonNesList))
            .toList();
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print("Timeout.");
    }
    cacheData[type]!['data'] = newsList;
    cacheData[type]!['loading'] = false;
  }

  Future<Map?> future_getNews(String type) async {
    return cacheData[type];
  }

  Future<void> _pullRefresh(type) async {
    await get_data(type);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: const [CupertinoSearchTextField()],
          ),
        ),
        Container(
            padding: const EdgeInsets.only(bottom: 3),
            width: double.maxFinite,
            child: TabBar(
                labelPadding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 8, top: 3),
                isScrollable: true,
                labelColor: Theme.of(context).highlightColor,
                unselectedLabelColor: Theme.of(context).hintColor,
                indicator: CircleTabIndicator(
                    color: Theme.of(context).primaryColor, radius: 4),
                controller: _tabController,
                tabs: const [
                  Text("最新消息", style: TextStyle(fontSize: 20)),
                  Text("研討會", style: TextStyle(fontSize: 20)),
                  Text("演講活動", style: TextStyle(fontSize: 20)),
                  Text("推廣教育", style: TextStyle(fontSize: 20)),
                  Text("單位公告", style: TextStyle(fontSize: 20)),
                  Text("徵才", style: TextStyle(fontSize: 20)),
                ])),
        Expanded(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBarView(controller: _tabController, children: [
                  NewCard("公告"),
                  NewCard("研討會"),
                  NewCard("演講活動"),
                  NewCard("推廣教育"),
                  NewCard("各單位公告"),
                  NewCard("徵才"),
                ]),
              )),
        )
      ],
    );
  }

  FutureBuilder<Map?> NewCard(String type) {
    return FutureBuilder<Map?>(
      future: future_getNews(type),
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data!['loading'] == true) {
          return Center(
            child: LoadingAnimationWidget.inkDrop(
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () => _pullRefresh(type),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!['data'].length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return NewWindow(
                              url: snapshot.data!['data']![i].url,
                              title: snapshot.data!['data']![i].title);
                        }));
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius: BorderRadius.circular(25)),
                        padding: const EdgeInsets.all(22.0),
                        child: Column(
                          children: [
                            Text(snapshot.data!['data']![i].title,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 2,
                                style: TextStyle(fontSize: 20)),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(snapshot.data!['data']![i].time,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 18)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
        }
      },
    );
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;

  CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final double radius;
  late Color color;
  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    late Paint _paint;
    _paint = Paint()..color = color;
    _paint = _paint..isAntiAlias = true;
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
