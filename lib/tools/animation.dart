import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Animate extends StatefulWidget {
  const Animate({Key? key}) : super(key: key);

  @override
  State<Animate> createState() => _AnimateState();
}

class _AnimateState extends State<Animate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('lottie')
              .doc('animation')
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Lottie.network(data['animation'].toString()),
                  );
                },
              );
            }
            return const Text('data');
          },
        ),
      ),
    );
  }
}
