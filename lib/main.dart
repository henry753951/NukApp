// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:unicons/unicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:requests/requests.dart';

import 'theme.dart';
import 'user.dart';
import 'login.dart';
import 'account.dart';

import 'news_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Home());
}

PageStorageKey _pageStorageKey = new PageStorageKey("PageStorageKey");

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: ThemeClass.lightTheme,
      darkTheme: ThemeClass.darkTheme,
      home: const MyHomePage(title: 'NUK'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController(keepPage: true);
  int _currentIndex = 0;
  String welcome_msg = "早上好";
  Student user = Student();
  void initState() {
    user = Student(
        department_code: "",
        department_name: "",
        name: "",
        id: "",
        entry_year: "",
        isInitialized: false);
    getUserdata();
  }

  getUserdata() async {
    var userInfoResponse = await Requests.get(
        'https://nuk-app.herokuapp.com/api/v1/get_user_info',
        persistCookies: true,
        bodyEncoding: RequestBodyEncoding.FormURLEncoded);
    if (userInfoResponse.statusCode == 200 &&
        userInfoResponse.json()['IsLogined']) {
      setState(() {
        user = Student(
          department_code: userInfoResponse.json()['student_department_code'],
          department_name: userInfoResponse.json()['student_department_name'],
          name: userInfoResponse.json()['student_name'],
          id: userInfoResponse.json()['student_id'],
          entry_year: userInfoResponse.json()['student_entrance_year'],
          isInitialized: true,
        );
      });
    }
  }

  final PageStorageBucket _bucket = new PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        body: SafeArea(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  }
                  _currentIndex = page;
                });
              },
              children: [HomePage(context), NewsPage()],
            ),
          ),
        ),
        bottomNavigationBar: _buildOriginDesign(context),
      ),
    );
  }

  Column HomePage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  child: Icon(UniconsLine.bars),
                  onTap: () {},
                ),
                GestureDetector(
                    child: Container(
                        padding: const EdgeInsets.all(13.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle),
                        child: Icon(UniconsLine.user, color: Colors.white)),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) {
                          if (user.isInitialized) {
                            return Account(user: user);
                          }
                          return Login(
                            logindone: (Student newuser) {
                              setState(() {
                                user = newuser;
                              });
                            },
                          );
                        }),
                      );
                    })
              ],
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(welcome_msg + ", ", style: TextStyle(fontSize: 30)),
                      Text((user.isInitialized ? user.name : "同學"),
                          style: TextStyle(
                              fontSize: 29, fontWeight: FontWeight.bold))
                    ],
                  )),
              Container(
                  alignment: Alignment.topLeft,
                  child: Text((user.isInitialized ? "今天沒有課囉!" : "您尚未登入"),
                      style: TextStyle(fontSize: 15))),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  QuickButton(
                    context,
                    FaIcon(
                      FontAwesomeIcons.table,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  QuickButton(
                    context,
                    FaIcon(
                      FontAwesomeIcons.book,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  QuickButton(
                    context,
                    FaIcon(
                      FontAwesomeIcons.userGraduate,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  QuickButton(
                    context,
                    FaIcon(
                      FontAwesomeIcons.ellipsis,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Container(
                  alignment: Alignment.topLeft,
                  child: Text("今日課程", style: TextStyle(fontSize: 22))),
              TodayClass()
            ],
          ),
        )
      ],
    );
  }

  Container QuickButton(BuildContext context, child) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(1, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(padding: const EdgeInsets.all(20.0), child: child));
  }

  Widget _buildTitle() {
    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: Color(0xff040307),
      strokeColor: Color(0x30040307),
      unSelectedColor: Color(0xffacacac),
      backgroundColor: Colors.white,
      items: [
        CustomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("首頁"),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.campaign_rounded),
          title: Text("消息"),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.lightbulb_outline),
          title: Text("功能"),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text("搜尋"),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          title: Text("帳號"),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Widget _buildOriginDesign(context) {
    return CustomNavigationBar(
      selectedColor: Theme.of(context).primaryColorDark,
      strokeColor: Color(0x30040307),
      unSelectedColor: Color(0xffacacac),
      backgroundColor: Theme.of(context).backgroundColor,
      iconSize: 30.0,
      scaleFactor: 0.5,
      items: [
        CustomNavigationBarItem(
          icon: Icon(Icons.home),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.campaign_rounded),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.lightbulb_outline),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.search),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.account_circle),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 250), curve: Curves.ease);
          _currentIndex = index;
        });
      },
    );
  }

  alert(String msg) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('提示'),
              content: Text(msg),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}

class TodayClass extends StatefulWidget {
  const TodayClass({
    Key? key,
  }) : super(key: key);

  @override
  State<TodayClass> createState() => _TodayClassState();
}

class _TodayClassState extends State<TodayClass> {
  ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("$_scrollPosition"),
        Container(
          height: 150,
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [
                  (_scrollPosition <= 20)
                      ? Colors.white.withOpacity(1 -
                          ((_scrollPosition > 20 || _scrollPosition < 0)
                              ? 0.0
                              : (_scrollPosition / 20.0)))
                      : Colors.transparent,
                  for (var i = 0; i < 10; ++i) Colors.white,
                  Colors.transparent
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                tileMode: TileMode.mirror,
              ).createShader(bounds);
            },
            child: ListView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: List.generate(8, (int index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        right: 16.0, top: 8.0, bottom: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Theme.of(context).primaryColorLight,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(1, 3))
                          ]),
                      width: 260.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                alignment: Alignment.topLeft,
                                child: Text("下午 01:10",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold))),
                            Container(
                                alignment: Alignment.topLeft,
                                child: Text("微積分",
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold))),
                            Container(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    FaIcon(FontAwesomeIcons.locationDot,
                                        color:
                                            Theme.of(context).primaryColorDark),
                                    SizedBox(width: 10),
                                    Text("綜合大樓207",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color:
                                                Theme.of(context).hintColor)),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                })),
          ),
        ),
      ],
    );
  }
}
