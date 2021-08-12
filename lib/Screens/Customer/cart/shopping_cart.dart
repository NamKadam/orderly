import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Screens/Customer/cart/cart_list_item.dart';
import 'package:orderly/Widgets/app_button.dart';

class ShoppingCart extends StatefulWidget{
  _ShoppingCartState createState()=>_ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart>{

  ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: Text('Shopping Cart',style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
          color: AppTheme.textColor
        ),),
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child:Icon(Icons.arrow_back_ios,color: AppTheme.textColor,)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child:
              ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 0.0,
                    );
                  },
                  // itemCount: state.members.length,
                  // itemCount: memberlist.length,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: (){
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //         new MemberDetails(userListData:memberlist[index])));

                        },
                        child:
                        // CartListItem(memberlist[index])
                        CartListItem()
                    );
                  }),
              //   return MembersList(memberlist[index]);
              // }),
            ),
           Padding(padding: EdgeInsets.only(left:30.0,right:30.0,bottom:10.0,top:10.0),
                    child:
                    AppButton(
                      onPressed: (){
                        // _signUp();
                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
                      },
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                      text: 'Buy Now',
                      // loading: login is LoginLoading,
                      // disableTouchWhenLoading: true,
                    )
                )
            
          ],
        ),
      ),
    );
  }

}