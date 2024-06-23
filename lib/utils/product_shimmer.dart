import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_cart/utils/extension.dart';
import 'package:shopping_cart/utils/shimmer_effect.dart';

class TProductShimmer extends StatelessWidget {
  const TProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      shrinkWrap: true,
      itemBuilder: (_, __) {
        return  Column(
          children: [
            TShimmerEffect(width: context.width, height: context.height*0.15),
            SizedBox(
              height: context.height * 0.02,
            ),
             TShimmerEffect(width: context.width, height: context.height*0.05),
            const Spacer(),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TShimmerEffect(width:context.width * 0.07, height: context.height*0.04),
                TShimmerEffect( width: context.width * 0.05,height:  context.height * 0.04,),
              ],
            )
          ],
        );
      },
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        mainAxisExtent: context.height * 0.31,
      ),
    );
  }
}
