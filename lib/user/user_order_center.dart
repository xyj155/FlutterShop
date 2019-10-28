import 'package:flutter/material.dart';
import 'package:sauce_app/home/home_index.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/ScreenUtils.dart';

class UserOrderCenterPage extends StatefulWidget {
  @override
  UserOrderCenterPageState createState() => new UserOrderCenterPageState();
}

class UserOrderCenterPageState extends State<UserOrderCenterPage> with SingleTickerProviderStateMixin {

  ScreenUtils screenUtil=new ScreenUtils();
  final List<HomeTabList> myTabs = <HomeTabList>[
    new HomeTabList('全部订单', new UserOrderStatusFinishPay()),
  new HomeTabList( '已支付 ', new UserOrderStatusFinishPay()),
  new HomeTabList(' 配送中 ', new UserOrderStatusDeliver()),
  new HomeTabList(' 已完成 ', new UserOrderStatusHadFinish()),

  ];
  @override
  Widget build(BuildContext context) {
    screenUtil.initUtil(context);
    return new Scaffold(
      appBar: BackUtil.NavigationBack(context, "订单中心"),
      body: new Scaffold(
        primary:false,
        backgroundColor: Colors.white,
        appBar: TabBar(
          controller: tabController,
          indicatorColor: Color(0xff4ddfa9),
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelStyle: new TextStyle(
              fontSize: screenUtil.setFontSize(14),
              fontWeight: FontWeight.normal),
          labelStyle: new TextStyle(
              fontSize: screenUtil.setFontSize(14),
              fontWeight: FontWeight.bold),
          labelColor: Colors.black,
          unselectedLabelColor: Color(0xff707070),
          indicatorWeight: screenUtil.setFontSize(5),
          isScrollable: false,
          tabs: myTabs.map((HomeTabList item) {
            return new Tab(
                text: item.text == null ? '错误' : item.text);
          }).toList(),
        ),
        body: new TabBarView(
          children: myTabs.map((item) {
            return item.goodList;
          }).toList(),controller: tabController,),
      ),
    );
  }
  TabController tabController;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    tabController = TabController(vsync: this, length: myTabs.length,initialIndex: 1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
class UserOrderStatusFinishPay extends StatefulWidget {
  @override
  UserOrderStatusFinishPayState createState() => new UserOrderStatusFinishPayState();
}

class UserOrderStatusFinishPayState extends State<UserOrderStatusFinishPay> {
  @override
  Widget build(BuildContext context) {
    return new Container();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


}


class UserOrderStatusDeliver extends StatefulWidget {
  @override
  UserOrderStatusDeliverState createState() => new UserOrderStatusDeliverState();
}
class UserOrderStatusDeliverState extends State<UserOrderStatusDeliver> {
  @override
  Widget build(BuildContext context) {
    return new Container();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


}


class UserOrderStatusHadFinish extends StatefulWidget {
  @override
  UserOrderStatusHadFinishState createState() => new UserOrderStatusHadFinishState();
}
class UserOrderStatusHadFinishState extends State<UserOrderStatusHadFinish> {
  @override
  Widget build(BuildContext context) {
    return new Container();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


}
