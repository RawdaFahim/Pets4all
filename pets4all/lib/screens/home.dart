import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets4all/blocs/authBloc.dart';
import 'package:pets4all/screens/drawer.dart';
import 'package:pets4all/screens/tile.dart';
import 'package:provider/provider.dart';
import 'package:pets4all/blocs/forum_bloc.dart';
import 'package:pets4all/models/forums.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  //law 7asal change mesh lazem ashofo f nafs el wa2t, statefull bte3mel set state keter
  //a7san law dost 3ala 7aga tt3'ayar mesh ama el data tegeli mn el database
  @override
  Widget build(BuildContext context) {
    return StatefulProvider<ForumServices>(
      //forumservice class -intermediate between us and database-backend block to get stuff from database
        valueBuilder: (BuildContext context) =>
            ForumServices(), //scaffold el shasha ely odamy wana ely babny 3aleh 7agat
        //value builder is to get any updates from the forum, gowah child consumer, dayman listen on forum service, bageb meno functions w values
        child: Consumer<ForumServices>(
          //returns widget w el forum service ely talabtaha fel value builder
            builder: (BuildContext context, forumServices) {
              return StreamBuilder<List<String>>(
                //return lazem yentehy b widget, list to return asamy el types
                  stream: forumServices.forumsTypes$,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    List<String> types = snapshot.data;
                    num tabLen = types.length;

                    return TabsScreen(
                        types: types,
                        bloc: forumServices); //kol el screen ely feha kol 7aga
                  });
            }));
  }
}

class TabsScreen extends StatefulWidget {
  //page kolaha lesa mat2asemetsh
  //me7taga tab controller
  final ForumServices bloc;
  final List<String> types;
  final GlobalKey<ScaffoldState> keyScaffold;

  const TabsScreen(
      {Key key, @required this.bloc, @required this.types, this.keyScaffold})
      : super(key: key);
  @override
  _TabsScreenState createState() => _TabsScreenState(keyWord: "");
}

class _TabsScreenState extends State<TabsScreen> with TickerProviderStateMixin {
  //me7taga tab controller
  TabController _tabController; //private to control tabs
  final TextEditingController _textTitle =
  TextEditingController(); //constructor, final means finalized mesh hy get initialized mara tanya
  final TextEditingController _textContent = TextEditingController();
  TextEditingController _searchcontroller =
  TextEditingController(); //konna bengrab
  bool searching = false;
  String keyWord = "";
  _TabsScreenState({keyWord}) {
    this.keyWord = keyWord;
    this.searching = false;
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
      ScaffoldState>(); //gwoa el statefull widget byedy le kol scafold value
  //3ashan homa kaza wa7ed, scaffold key 3ashan el bottom sheet

  @override
  void initState() {
    _tabController = TabController(
        vsync: this, length: widget.types.length) //lazem adelo el length
      ..addListener(
          _sinkTypeOnTabChange); //dayman 3ayza a3raf lama ye3'ayar el tab, betraga3li el index 3al tab controller w b accesso mn henak
    _searchcontroller = TextEditingController(); //hwa masht3'alsh 3'er keda

    super.initState();
  }

  @override
  void dispose() {
    // ba2fel kol el controllers ely fat7ah w ay stream bas mesh hena ely forum services
    _searchcontroller.dispose();

    super.dispose();
  }

  void
  _sinkTypeOnTabChange() {} // mesh me7tagaha abl m a3raf en momken nesta3mel el index mn el controller bas 3amlenlaha add fel listenuer
  @override
  Widget build(BuildContext context) {
    final AuthService authService =
    Provider.of<AuthService>(context); //3ayza a3raf meen el user
    // final commentslist = List.from(widget.choosenType.comments);

    void _showBottom(int index) {
      //function beta3t el plus (bottom sheet)
      final bottomSheet = _scaffoldKey.currentState.showBottomSheet((context) {
        //ana f anhy scaffold
        return Container(
          //bel shakl ely ana me7khtarah
          width: MediaQuery.of(context)
              .size
              .width, //mediaquery bye2dar y adjust le ay screen le ay mobile
          //law mesh me7adeden height hayakhod el height kolo ela law fe 7aga hatzo2o
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // tadarog el alwan
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor,
              ],
              stops: [-1.0, 0.5, 1.0],
            ),
          ),
          child: StreamBuilder<FirebaseUser>(
            //el 7aga ely ha3melaha return gowa el container
              stream: authService.user, //current user
              builder: (context, snapshot) {
                //hayraga3o f snapshot
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final user = snapshot.data; //el user f variable
                return Column(
                  // da el return 3ashan 3ayza araga3 kaza 7aga fo2 ba3d da object
                  //3amlen return 3ashan 3amlen builder 3ashan fe stream 3ashan beygeb data mn 7eta tanya 3ashan el widget bteshta3'al 3ala data 3andi, el stream lazem yekon leh builder
                  mainAxisAlignment: MainAxisAlignment
                      .start, //hayebda2 mn el nos line vertical
                  children: <Widget>[
                    Expanded(
                      //khod makan le7d m tekon merta7 3ashan mayetla3lesh error
                      child: Column(
                        //3ashan el expanded mn 3'er column mardesh
                        children: <Widget>[
                          SizedBox(height: 20), //3ashan neseb margin
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, //e3mel space between el children, ,main axis line horizontal
                            children: <Widget>[
                              GestureDetector(
                                //akeno zorar bey detect press, mesh gowah raised button 3ashan leh shadow w mesh 3ayzen el shakl da
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onTap: () => Navigator.pop(
                                    context), //e2fel el 7aga ely fat7ahaa
                              ),
                              RaisedButton(
                                child: Text("Submit",
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                                onPressed: () {
                                  Firestore.instance //aro7 firestore
                                      .collection("forums")
                                      .document() //haye3mel document gdeda
                                      .setData({
                                    "authorName": user.displayName,
                                    "content": _textContent.text,
                                    "title": _textTitle.text,
                                    "participants": 0,
                                    "comments": [],
                                    "type": index == 0 ? "question" : "Events",
                                  });

                                  Navigator.pop(
                                      context); //close after finishinhg
                                  _textTitle.clear(); //clean

                                  _textContent.clear();
                                },
                                shape: RoundedRectangleBorder(
                                  //beta3 el raised button
                                    borderRadius: BorderRadius.circular(3)),
                              )
                            ],
                          ), //end of row
                          Padding(
                            //gowa el padding 3ashan 3ayzaha padding w optimized 3an text 3ashan ha3mel sized box
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              "add fourm ",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.display1,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _textTitle,
                              decoration: InputDecoration(
                                hintText: "Choose a title",
                              ), //null 3ashan mabne3mlesh submit mn hena
                              onSubmitted: null,
                              onEditingComplete: null,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _textContent,
                              decoration: InputDecoration(
                                hintText: "Wrire content here",
                              ),
                              onSubmitted: null,
                              onEditingComplete: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        );
      }); //when thw bottom sheet is closed start popping everything till reaching initial page (pop 1 time)
      bottomSheet.closed.then((v) {
//        Navigator.of(context).popUntil((r) => r.settings.isInitialRoute);
      });
    }

    Widget formField = TextFormField(
      controller: _searchcontroller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "search",
        hintStyle: TextStyle(color: Colors.white),
      ),
    );

    return Scaffold(
      //hanebny el homepage
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          //el plus ely 3andena w mawgoda f flutter, 7aga mawgoda fel scaffold 3ashan betkon floating over it
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            //law dost load showbottom
            _showBottom(_tabController.index);
            print(_tabController.index); //edeha index e7na fen
          },
          tooltip: 'Increment', // text appearing when only holding
          child: Icon(Icons.add), // el icon
        ),
        drawer: Pets4allDrawer(), // el 3 khotot
        body: CustomScrollView(slivers: <Widget>[
          //de el page kolaha
          SliverAppBar(
            // el goz2 el pink, el scaffold gowah app bar bas el silverapp bar fe options aktar,kan esm bas delwa2ty container, hwa aslun widget
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: formField,
                    ),
                    if (this.searching == false)
                      IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              this.keyWord = _searchcontroller.text;
                              _searchcontroller.clear();
                              if (this.keyWord.isEmpty == false)
                                this.searching = true;
                            });
                          }),
                    if (this.searching == true)
                      IconButton(
                          icon: Icon(
                            Icons.keyboard_backspace,
                          ),
                          onPressed: () {
                            setState(() {
                              this.keyWord = "";
                              this.searching = false;
                            });
                          })
                  ]),
            ),
            flexibleSpace: Text(
                'Pets4ALL'), //mesh zaher 3ashan el search bar wakhed makan keber
            bottom: TabBar(
              controller: _tabController,
              tabs: widget.types
                  .map((String type) => Tab(
                text: type,
              )) //retrun all tabs wel text hwa el type
                  .toList(), //3ashan heya betakhod list
            ),
          ),
          SliverFillRemaining(
            //el goz2 el abyad
              child: StreamBuilder<List<Forums>>(
                  stream: widget.bloc.forums$,
                  builder: (_, AsyncSnapshot<List<Forums>> snapshot) {
                    //mesh lazem a7ot el type bas sa3at lama beykon fe error aw kaza stream ben7oto 3ashan ye2dar yemayez de bta3t a bezabt
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
//                    final forum = snapshot.data;
                    final forum = snapshot.data
                        .where((p) => p.title.contains(this.keyWord))
                        .toList();
                    return TabBarView(
                      //related bel tabbar, homa synchronous ma3 ba3d, ama ba3'ayar fel tabs beysama3 hena
                      controller: _tabController,
                      children: widget.types.map((String type) {
                        List<Forums> listofthistype = forum.where((Forums fo) {
                          return fo.type == type;
                        }).toList(); //get forums of the same type

                        final cards =
                        listofthistype //wrapping kol so2al bas kolohom
                        //containers kol so2al ma7tot forumcard added to a list
                            .map((thistype) => ForumCard(
                          choosentype: thistype,
                          forumServices: widget.bloc,
                        ))
                            .toList();

                        return ListView(
                          //3ashan azherhom a7otohom f widget which is listview, kan momken yeb2a column bas me7tagen scroll
                          children: cards,
                        );
                      }).toList(),
                    );
                  }))
        ]));
  }
}

class ForumCard extends StatelessWidget {
  final Forums
  choosentype; // el forum ely ba3tah lel forum card, el so2al ely hayet7at fel card
  final ForumServices
  forumServices; //3ashan a add participants masalan fel events
  ForumCard({Key key, @required this.choosentype, this.forumServices})
      : super(key: key);
  final Firestore firestore = Firestore();
  final TextEditingController _textF = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final AuthService authService =
    Provider.of<AuthService>(context); //el 7aga ely feha el user
    final user$ = authService.user.where((user) => user != null);
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Center(
        child: StreamBuilder<FirebaseUser>(
            stream: user$,
            builder: (context, snapshot) {
              final currentUser = snapshot.data;
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return choosentype.type == "question"
                  ? QuestionContainer(
                currentUser: currentUser,
                choosenType: choosentype,
                forumServices: forumServices,
              )
                  : EventContainer(
                currentUser: currentUser,
                choosenType: choosentype,
                forumServices: forumServices,
              );
            }),
      ),
    );
  }
}

class QuestionContainer extends StatefulWidget {
  final Forums choosenType;
  final FirebaseUser currentUser;
  final ForumServices forumServices;

  QuestionContainer({
    Key key,
    @required this.choosenType,
    this.currentUser,
    this.forumServices,
  }) : super(key: key);

  @override
  QuestionContainerState createState() {
    return new QuestionContainerState();
  }
}

class QuestionContainerState extends State<QuestionContainer> {
  final TextEditingController _textF =
  TextEditingController(); // bakteb fe el comment
  bool isExpanded = false; // expand and contract comments

  @override
  Widget build(BuildContext context) {
    final commentslist = List.from(
        widget.choosenType.comments); //bakhod comments mn el forum f list

    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: EdgeInsets.only(
            right: 16.0,
            left: 16.0,
            top: 16.0,
            bottom: 16.0,
          ),
          child: Column(
            // container leh child el hwa el card wl card leh child ely hwa el column
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "@" + widget.choosenType.authorName,
                      style: TextStyle(
                          color: Colors.pink, fontWeight: FontWeight.w300),
                    )
                  ],
                ),
                Text(
                  widget.choosenType.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  // el line el grey
                  color: Colors.grey,
                  height: 2,
                ),
                GestureDetector(
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "Comments",
                          style: TextStyle(
                              color: Colors.pink, fontWeight: FontWeight.w300),
                        )),
                    onTap: () {
                      widget.forumServices.setformId(widget.choosenType.uid);
                      showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return StreamBuilder<Forums>(
                              stream: widget.forumServices.specificforums$,
                              builder: (context, snapshot) {
                                if (!(snapshot.hasData &&
                                    snapshot.data != null)) {
                                  return Container(
                                    child: Text("data"),
                                  );
                                }
                                final Forums specfiedFourm = snapshot.data;
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 25),
//                                  margin: const EdgeInsets.only(bottom: 20.0),
                                  height: MediaQuery.of(context).size.height,
                                  color: Colors.pink[50],
                                  child: Center(
                                    child: ListView(
                                      padding: const EdgeInsets.all(8.0),
                                      children: <Widget>[
//                                        ely beyzhar ama a3mel expansion
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: ListView.builder(
                                            //builder 3ashan ana 3ayza shakl wa7ed yetkarar kaza mara 3aks listview bas, ba3'yr l vlue bas
                                            shrinkWrap:
                                            true, //el listview mesh bt7eb definit height, de ely betkhaleha t adapt, w t shrink gwoaha
                                            itemCount:
                                            specfiedFourm.comments.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              String key = specfiedFourm
                                                  .comments[index][
                                              "1"]; //to acess it in the map
                                              String keyUid = specfiedFourm
                                                  .comments[index]["0"];
                                              String commContent = specfiedFourm
                                                  .comments[index]["2"];

                                              return Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  //el comment nafso
                                                  Text(
                                                    "@" + key,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.w300,
                                                        fontSize: 15,
                                                        color:
                                                        Colors.pinkAccent),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                        width: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width *
                                                            0.5,
                                                        child: Text(
                                                          commContent,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .blueGrey[
                                                              600]),
                                                        ),
                                                      ),
                                                      keyUid ==
                                                          widget.currentUser
                                                              .uid //if you're the user you can delete
                                                          ? SizedBox(
                                                          height: 18.0,
                                                          width: 18.0,
                                                          child: IconButton(
                                                            padding: new EdgeInsets.all(0.0),
                                                            icon: Icon(Icons.delete_forever),
                                                            onPressed: () {
                                                              commentslist.removeAt(index);
                                                              Firestore.instance //update firestore
                                                                  .collection('forums')
                                                                  .document(widget.choosenType.uid)
                                                                  .updateData(
                                                                {"comments": commentslist},
                                                              );
//                                                      setState(() => commentslist = List.from(widget.choosenType.comments));
                                                            },
                                                          )
                                                      )
                                                          : Container(), //if not, you can't delete
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Divider(
                                                    color: Colors.grey,
                                                    height: 2,
                                                  ),

                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              child: TextField(
                                                controller: _textF,
                                                decoration: InputDecoration(
                                                  hintText: "Write a comment",
                                                ),
                                                // onSubmitted: (String newal) {
                                                //   print('${_textF.text} $newVal');
                                                // },
                                                onEditingComplete: null, //mesh b submit mn hena
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.comment,
                                                color: Colors.pink,
                                              ),
                                              onPressed: () {
                                                print(_textF.text);
                                                commentslist.add({
                                                  "0": widget.currentUser.uid,
                                                  "1": widget.currentUser.displayName,
                                                  "2": _textF.text
                                                });
                                                print(commentslist);
                                                Firestore.instance
                                                    .collection('forums')
                                                    .document(widget.choosenType.uid)
                                                    .updateData(
                                                  {"comments": commentslist},
                                                );
                                                _textF.clear();
                                              },
                                            ),
                                          ],
                                        )

                                      ],
                                    ),

                                  ),
                                );
                              },
                            );
                          });
                    }),
//
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _textF,
                        decoration: InputDecoration(
                          hintText: "Write a comment",
                        ),
                        // onSubmitted: (String newal) {
                        //   print('${_textF.text} $newVal');
                        // },
                        onEditingComplete: null, //mesh b submit mn hena
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.comment,
                        color: Colors.pink,
                      ),
                      onPressed: () {
                        print(_textF.text);
                        commentslist.add({
                          "0": widget.currentUser.uid,
                          "1": widget.currentUser.displayName,
                          "2": _textF.text
                        });
                        print(commentslist);
                        Firestore.instance
                            .collection('forums')
                            .document(widget.choosenType.uid)
                            .updateData(
                          {"comments": commentslist},
                        );
                        _textF.clear();
                      },
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}

class EventContainer extends StatelessWidget {
  final Forums choosenType;
  final FirebaseUser currentUser;
  final ForumServices forumServices;

  EventContainer({
    Key key,
    @required this.choosenType,
    this.forumServices,
    this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: EdgeInsets.only(
            right: 16.0,
            left: 16.0,
            top: 16.0,
            bottom: 16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder<Map<String, Color>>(
                  stream: forumServices.color,
                  builder:
                      (context, AsyncSnapshot<Map<String, Color>> snapshot) {
                    if (!(snapshot.hasData && snapshot.data != null)) {
                      return Container(
                        child: Text("data"),
                      );
                    }
                    final Map<String, Color> color = snapshot.data;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "@" + choosenType.authorName,
                          style: TextStyle(
                              color: Colors.pink, fontWeight: FontWeight.w300),
                        ),
                        IconButton(
                          icon: Icon(Icons.star),
                          color: color[choosenType.uid] ?? Colors.black,
                          onPressed: () {
                            print(color);
                            if (color[choosenType.uid] == null ||
                                color[choosenType.uid] == Colors.black) {
                              forumServices.addColor(
                                  Colors.pink, choosenType.uid);
                              forumServices.addparticipant(choosenType);
                            } else {
                              forumServices.addColor(
                                  Colors.black, choosenType.uid);
                              forumServices.minusparticipant(choosenType);
                            }
                          },
                        ),
                        GestureDetector(
                          //malhash lazma, 3ashan bs el going
                          onTap: () => null,
//                           onTap: () {
//                             if (color == Colors.black) {
//                               forumServices.addColor(Colors.pink);
//                               forumServices.addparticipant(choosenType);
//                             } else {
//                               forumServices.addColor(Colors.black);
//                               forumServices.minusparticipant(choosenType);
//                             }
//                           },
                          child: Text(
                            'going:  ' +
                                choosenType.participants.toString() +
                                'in',
                            style: TextStyle(
                                color: color[choosenType.uid] ?? Colors.black),
                          ),
                        )
                      ],
                    );
                  }),
              Text(
                choosenType.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                choosenType.content,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey),
              ),
              Divider(
                color: Colors.grey,
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[],
              )
            ],
          ),
        ),
      ),
    );
  }
}
