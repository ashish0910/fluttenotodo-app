import 'package:flutter/material.dart';
import 'package:notodoapp/model/nodo_item.dart';
import 'package:notodoapp/util/database_client.dart';
import 'package:notodoapp/util/date_format.dart';

class Notodoscreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new NotodoscreenState();
  }

}

class NotodoscreenState extends State<Notodoscreen>{
  final TextEditingController _texteditcontroller = new TextEditingController();
  var db = new DatabaseHelper();
  final List<NoDoItem> _notodolist = <NoDoItem> [];

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      _readNodoList();
    }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(padding: const EdgeInsets.all(8.0), reverse: false , itemCount: _notodolist.length ,itemBuilder: (_,int position){
              return new Card(
                color: Colors.white10,
                child: new ListTile(
                  title: _notodolist[position],
                  onLongPress: (){
                    _update(_notodolist[position],position);
                                      },
                                      trailing: new Listener(
                                        key: new Key(_notodolist[position].itemName),
                                        child: new Icon(Icons.remove_circle,color: Colors.redAccent,),
                                        onPointerDown: (pointerEvent){
                                          _deleteNode(_notodolist[position].id,position);
                                                              },
                                                            )
                                                          ),
                                                        );
                                                      },),
                                                    ),
                                                    new Divider(
                                                      height: 1.0,
                                                    )
                                                  ],
                                                ),
                                                floatingActionButton: new FloatingActionButton(
                                                  onPressed: _showformdialog,
                                                          backgroundColor: Colors.red,
                                                          child: new Icon(Icons.add,color: Colors.white,),
                                                        ),
                                                      );
                                                    }
                                                  
                                                  
                                                    void _showformdialog() {
                                                      var alert = AlertDialog(
                                                        content: new Row(
                                                          children: <Widget>[
                                                            new Expanded(
                                                              child: new TextField(
                                                                controller: _texteditcontroller,
                                                                autofocus: true,
                                                                decoration: new InputDecoration(
                                                                  labelText: "Item",
                                                                  hintText: "Eg.Dont Shit",
                                                                  icon: new Icon(Icons.note_add)
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        actions: <Widget>[
                                                          new FlatButton(
                                                            onPressed: (){
                                                              _handleSubmit(_texteditcontroller.text);
                                                                            _texteditcontroller.clear();
                                                                            Navigator.pop(context);
                                                                                },
                                                                                child: new Text("Save"),
                                                                              ),
                                                                              new FlatButton(
                                                                                onPressed: () => Navigator.pop(context),
                                                                                child: new Text("Cancel"),
                                                                              )
                                                                            ],
                                                                          );
                                                                          showDialog(context: context,builder: (_,){
                                                                            return alert;
                                                                          });
                                                                }
                                                              
                                                                void _handleSubmit(String text) async {
                                                                  _texteditcontroller.clear();
                                                                  NoDoItem nodoitem = new NoDoItem(text, dateFormatted());
                                                                  int saveditemid  = await db.saveUser(nodoitem);
                                                                  NoDoItem addedItem = await db.getUser(saveditemid);
                                                                  print("Item Saved $saveditemid");
                                                                  setState(() {
                                                                      _notodolist.insert(0, addedItem);                      
                                                                                          });
                                                                }
                                              _readNodoList() async {
                                                List items = await db.getAllUsers();
                                                items.forEach((item){
                                                 // NoDoItem noDoItem = NoDoItem.map(item);
                                                  setState(() {
                                                    _notodolist.add(NoDoItem.map(item));
                                                          });
                                                 // print("DB items:${noDoItem.itemName}");
                                                });
                                              }
                                          
                                            void _deleteNode(int id,index) async{
                                              debugPrint("Deleted");
                                              await db.deleteUser(id);
                                              setState(() {
                                                _notodolist.removeAt(index);                          
                                                                        });
                                            }
                    
                      void _update(NoDoItem item, int position) {
                        var alert = new AlertDialog(
                          title: new Text("Update Item"),
                          content: new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new TextField(controller: _texteditcontroller,autofocus: true,decoration: 
                                new InputDecoration(
                                  labelText: "Item",
                                  hintText: "Eg.Dont buy shit",
                                  icon: new Icon(Icons.update)
                                ),
                              )
                              ),
                              
                              ],

                          ),
                          actions: <Widget>[
                            new FlatButton(
                              onPressed: () async{
                                NoDoItem newUpdateditem = NoDoItem.fromMap(
                                  {"itemName" : _texteditcontroller.text ,
                                    "dateCreated" : dateFormatted(),
                                    "id" : item.id
                                  }
                                );
                                _handleSubmitUpdate(position,item);
                                await db.updateUser(newUpdateditem);
                                setState(() {
                                          _readNodoList();                        
                                                                });
                                Navigator.pop(context);                                
                                                              },
                                                              child: new Text("Update")
                                                            ),
                                                            new FlatButton(
                                                              onPressed: () => Navigator.pop(context),
                                                              child: new Text("Cancel"),
                                                            ),
                                                          ],
                                                        );
                                                        showDialog(context: context,builder: (_){
                                                          return alert;
                                                        });
                                                      }
                                
                                  void _handleSubmitUpdate(int position, NoDoItem item) {
                                    setState(() {
                                      _notodolist.removeWhere((element){
                                        _notodolist[position].itemName=item.itemName;
                                      });
                                                                        });
                                  }                  
}