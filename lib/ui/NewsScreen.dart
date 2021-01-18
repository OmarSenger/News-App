import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/model/news.dart';
import 'package:news/network/webservices.dart';
import 'package:news/views/article_view.dart';

class MyApp extends StatelessWidget {
  static const String _title = 'News';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  int _selectedIndex = 0;
  News _news =News();
  bool isDataLoaded=false;
  String initialDropdownValue = 'Egypt';


  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() async {
    final result= await Webservices().loadNews('sport','eg');
    final result2= await Webservices().loadNews('business','eg');
    final result3= await Webservices().loadNews('science','eg');
    final result4= await Webservices().loadNews('sport', 'us');
    final result5= await Webservices().loadNews('business','us');
    final result6= await Webservices().loadNews('science','us');
    setState(() {
      (_selectedIndex==0&&initialDropdownValue=='Egypt')? _news=result:(_selectedIndex==1&&initialDropdownValue=='Egypt')? _news=result2: (_selectedIndex==2&&initialDropdownValue=='Egypt')?_news=result3:(_selectedIndex==0&&initialDropdownValue!='Egypt')?_news=result4:(_selectedIndex==1&&initialDropdownValue!='Egypt')?_news=result5:_news=result6 ;
      isDataLoaded=true;
    });
  }

  void _onItemTapped(int index) {
    controller.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() {
      _selectedIndex = index;
      _loadNews();
    });
  }

final ScrollController controller = ScrollController();

var urlImg = 'https://www.eduprizeschools.net/wp-content/uploads/2016/06/No_Image_Available.jpg';


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('News'),
            DropdownButton(
              value: initialDropdownValue,
              onTap: _loadNews,
              underline: Container(),
              icon: Icon(Icons.arrow_downward),
              iconSize: 24.0,
              iconEnabledColor: Colors.white,
              style: TextStyle(color: Colors.white,fontSize: 20.0),
              dropdownColor: Colors.black,
              onChanged: (String newValue) {
                setState(() {
                  initialDropdownValue = newValue;
                });
              },
              items: <String>['Egypt','US'].map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                    value : value ,
                    child: Text(value),
                  );
                }).toList(),
            )],
        ),
      ),
      body:isDataLoaded? ListView.builder(
        itemCount: _news.articles.length==null?0:_news.articles.length,
        controller: controller,
        itemBuilder: (context,index){
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder : (context) => ArticleView(
                    imageUrl: _news.articles[index].url,
                  )
              ));
            },
            child: Column(
              children: [
                Image.network(_news.articles[index].urlToImage==null?urlImg:_news.articles[index].urlToImage),
                Card(
                  color: Colors.grey.withOpacity(0.2),
                    margin: EdgeInsets.only(top:10,bottom: 10),
                    child: Text(_news.articles[index].title,style: TextStyle(fontSize: 20,color: Colors.white))),
              ],
            ),
          );
        },
      ):Center(
        child: CircularProgressIndicator(backgroundColor:Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey.shade900,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_basketball),
            label: 'Sport',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Science',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
