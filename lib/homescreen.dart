import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echonews/webviewscreen.dart';
import 'package:echonews/providers/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
const Apikey='3466f068635c4f0b94265caa775218f8';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<dynamic> Newsdata = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> fetchdata() async {
    const url =
        'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=$Apikey';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {
        Newsdata = jsonResponse['articles'] ?? [];
        isLoading = false;
      });
    } else {
      print("API call failed with status code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[500],
        title: Text(
          "Top Headlines",
          style:
              GoogleFonts.bebasNeue(letterSpacing:2,fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              icon: const Icon(Icons.brightness_6))
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: fetchdata,
              child: ListView.builder(
                  itemCount: Newsdata.length,
                  itemBuilder: (context, i) {
                    final newsitem = Newsdata[i];
                    final thumbnail = newsitem['urlToImage'] ??
                        'https://www.politico.com/dims4/default/31ca069/2147483647/resize/1200x/quality/90/?url=https%3A%2F%2Fstatic.politico.com%2Fbb%2Fab%2F8f9e67a64efabc012cae0134016e%2Fu-s-congress-35258.jpg';
                    final title = newsitem['title'] ?? 'No title';
                    final description =
                        newsitem['description'] ?? 'No description';
                    final sourcename =
                        newsitem['source']['name'] ?? 'No source name';
                    DateTime dateTime = DateTime.parse(newsitem['publishedAt']);
                    String formattedDate =
                        DateFormat("MMM dd, yyyy").format(dateTime);

                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                        url: newsitem['url'],
                                      )));
                        },
                        leading: SizedBox(
                          width: 100,
                          height: 100,
                          child: CachedNetworkImage(
                            imageUrl: thumbnail,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            fit: BoxFit.fill,
                          ),
                        ),
                        title: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.noticiaText(fontWeight: FontWeight.bold,),),
                        subtitle: Column(
                          children: [
                            Text(
                              description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.ebGaramond(fontWeight: FontWeight.w600),
                            ),
                            Text("source:$sourcename"),
                            Text(formattedDate)
                          ],
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}
