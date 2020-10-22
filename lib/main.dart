import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  // //This expression should be written before the setting screen orientations:
  // WidgetsFlutterBinding.ensureInitialized();
  //Set possible screen orientations
/*   SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
  ); */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return MaterialApp(
      title: "Personal Expenses",
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];
  bool showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((transaction) {
      return transaction.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(
    String txTitle,
    double txAmount,
    DateTime choosenDate,
  ) {
    final newTransaction = new Transaction(
        title: txTitle,
        amount: txAmount,
        date: choosenDate,
        // date: DateTime.now(),
        id: DateTime.now().toString());
    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext buildContext) {
    showModalBottomSheet(
      context: buildContext,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
        /* // For the older versions of Flutter, to avoid close BottomSheet with "tap"
         return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        ); */
      },
    );
  }

  List<Widget> _builderLandscapeContent(Widget chart, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          //Switch added for to make more correct screen view in landscape mode
          Switch.adaptive(
            //adaptive - adjust the look based on the platform
            activeColor: Theme.of(context).accentColor,
            value: showChart,
            onChanged: (val) {
              setState(() {
                showChart = val;
              });
            },
          ),
        ],
      ),
      showChart ? chart : txListWidget
    ];
  }

  Widget _builderCupertinoAppBar(BuildContext buildContext) {
    return CupertinoNavigationBar(
      middle: Text("Personal Expenses"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () {
              _startAddNewTransaction(buildContext);
            },
          ),
        ],
      ),
    );
  }

  Widget _builderAndroidAppBar(BuildContext buildContext) {
    return AppBar(
      title: Text("Personal Expenses"),
      actions: [
        IconButton(
          icon: Icon(Icons.add_box),
          onPressed: () {
            _startAddNewTransaction(buildContext);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    //appbar instanse:
    //if we do not explicitly specify the PreferredSizeWidget type for
    //the 'appBar' instance, then using 'appBar' in 'navigationBar:'
    //causes an error, because Dart cannot infer this type implicitly.
    final PreferredSizeWidget appBar = Platform.isIOS
        ? _builderCupertinoAppBar(buildContext)
        : _builderAndroidAppBar(buildContext);

    final chart = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          (isLandscape ? 0.7 : .30),
      child: Chart(_recentTransactions),
    );

    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.70,
      child: TransactionList(_userTransactions, deleteTransaction),
    );

    // Safe Area included for IOs in order to a navigationBar
    //not overlapping widget below
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (isLandscape) ..._builderLandscapeContent(chart, txListWidget),
            if (!isLandscape) ...[chart, txListWidget],
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(buildContext),
                  ),
          );
  }
}
