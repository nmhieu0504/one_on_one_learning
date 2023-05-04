// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:one_on_one_learning/models/reviews.dart';
import 'package:one_on_one_learning/services/tutor_services.dart';

class ReviewPage extends StatefulWidget {
  final String userID;
  const ReviewPage({super.key, required this.userID});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<Reviews> reviews = [];
  bool isLoading = true;
  bool _getMoreData = false;
  final ScrollController _scrollController = ScrollController();
  int _page = 1;

  List<Widget> _showRating(int index) {
    List<Widget> list = [];
    for (int i = 0; i < reviews[index].rating; i++) {
      list.add(const Icon(
        Icons.star,
        color: Colors.yellow,
      ));
    }
    while (list.length < 5) {
      list.add(const Icon(
        Icons.star,
        color: Colors.grey,
      ));
    }

    return list;
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: _getMoreData ? 1.0 : 00,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    TutorServices.loadReviews(widget.userID, _page++, 10).then((value) {
      if (value != null) {
        setState(() {
          reviews = value;
          isLoading = false;
        });
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _getMoreData = true;
        });
        TutorServices.loadReviews(widget.userID, _page++, 10).then((value) {
          if (value != null) {
            setState(() {
              reviews.addAll(value);
              _getMoreData = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Reviews"),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                controller: _scrollController,
                itemCount: reviews.length + 1,
                itemBuilder: (context, index) {
                  return index == reviews.length
                      ? _buildProgressIndicator()
                      : ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(reviews[index].avatar),
                            onBackgroundImageError: (exception, stackTrace) {
                              print("Error");
                            },
                          ),
                          title: Text(
                              "${reviews[index].name}   ${reviews[index].createdAt}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: _showRating(index),
                              ),
                              Text(reviews[index].content)
                            ],
                          ),
                        );
                }));
  }
}
