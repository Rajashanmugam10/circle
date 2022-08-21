import 'package:flutter/material.dart';

class Expand extends StatefulWidget {
  const Expand(
      {Key? key,
      required this.photo,
      required this.postuser,
      required this.blog,
      required this.discription,
      required this.postedby})
      : super(key: key);
  final String photo, blog, postuser, postedby, discription;
  @override
  State<Expand> createState() => _ExpandState();
}

class _ExpandState extends State<Expand> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: widget.photo,
                child: Center(
                    child: Image.network(
                  widget.photo,
                  height: 300,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.fitHeight,
                  width: double.infinity,
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      '${widget.blog} is posted by ${widget.postedby}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.5),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.discription,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 16,
                      letterSpacing: .4,
                      wordSpacing: 1.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
