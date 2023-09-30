import 'package:blogapp/articleScreen.dart';
import 'package:blogapp/navigationBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog Explorer',
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: NavBar(),
    );
  }
}

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  Future fetchBlogs() async {
    final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    final String adminSecret = '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    final response = await http.get(Uri.parse(url), headers: {
      'x-hasura-admin-secret': adminSecret,
    });

    if (response.statusCode == 200) {
      // Request successful
      final data = jsonDecode(response.body);
      print("response data : ${response.body}");
      return data;
    } else {
      // Request failed
      throw Exception('Request failed with status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Explorer'),
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(Icons.list),
            onPressed: (){

            },
          ),
        )],
      ),
      body: FutureBuilder(
        future: fetchBlogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          // Check if snapshot.data is not null
          if (snapshot.data != null) {
            final data = snapshot.data;
            final List<dynamic> blogs = data['blogs'];

            return ListView.builder(
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                final blog = blogs[index];
                final title = blog['title'];
                final urlimage=blog['image_url'];

                return SizedBox(
                    width: double.infinity,
                    child:GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ArticleScreen()),
                        );
                      },
                      child: Card(
                          margin: EdgeInsets.all(15),
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children:[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(urlimage),
                                ),
                                SizedBox(height: 8,),
                                Text('${title.toString()} ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 8,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Sep 30, 2023"),
                                    IconButton(onPressed: (){}, icon: Icon(Icons.favorite)),
                                    IconButton(onPressed: (){}, icon: Icon(Icons.share)),
                                  ],
                                )



                              ],
                            ),
                          )
                      ),
                    )
                );
              },
            );
          }

          return Container();
        },
      )
    );
  }

}


