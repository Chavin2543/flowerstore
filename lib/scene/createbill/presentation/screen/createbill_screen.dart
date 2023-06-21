import 'package:flowerstore/scene/createbill/presentation/widget/createbill_item.dart';
import 'package:flowerstore/scene/createbill/presentation/widget/prefill_item_section.dart';
import 'package:flowerstore/scene/dashboard/data/model/customer.dart';
import 'package:flutter/material.dart';

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen(Customer customer, {Key? key}) : super(key: key);

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "สร้างบิล",
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: const [
          PrefillItemSection(),
        ],
      ),
    );
  }
}
