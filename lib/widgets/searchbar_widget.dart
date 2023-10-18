import 'package:flutter/material.dart';

import 'package:maps/delegates/delegates.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only( top: 10 ),
        padding: const EdgeInsets.symmetric( horizontal: 30 ),
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            showSearch(context: context, delegate: SearchDestinationDelegate());
          },
          child: Container(
            padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 13 ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 5)
                )
              ]
            ),
            child: const Text('¿Dónde quieres ir?', style: TextStyle( color: Colors.black87 )),
          ),
        ),
      ),
    );
  }
}