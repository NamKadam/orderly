import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Screens/Customer/orders/order_list_item.dart';
import 'package:orderly/Screens/Customer/orders/orders_filter.dart';

class MyOrders extends StatefulWidget{
  _MyOrdersState createState()=>_MyOrdersState();
}

class _MyOrdersState extends State<MyOrders>{
  final TextEditingController _searchcontroller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(title: Text("My Orders"),),
      body: Container(
        child: Column(
          children: [
            //search with filter
            Padding(padding: EdgeInsets.only(left: 15.0,right: 15.0,top:10.0,bottom: 10.0),
        child:Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),

                  color:
                  Colors.white,

                ),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset(Images.search,width: 25.0,height: 25.0,),
                        onPressed: () {

                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top:5.0),
                        width: 200.0,
                        height: 45.0,
                        child:TextFormField(
                        controller:_searchcontroller,
                        style: TextStyle(
                            fontFamily: 'Poppins',color: AppTheme.textColor,fontSize: 14.0,fontWeight: FontWeight.w400
                        ),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search for all filters",
                          hintStyle: TextStyle(
                            color: AppTheme.textColor
                          )
                        ),
                        onChanged: (value) {
                          // this.phoneNo=value;
                          print(value);
                        },
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10.0),
                        width: 1,
                        height: 20.0,
                        color: AppTheme.textColor,
                      ),
                      Text(
                        'Filters',
                        style: TextStyle(
                          color: AppTheme.textColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins'
                        ),
                      ),
                      IconButton(
                        icon: Image.asset(Images.filter,width: 20.0,height: 20.0,),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  new OrdersFilter())
                          );
                        },
                      ),

                    ],
                  )


                  //text
                ],
              )
            )
            ),

            //for list of orders
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
                        OrderListItem()
                    );
                  }),
              //   return MembersList(memberlist[index]);
              // }),
            ),

          ],

        ),
      ),
    );
  }

}