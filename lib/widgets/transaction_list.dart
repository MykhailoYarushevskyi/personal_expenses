import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  TransactionList(this.transactions);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // height: for avoid conflict with Column widget above at the tree
        /*If height: is not include,
       Exception caught by rendering library When a column is in a parent that does not provide a finite height constraint, for example if it is in a vertical scrollable, it will try to shrink-wrap its children along the vertical axis. Setting a flex on a child (e.g. using Expanded) indicates that the child is to expand to fill the remaining space in the vertical direction.
These two directives are mutually exclusive. If a parent is to shrink-wrap its child, the child cannot simultaneously expand to fit its parent.
Consider setting mainAxisSize to MainAxisSize.min and using FlexFit.loose fits for the flexible children (using Flexible rather than Expanded). This will allow the flexible children to size themselves to less than the infinite remaining space they would otherwise be forced to take, and then will cause the RenderFlex to shrink-wrap the children rather than expanding to fit the maximum constraints provided by the parent.
 */
        // height: 400, //300 - for our emulator, for example
        child: transactions.isEmpty
            ? Column(
                children: <Widget>[
                  Text(
                    "No transactions added yet",
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(height: 20),
                  Container(
                      height: 200,
                      child: Image.asset('assets/images/waiting.png',
                          fit: BoxFit.cover)),
                ],
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.5, color: Colors.purple)),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "\$${transactions[index].amount.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              transactions[index].title,
                              style: Theme.of(context).textTheme.title,
                              // style: TextStyle(
                              //   fontWeight: FontWeight.bold,
                              //   fontSize: 16,
                              // ),
                            ),
                            // Text(DateFormat('dd-MM-yyyy').format(tx.date),
                            Text(
                                DateFormat.yMMMd("en-US")
                                    .format(transactions[index].date),
                                style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      ],
                    ),
                  );
                },
                itemCount: transactions.length,
              ),
        // children: transactions.map((tx) { //for Column or ListView
        // ...
        // }).toList(),
      ),
    );
  }
}
