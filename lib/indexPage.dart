import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:travelgram/page_for_food.dart';
import 'package:travelgram/page_for_guide.dart';
import 'package:travelgram/page_for_hotel.dart';
import 'package:travelgram/page_for_user.dart';

import 'auth/user_provider.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userModel = userProvider.userModel;
    if (userModel!.type == "hotel") {
      return IndexPageHotel();
    } else {
      if (userModel.type == "traveller") {
        return IndexPageUser();
      } else {
        if (userModel.type == "food") {
          return IndexPageFood();
        } else {
          return IndexPageGuide();
        }
      }
    }
    return Container();
  }
}
