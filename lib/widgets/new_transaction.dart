import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;
  NewTransaction(this.addNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

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

  void _submitData() {
    if (_titleController.text.isEmpty ||
        _titleController.text == null ||
        _amountController.text.isEmpty ||
        _amountController.text == null ||
        _selectedDate == null) {
      showError(context, 'Some Data is empty or null!');
      return;
    }
    String enteredTitle = _titleController.text;
    double enteredAmount = double.parse(_amountController.text);
    if (enteredAmount <= 0) {
      showError(context, 'The amount must be greater than 0!');
      return;
    }
    widget.addNewTransaction(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
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
              controller: _titleController,
              // keyboardType: TextInputType.text,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Amount",
              ),
              // onChanged: (value) => inputAmount = value,
              controller: _amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData(),
              // onSubmitted: (str) => _submitData, (if _submitData() is with String argument)
            ),
            Container(
              height: 70,
              child: Row(children: <Widget>[
                Expanded(
                  child: Text(_selectedDate == null
                      ? 'No Date chosen'
                      : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'),
                ),
                FlatButton(
                  onPressed: () => _presentDatePicker(),
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    'Choose Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    // style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ]),
            ),
            RaisedButton(
              child: Text("Add transaction"),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button.color,
              // textColor: Theme.of(context).buttonColor,
              onPressed: _submitData,
            ),
          ],
        ),
      ),
    );
  }
}
