import 'package:flutter/material.dart';

class PrefillItemSection extends StatelessWidget {
  const PrefillItemSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: constraints.maxWidth / 2,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Text("data"),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: constraints.maxWidth / 2,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Text("data", style: Theme.of(context).textTheme.displayLarge,),
                    Text("data", style: Theme.of(context).textTheme.displayLarge,),
                    Text("data", style: Theme.of(context).textTheme.displayLarge,),
                    Text("data", style: Theme.of(context).textTheme.displayLarge,),
                    Text("data", style: Theme.of(context).textTheme.displayLarge,),
                    Text("data", style: Theme.of(context).textTheme.displayLarge,),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
