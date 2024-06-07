import 'package:flutter/material.dart';
import 'package:moviereview/Movie.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  MovieDetailsPage({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Container(
          color: Color.fromARGB(10, 255, 255,255),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(80.0),
                    child: Container(
                      width: 300.0,
                      height: 350.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        image: DecorationImage(
                          image: AssetImage(movie.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Display rating in terms of stars
                      _buildRatingStars(movie.rating),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Comments:',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: movie.comments.map((comment) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color:  Colors.white,
            borderRadius: BorderRadius.circular(10.0), 
            border: Border.all(
              color: Colors.grey, 
              width: 0.3, 
            ),
          ),
                      
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title: Text(
                            comment.text,
                            style: TextStyle(fontSize: 12.0,fontFamily: 'Helvetica'),
                          ),
                          subtitle: Text(
                            ' ${comment.sentiment}',
                            style: TextStyle(fontSize: 16.0,color: comment.sentiment=="Negative"?Colors.red:Colors.green),
                            
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    // Determine the number of stars to display based on rating
    double numStars = rating ;
    List<Widget> stars = List.generate(
      5,
      (index) => Icon(
        index < numStars ? Icons.star : Icons.star_border,
        color: index < numStars ? Colors.amber : Colors.grey,
        size: 24.0,
      ),
    );
    return Row(children: stars);
  }
}
