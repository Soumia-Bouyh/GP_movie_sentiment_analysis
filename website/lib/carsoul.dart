import 'dart:html';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Carousel extends StatefulWidget {
  final List<String> Url;

  Carousel({required this.Url});

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: widget.Url.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/$imageUrl'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.4),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(1),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 90.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(widget.Url.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                                child: Container(
                                  width: 15.0,
                                  height: 15.0,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentIndex == index ? Colors.white : Colors.white.withOpacity(0.3),
                                    boxShadow: _currentIndex == index
                                        ? [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      ),
                                    ]
                                        : null,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            cursor:'',
            'Movie Rating Platform',
            textStyle: TextStyle(
              fontSize: 90.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'CinematicFont',
              color: Color(0xff8ecae6),
            ),
            speed: const Duration(milliseconds: 40),
          ),
        ],
      ),
      SizedBox(height: 10), // Adjust the spacing between the texts
      Text(
        "Where Movies are Rated Based on Reviews",
        style: TextStyle(
          fontSize:30.0,
          fontFamily: 'CinematicFont', // Use the same font family as above
          color: Colors.white,
        ),
      ),
    ],
  ),
),


                      Padding(
                        padding: const EdgeInsets.only(left:90.0),
                        child:   Align(

                          alignment:Alignment.centerLeft,

                          child:   IconButton(



                            icon: Icon(Icons.arrow_back_ios,size: 60,color: Colors.white,),



                            onPressed: () {



                              setState(() {



                                _currentIndex = (_currentIndex - 1).clamp(0, widget.Url.length - 1) as int;



                              });



                            },



                          ),

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right:90.0),
                        child: Align(
                          alignment:Alignment.centerRight ,
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward_ios,size: 60,color: Colors.white,),
                            onPressed: () {
                              setState(() {
                                _currentIndex = (_currentIndex + 1).clamp(0, widget.Url.length - 1) as int;
                              });
                            },
                          ),
                        ),
                      ),

                    ],
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 600.0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 6),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),

      ],
    );
  }
}
