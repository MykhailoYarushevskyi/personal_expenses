import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addToList;
  NewTransaction(this.addToList);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  bool isEmptyOrNull(String text) {
    if (text == null || text == "") return true;
    return false;
  }

  void showError(BuildContext context, String errorText) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return new Text(
            errorText,
            style: TextStyle(
                color: Colors.redAccent,
                fontSize: 28,
                fontWeight: FontWeight.bold),
          );
        });
  }

  void submitData() {
    if (isEmptyOrNull(titleController.text) ||
        isEmptyOrNull(amountController.text)) {
      showError(context, 'Some Data is empty or null!');
      return;
    }
    String enteredTitle = titleController.text;
    double enteredAmount = double.parse(amountController.text);
    if (enteredAmount <= 0) {
      showError(context, 'The amount must be greater than 0!');
      return;
    }
    widget.addToList(enteredTitle, enteredAmount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        // margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: "Title",
              ),
              // onChanged: (value) {
              //   inputTitle = value;
              // },
              controller: titleController,
              // keyboardType: TextInputType.text,
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Amount",
              ),
              // onChanged: (value) => inputAmount = value,
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submitData(),
              // onSubmitted: (str) => submitData, (if submitData() is with String argument)
            ),
            FlatButton(
              child: Text("Add transaction"),
              textColor: Colors.purple,
              onPressed: submitData,
            ),
          ],
        ),
      ),
    );
  }
}
