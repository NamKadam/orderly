import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Blocs/profile/bloc.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_faqList.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class FAQ extends StatefulWidget{
  _FAQState createState() =>_FAQState();
}

class _FAQState extends State<FAQ>{
  ProfileBloc _profileBloc;
  bool isconnectedToInternet = false, flagNoData=false;
  List<Faq> faqList;
  final _controller = RefreshController(initialRefresh: false);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileBloc=BlocProvider.of<ProfileBloc>(context);
    setBlocData();
    // getInventoryList();
  }

  void setBlocData() async{
    isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
    if (isconnectedToInternet == true) {
      _profileBloc.add(FetchFAQ());
    } else {
      CustomDialogs.showDialogCustom(
          "Internet", "Please check your Internet Connection!", context);
    }
  }

  ///On Refresh List
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    faqList=null;
    setBlocData();
    _controller.refreshCompleted();
  }

  Widget buildFaqList(int index,List<Faq> _faqList){
    if(_faqList==null){
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
          // trailing: Text(''), //commented to show dropdown
          title:
          Text(_faqList[index].question,
                  style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w600,color: AppTheme.appColor)),

          children: <Widget>[
            ListTile(
              title: Text(
                _faqList[index].answer,
                style: TextStyle(fontWeight: FontWeight.w600,color: AppTheme.textColor,fontSize: 15.0),
              ),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: Text('FAQ'
        ,style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
    ),
    ),
    ),
        body:BlocBuilder<ProfileBloc,ProfileState>(builder: (context,state){
          if(state is FAQProfSuccess){
            faqList=state.faqList;
          }
          return SafeArea(
              child:
              SmartRefresher(
              enablePullDown: true,
              onRefresh: _onRefresh,
              controller: _controller,
              child:
              flagNoData==false
              ?
              ListView.builder(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.only( top: 10,),
          itemBuilder: (context, index) {
          return buildFaqList(index,faqList);
          },
          itemCount: faqList!=null?faqList.length:6,
          )
          :
              Center(
                child: Text("No Data Available",
                  style:
                  TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Poppins',fontSize: 16.0,color: AppTheme.textColor),),
              )));



        })
    );
  }
  
}