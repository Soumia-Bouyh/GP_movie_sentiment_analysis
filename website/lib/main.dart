import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moviereview/Movie.dart';
import 'package:moviereview/carsoul.dart';
import 'package:moviereview/detais.dart';
import 'package:moviereview/graphs.dart';
import 'package:moviereview/performance.dart';
import 'package:moviereview/square.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
      },
      theme: ThemeData(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  String review = '';
  double probability = 0.0;
  String sentiment = '';
  bool isAnalyzing = false;
  List movies = [];

  Future<void> analyzeReview() async {
    final dio = Dio();
    setState(() {
      isAnalyzing = true;
    });
    try {
      var response =
          await dio.get('http://127.0.0.1:5000/analyze_review?review=$review');
      Map responseData = json.decode(response.toString());

      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          sentiment = responseData['sentiment'];
          probability = responseData['probability'];
          isAnalyzing = false;
        });
      } else {
        throw Exception('Failed to analyze review: ');
      }
    } catch (e) {
      print('Error analyzing review: $e');
      setState(() {
        isAnalyzing = false;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadMoviesFromJson();
    });
  }

  Future<void> loadMoviesFromJson() async {
    print('Loading movies from json: ');
    try {
      String response = await DefaultAssetBundle.of(context)
          .loadString("assets/movies_with_reviews.json");
      final data = jsonDecode(response);

      setState(() {
        movies = data["movies"];
        movies = movies.map((movie) {
          movie['isHovered'] = false;
          return movie;
        }).toList();
        print("..number of items ${movies.length}");
      });
      print('hello');
    } catch (e) {
      print('Error loading movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Carousel(
                Url: ["movie.jpg", "greatestshowman.jpg", "bg-hero.jpg"],
              ),
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFf4f4f6), Colors.white!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.reviews),
                    SquareWidget(text: "Movie"),
                    SquareWidget(text: "Rating"),
                    SquareWidget(text: "Section"),
                    Icon(Icons.sentiment_satisfied),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white!,
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        for (var movie in movies)
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailsPage(
                                        movie: parseMovie(jsonEncode(movie))),
                                  ),
                                );
                              },
                              child: MouseRegion(
                                onEnter: (_) {
                                  setState(() {
                                    movie['isHovered'] = true;
                                  });
                                },
                                onExit: (_) {
                                  setState(() {
                                    movie['isHovered'] = false;
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 400,
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              Image.asset(
                                                '${movie['title']}.jpg'
                                                    .replaceAll(' ', ''),
                                                width: 150,
                                                height: 200,
                                                fit: BoxFit.cover,
                                              ),
                                              Opacity(
                                                opacity: movie['isHovered']
                                                    ? 0.9
                                                    : 0,
                                                child: Container(
                                                  color: Colors.black,
                                                  width: 150,
                                                  height: 200,
                                                  child: Row(
                                                    children: [
                                                      for (int i = 0;
                                                          i < 5;
                                                          i++)
                                                        Icon(
                                                          i < movie['filledStarsCount']
                                                              ? Icons.star
                                                              : Icons
                                                                  .star_border,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          ListTile(
                                            title: Text(movie['title']),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFf4f4f6), Colors.white!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.movie),
                    SquareWidget(text: "Movie"),
                    SquareWidget(text: "Review"),
                    SquareWidget(text: "Sentiment"),
                    SquareWidget(text: "Analysis"),
                    SquareWidget(text: "Section"),
                    Icon(Icons.star),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xff8ecae6),
                  ),
                  Positioned(
                    top: 20,
                    left: 400,
                    right: 320,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    review = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText:
                                      'enter a movie review you want to analyze',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: isAnalyzing ? null : analyzeReview,
                            // Disable button when analysis is in progress
                            child: isAnalyzing
                                ? CircularProgressIndicator() // Show circular progress indicator when analyzing
                                : Text('Analyse'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 70,
                    right: 320,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        'Sentiment: ${sentiment.isNotEmpty ? sentiment : 'Neutral'}\nProbability: ${probability}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



