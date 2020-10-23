import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  TransactionList(this.transactions, this.deleteTransaction);
  @override
  Widget build(BuildContext context) {
    print('## build() TransactionList');
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    "No transactions added yet",
                    style: Theme.of(context).textTheme.title,
                  ),
                  const SizedBox(height: 20),
                  Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset('assets/images/waiting.png',
                          fit: BoxFit.cover)),
                ],
              );
            },
          )
          //On the 10.2020 ListView.buidler has a bug when using key argument
/*         : ListView.builder( 
            itemBuilder: (context, index) {
              return TransactionItem(
                  // key: UniqueKey(), //not use random generated key
                  key: ValueKey(transactions[index].id),
                  transaction: transactions[index],
                  deleteTransaction: deleteTransaction);
            },
            itemCount: transactions.length,
          ); */
          //Therefore we use ListView constructor:
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                    // key: UniqueKey(), //not use random generated key
                    key: ValueKey(tx.id),
                    transaction: tx,
                    deleteTransaction: deleteTransaction))
                .toList());
  }
}
