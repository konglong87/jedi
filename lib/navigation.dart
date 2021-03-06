import 'package:flutter/material.dart';
import 'package:jedi/home/home.dart';
import 'package:jedi/category/category.dart';
import 'package:jedi/community/community.dart';
import 'package:jedi/earnings/earnings.dart';
import 'package:jedi/my/my.dart';
import 'package:flutter/services.dart';
import 'package:jedi/blocks/amoy_password.dart';

/// 自定义的导航项目类，包含底部导航栏项目（`BottomNavigationBarItem`）组件需要的数据。
class NavigationItem {
  final String icon;
  final String activeIcon;
  final String title;

  NavigationItem({
    this.icon,
    this.activeIcon,
    this.title,
  });
}

/// 自定义的导航页面组件。
class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

/// 与自定义的导航页面组件关联的状态子类。
class _NavigationPageState extends State<NavigationPage>
    with WidgetsBindingObserver {
  /// 当前选择的索引。
  int _selectedIndex = 0;

  /// 页面控制器（`PageController`）组件，页面视图（`PageView`）的控制器。
  PageController _controller = PageController();

  /// 范型为自定义的导航项目类的列表，用于统一管理导航项目。
  List<NavigationItem> navigationItem = [
    NavigationItem(
      icon: 'assets/navigation_home.png',
      activeIcon: 'assets/navigation_home_selected.png',
      title: '首页',
    ),
    NavigationItem(
      icon: 'assets/navigation_classify.png',
      activeIcon: 'assets/navigation_classify_selected.png',
      title: '分类',
    ),
    NavigationItem(
      icon: 'assets/navigation_society.png',
      activeIcon: 'assets/navigation_society_selected.png',
      title: '社区',
    ),
    NavigationItem(
      icon: 'assets/navigation_earnings.png',
      activeIcon: 'assets/navigation_earnings_selected.png',
      title: '收益',
    ),
    NavigationItem(
      icon: 'assets/navigation_my.png',
      activeIcon: 'assets/navigation_my_selected.png',
      title: '我的',
    ),
  ];

  /// 底部导航栏的组件选项。
  final _widgetOptions = [
    HomePage(),
    CategoryPage(),
    CommunityPage(),
    EarningsPage(),
    MyPage(),
  ];

  void _onItemTapped(int index) {
    // 创建底部导航栏的组件需要跟踪当前索引并调用`setState`以使用新提供的索引重建它。
    setState(() {
      _selectedIndex = index;
      // 跳到页面（`jumpToPage`）方法，更改显示在的页面视图（`PageView`）组件中页面。
      _controller.jumpToPage(index);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getClipboardContents();
    }
  }

  /// 使用异步调用获取系统剪贴板的返回值。
  getClipboardContents() async {
    ClipboardData clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text.trim() != '') {
      String _name = clipboardData.text.trim();
      if (RegExp(r'[\uffe5]+.+[\uffe5]').hasMatch(_name)) {
        // 导航器（`Navigator`）组件，用于管理具有堆栈规则的一组子组件。
        // 许多应用程序在其窗口组件层次结构的顶部附近有一个导航器，以便使用叠加显示其逻辑历史记录，
        // 最近访问过的页面可视化地显示在旧页面之上。使用此模式，
        // 导航器可以通过在叠加层中移动组件来直观地从一个页面转换到另一个页面。
        // 类似地，导航器可用于通过将对话框窗口组件放置在当前页面上方来显示对话框。
        // 导航器（`Navigator`）组件的关于（`of`）方法，来自此类的最近实例的状态，它包含给定的上下文。
        // 导航器（`Navigator`）组件的推（`push`）方法，将给定路径推送到最紧密包围给定上下文的导航器。
        Navigator.of(context)
            .push(
          // 页面路由生成器（`PageRouteBuilder`）组件，用于根据回调定义一次性页面路由的实用程序类。
          PageRouteBuilder(
            // 转换完成后路由是否会遮盖以前的路由。
            opaque: false,
            // 页面构建器（`pageBuilder`）属性，用于构建路径的主要内容。
            pageBuilder: (BuildContext context, _, __) {
              return AmoyPassword(
                password: _name,
              );
            },
          ),
        )
            .then((value) {
          // 如果自定义的综合排序组件返回不为空时，更新
          if (value != null) {
          } else {}
        });
        // // 使用命名路由导航到第二个屏幕。
        // Navigator.pushNamed(
        //   context,
        //   '/category/result',
        //   arguments: {
        //     'typeName': clipboardData.text,
        //   },
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* 因为下面的代码无法避免页面被动重新绘制，所以不使用。
      body: Center(
        // 元素在（`elementAt`）方法，返回列表元素。
        child: _widgetOptions.elementAt(_selectedIndex),
      ), */
      // 页面视图（`PageView`）组件，可逐页工作的可滚动列表，每个子项都被强制与视窗大小相同。
      body: PageView.builder(
        // 物理（`physics`）属性，页面视图应如何响应用户输入。
        // 从不可滚动滚动物理（`NeverScrollableScrollPhysics`）类，不允许用户滚动。
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _widgetOptions.elementAt(index);
        },
        itemCount: _widgetOptions.length,
        // 控制器（`controller`）属性，用于控制滚动此页面视图位置的对象。
        controller: _controller,
      ),
      // 底部导航栏（`bottomNavigationBar`）属性，显示在脚手架（`Scaffold`）组件的底部。
      // 底部导航栏（`BottomNavigationBar`）组件，显示在应用程序底部的组件，
      // 用于在几个屏幕之间中进行选择，通常在三到五之间，再多就不好看了。
      bottomNavigationBar: BottomNavigationBar(
        // 项目（`items`）属性，位于底部导航栏中的交互组件，其中每一项都有一个图标和标题。
        items: navigationItem.map((NavigationItem navigationItem) {
          // 底部导航栏项目（`BottomNavigationBarItem`）组件，通常嵌入在底部导航组件中。
          return BottomNavigationBarItem(
            // 图标（`icon`）属性，项目的图标。
            icon: Image.asset(
              navigationItem.icon,
              height: 22,
            ),
            // 活动图标（`activeIcon`）属性，选择此底部导航项时显示的替代图标。
            activeIcon: Image.asset(
              navigationItem.activeIcon,
              height: 22,
            ),
            // 标题图标（`title`）属性，该项目的标题。
            title: Text(navigationItem.title),
          );
        }).toList(),
        // 目前的索引（`currentIndex`）属性，当前活动项的项目索引。
        currentIndex: _selectedIndex,
        // 固定颜色（`fixedColor`）属性，当BottomNavigationBarType.fixed时所选项目的颜色。
        fixedColor: Color(0xffFE7C30),
        // 在���击（`onTap`）属性，点击项目时调用的回调。
        onTap: _onItemTapped,
        // 定义底部导航栏（`BottomNavigationBar`）组件的布局和行为。
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
