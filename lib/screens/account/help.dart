import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/help.jpg',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  FAQCard(
                    question: 'How do I place an order?',
                    answer:
                        'To place an order, browse our products and select the items you want. Then, add them to your cart and proceed to checkout.',
                  ),
                  FAQCard(
                    question: 'How do I track my order?',
                    answer:
                        'Once your order is confirmed, you will receive a confirmation email with a tracking number. You can use this tracking number to track the status of your order on our website.',
                  ),
                  FAQCard(
                    question: 'What if I have a problem with my order?',
                    answer:
                        'If you have any problems with your order, please contact our customer support team at support@pharmacyapp.com. We will do our best to resolve the issue as quickly as possible.',
                  ),
                  FAQCard(
                    question: 'How can I cancel my order?',
                    answer:
                        'To cancel your order, please contact our customer support team at support@pharmacyapp.com as soon as possible. If your order has not yet been shipped, we will cancel it and issue a refund.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQCard extends StatefulWidget {
  final String question;
  final String answer;

  const FAQCard({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  _FAQCardState createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(widget.question),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(widget.answer),
            ),
        ],
      ),
    );
  }
}
