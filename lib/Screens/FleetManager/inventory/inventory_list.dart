import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_inventory.dart';
import 'package:orderly/Screens/FleetManager/inventory/add_edit_inventory_item.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_custom_switch/flutter_custom_switch.dart';


class Inventory extends StatefulWidget{
  _InventoryState createState()=>_InventoryState();
}

class _InventoryState extends State<Inventory>{
  bool isExpand=false;
  List<InventoryModel> inventoryList=[];
  bool isSwitched=true;
  final TextEditingController _searchcontroller = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInventoryList();
  }

  void getInventoryList() {
    for (int i = 0; i < 5; i++) {
      InventoryModel inventoryModel = new InventoryModel(
          id: i,
          inventoryName: "Prime Roof Truck",
          inventoryDesc: "Lorem ipsum color sit lorem ipsum sit lorem epsum sit",
          noOfItems: "4",
          rate: "25 \$hr",
          offer:"12",
      category: "Category Name",
      type: "TypeName",
      size: "200kb");

      inventoryList.add(inventoryModel);
    }
  }

  Widget buildInventoryList(int index,List<InventoryModel> _inventoryList){
    if(_inventoryList==null){
      return ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 15),
            child:
            Shimmer.fromColors(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 5,
                      bottom: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 10,
                          width: 180,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Container(
                          height: 10,
                          width: 150,
                          color: Colors.white,
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              baseColor: Theme.of(context).hoverColor,
              highlightColor: Theme.of(context).highlightColor,
            ),
          );
        },
        itemCount: 6,
      );
    }
    return Card(
        elevation: 0.0,
        child:
        ExpansionTile(
          trailing: Text(''),
          title: Padding(
            padding: const EdgeInsets.only(
              top: 5,
            ),
            child:
            Stack(
              // alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.transparent,
                  child:
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                filterQuality: FilterQuality.medium,
                                // imageUrl: Api.PHOTO_URL + widget.users.avatar,
                                // imageUrl:
                                //     "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                                imageUrl: inventoryList[index].inventoryImage == null
                                    ? "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"
                                    : inventoryList[index].inventoryImage,
                                placeholder: (context, url) {
                                  return Shimmer.fromColors(
                                    baseColor: Theme.of(context).hoverColor,
                                    highlightColor:
                                    Theme.of(context).highlightColor,
                                    enabled: true,
                                    child: Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                },
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  );
                                },
                                errorWidget: (context, url, error) {
                                  return Shimmer.fromColors(
                                    baseColor: Theme.of(context).hoverColor,
                                    highlightColor:
                                    Theme.of(context).highlightColor,
                                    enabled: true,
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(Icons.error),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(

                                              child:
                                              Text(
                                                inventoryList[index].inventoryName,
                                                // widget.users.firstName+" "+widget.users.lastName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppTheme.textColor,
                                                    fontFamily: "Poppins"),
                                              )),
                                          Switch(
                                            value: isSwitched,
                                            inactiveTrackColor: AppTheme.textColor.withOpacity(0.5),
                                            inactiveThumbColor:AppTheme.textColor ,
                                            activeColor: AppTheme.appColor,
                                            onChanged: (value){
                                              setState(() {
                                                isSwitched=value;
                                              });
                                            },
                                          )
                                          // FlutterCustomSwitch(
                                          //   value: isSwitched,
                                          //   onChanged: (value) {
                                          //     setState(() {
                                          //       isSwitched=value;
                                          //       print(isSwitched);
                                          //     });
                                          //   },
                                          //   // activeThumbImagePath: dayImage,
                                          //   inActiveColor: Colors.grey,
                                          //   activeColor: AppTheme.appColor,
                                          //   // inActiveThumbImagePath: nightImage,
                                          // ),
                                        ],
                                      ),

                                      Text(
                                        inventoryList[index].inventoryDesc,
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .copyWith(
                                            fontSize: 12.0,
                                            color: AppTheme.textColor,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins"),
                                      ),
                                      SizedBox(height: 15.0,),

                                    ],
                                  )),
                            ],
                          )),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Rate",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color:AppTheme.appColor
                                ),),
                              Text(_inventoryList[index].rate+" \$ hr",style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color:AppTheme.textColor
                              ),)
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("No. of Items",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color:AppTheme.appColor
                                ),),
                              Text(_inventoryList[index].noOfItems,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color:AppTheme.textColor
                                ),)
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Offer in %",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color:AppTheme.appColor
                                ),),
                              Text(_inventoryList[index].offer,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color:AppTheme.textColor
                                ),)
                            ],
                          )
                        ],
                      )

                    ],
                  ),
                ),
                // Positioned(
                //   right: 0.0,
                //   top: 0.0,
                //   child: Container(
                //     // margin: EdgeInsets.only(left: 70.0),
                //     // width:30.0,height:30.0,
                //       decoration: BoxDecoration(
                //         // color: Colors.greenAccent,
                //         // borderRadius: BorderRadius.circular(20.0),
                //       ),
                //       // margin: const EdgeInsets.symmetric(horizontal: 5.0,),
                //       child:
                //       Switch(
                //         value: isSwitched,
                //         inactiveTrackColor: Colors.grey,
                //           activeColor: AppTheme.appColor,
                //         onChanged: (value){
                //         setState(() {
                //               isSwitched=value;
                //              });
                //         },
                //       )
                //       // FlutterCustomSwitch(
                //       //   value: isSwitched,
                //       //   onChanged: (value) {
                //       //     setState(() {
                //       //       isSwitched=value;
                //       //      });
                //       //     },
                //       //   // activeThumbImagePath: dayImage,
                //       //   inActiveColor: Colors.grey,
                //       //   activeColor: AppTheme.appColor,
                //       //   // inActiveThumbImagePath: nightImage,
                //       // ),
                //       // IconButton(
                //       //   // hoverColor: Theme.of(context).primaryColor,
                //       //   splashColor: Colors.white,
                //       //   icon: Image.asset(
                //       //     Images.delete,
                //       //     width: 15.0,
                //       //     height: 15.0,
                //       //   ),
                //       //   onPressed: (){},
                //       // )
                //   ),
                // ),
              ],
            ),
          ),
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child:
              Padding(
                  padding: EdgeInsets.only(left:15.0,top:10.0,bottom:8.0,right: 10.0),
                  child:
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Category",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color:AppTheme.appColor
                                ),),
                              Text(_inventoryList[index].category,style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color:AppTheme.textColor
                              ),)
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Type",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color:AppTheme.appColor
                                ),),
                              Text(_inventoryList[index].type,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color:AppTheme.textColor
                                ),)
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Size",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color:AppTheme.appColor
                                ),),
                              Text(_inventoryList[index].size,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color:AppTheme.textColor
                                ),)
                            ],
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.all(20.0),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child:
                                  SizedBox(
                                      height: 45.0,
                                      width: MediaQuery.of(context).size.width,
                                      child:
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                                            primary: Colors.white,

                                            shape:  const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                            )),
                                        // shape: shape,
                                        onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)
                                          =>AddEditInventoryItem(flagAddEdit: "1",)) //for edit
                                          );

                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Edit",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(color: AppTheme.appColor, fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ))),
                              SizedBox(width: 10.0,),
                              Expanded(child:AppButton(
                                onPressed: () {

                                },
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(50))),
                                text: 'Remove',
                              ))

                            ],
                          ))
                    ],
                  )),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton:
        Padding(
          padding: const EdgeInsets.only(bottom:80.0),
          child:
          Container(
            // alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               Container(
                 constraints: new BoxConstraints.expand(
                     height: 55.0,
                     width: 120.0
                 ),
                 child: FloatingActionButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      =>AddEditInventoryItem(flagAddEdit: "0") //for add
                      ));
                    },
                   child:  Container(
                     constraints: new BoxConstraints.expand(
                         height: 55.0,
                         width: 120.0
                     ),
                        // alignment: Alignment.bottomCenter,
                        // padding: new EdgeInsets.only(left: 16.0, bottom: 200.0),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage(Images.addItem),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child:
                        Center(
                          child:
                          Padding(
                            padding: const EdgeInsets.only(left: 45.0),
                            child: Text('Add Item',
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.0,
                              color: Colors.white
                            )
                    ),
                          ),
                        ),
                    ),
                  ),
               ),
                // FloatingActionButton.extended(
                //     elevation: 0.0,
                //     foregroundColor: AppTheme.textColor,
                //     label: Text("Add Item"),
                //     icon: new Icon(
                //       Icons.add_circle_outline,
                //       color: Colors.white,
                //       size: 30.0,
                //
                //     ),
                //
                //     backgroundColor: Theme.of(context).primaryColor,
                //     onPressed: () async{
                //
                //
                //
                //     })
              ],
            ),
          ),
        ),
      body:
      SafeArea(child:Column(
        children: [
          //search with filter
          Padding(padding: EdgeInsets.only(left: 15.0,right: 15.0,top:10.0,bottom: 10.0),
              child:Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
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
                      // Row(
                      //   children: [
                      //     Container(
                      //       margin: EdgeInsets.only(right: 10.0),
                      //       width: 1,
                      //       height: 20.0,
                      //       color: AppTheme.textColor,
                      //     ),
                      //     Text(
                      //       'Filters',
                      //       style: TextStyle(
                      //           color: AppTheme.textColor,
                      //           fontSize: 14.0,
                      //           fontWeight: FontWeight.w400,
                      //           fontFamily: 'Poppins'
                      //       ),
                      //     ),
                      //     IconButton(
                      //       icon: Image.asset(Images.filter,width: 20.0,height: 20.0,),
                      //       onPressed: () {
                      //         // Navigator.push(
                      //         //     context,
                      //         //     MaterialPageRoute(
                      //         //         builder: (context) =>
                      //         //         new OrdersFilter())
                      //         // );
                      //       },
                      //     ),
                      //
                      //   ],
                      // )


                      //text
                    ],
                  )
              )
          ),
          Expanded(
                 child:
                     Container(
                       // margin: EdgeInsets.only(bottom: 3.0),
                       child:
                       ListView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only( top: 10,),
                itemBuilder: (context, index) {
                  return buildInventoryList(index,inventoryList);
                },
                itemCount: inventoryList!=null?inventoryList.length:6,
              )))
        ],
      ))
    );
  }

}

class ExpandableItems extends StatefulWidget {
  _ExpandableItemsState createState()=>_ExpandableItemsState();
}
class _ExpandableItemsState extends State<ExpandableItems>{

  var loremIpsum =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  Widget buildListViewItemProd(BuildContext context) {
    // if (location == null) {
    //   return ListView.builder(
    //     scrollDirection: Axis.horizontal,
    //     padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
    //     itemBuilder: (context, index) {
    //       return Padding(
    //         padding: EdgeInsets.only(left: 15),
    //         child: AppCategory(
    //           type: CategoryView.cardLarge,
    //         ),
    //       );
    //     },
    //     itemCount: List.generate(8, (index) => index).length,
    //   );
    // }

    // return ListView.builder(
    //   itemCount: 10,
    //   scrollDirection: Axis.vertical,
    //   padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
    //   itemBuilder: (context, index) {
    return FractionallySizedBox(
        widthFactor: 0.5,
        child:
        Container(
            padding: EdgeInsets.only(left: 8,right:8.0),
            child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: "http://via.placeholder.com/350x150",
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.zero,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),

                      );
                    },
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                        baseColor: Theme
                            .of(context)
                            .hoverColor,
                        highlightColor: Theme
                            .of(context)
                            .highlightColor,
                        enabled: true,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.zero,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Shimmer.fromColors(
                        baseColor: Theme
                            .of(context)
                            .hoverColor,
                        highlightColor: Theme
                            .of(context)
                            .highlightColor,
                        enabled: true,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.zero,
                          ),
                          child: Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                  Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    "Prime Roof truck ",
                    style: Theme
                        .of(context)
                        .textTheme
                        .caption
                        .copyWith(fontWeight: FontWeight.w400,fontFamily: 'Poppins',color: AppTheme.textColor),
                  ),
                  Padding(padding: EdgeInsets.only(top: 2)),
                  Text(
                    "25 \$/hr",
                    maxLines: 1,
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.w600,fontFamily: "Poppins",color: Theme.of(context).primaryColor),
                  ),

                  Padding(padding: EdgeInsets.all(15.0),
                      child:
                      SizedBox(
                          height: 25.0,
                          width: 160.0,
                          child:

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                              primary: Theme.of(context).primaryColor,

                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                            ),
                            // shape: shape,
                            onPressed: (){},
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'More Info',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )
                      )
                  )
                ],
              ),
            )
        )
      // }
    );
  }


  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child:
      Container(
        // clipBehavior: Clip.antiAlias,
        child:
        Column(
          children: <Widget>[
        //   SizedBox(
        //   height: 150,
        //   child:
        //   Container(
        //     decoration: BoxDecoration(
        //       color: Colors.orange,
        //       shape: BoxShape.rectangle,
        //     ),
        //   ),
        // ),
        ScrollOnExpand(
          scrollOnExpand: true,
          scrollOnCollapse: false,
          child:
          ExpandablePanel(
            theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.bottom,
                tapBodyToCollapse: true,
                // iconColor: Colors.white,
                hasIcon: false //for disability of icon
            ),
            header:
            SizedBox(
              height: 200,
              child:
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                ),
                child: Image.asset(Images.truckFull,fit: BoxFit.fill,),

              ),
            ),
            collapsed:
            Text(
              "",
              // softWrap: true,
              // maxLines: 1,
              // overflow: TextOverflow.ellipsis,
            ),
            expanded:Padding(
                padding: EdgeInsets.only(left:10.0,right:15.0,
                    top:15.0,bottom: 70.0),
                child:
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text("Category",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color:AppTheme.appColor
                                  ),),
                                Text("Category Name",style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color:AppTheme.textColor
                                ),)
                              ],
                            ),
                            Column(
                              children: [
                                Text("Type",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color:AppTheme.appColor
                                  ),),
                                Text("Type Name",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color:AppTheme.textColor
                                  ),)
                              ],
                            ),
                            Column(
                              children: [
                                Text("Size",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color:AppTheme.appColor
                                  ),),
                                Text("200lb",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color:AppTheme.textColor
                                  ),)
                              ],
                            )
                          ],
                        )
                      ],
                    )


            ),
            builder: (_, collapsed, expanded) {
              // return Padding(
              //   padding: EdgeInsets.only(left: 5, right: 5,),
              //   child:
              return Expandable(
                collapsed: collapsed,
                expanded: expanded,
                theme: const ExpandableThemeData(crossFadePoint: 0),
                // ),
              );
            },
          ),
        ),
          ],
        ),
      ),
      // )
    );
  }
}