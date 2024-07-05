import 'dart:convert';

import 'package:flutter/material.dart';

class CategoryModel {
  final int? id;
  final String name;
  final String desc;  
  final String? imageURL;
  CategoryModel({
    this.id,
    required this.name,
    required this.desc,
    this.imageURL
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': desc,
      'imageURL' : imageURL ?? ''
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      desc: map['description'] ?? '',
      imageURL: map['imageURL'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'Category(id: $id, name: $name, desc: $desc, imageURL: $imageURL)';
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key, required this.data, this.selected = false, this.onTap});
  final CategoryModel data;
  final bool selected;
  final Function(int)? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(onTap != null){
          onTap!(data.id ?? -1);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: selected ? 40 : 0
              ),
              duration: const Duration(milliseconds: 750),
              curve: Curves.easeInOutCubicEmphasized,
              builder: (context, val, child) {
                return SizedBox(  
                  width: val,
                  height: 2,
                  child: Container(
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                  ),
                );
              }
            ),
            data.imageURL != null ?
            CircleAvatar(
              backgroundImage: NetworkImage(data.imageURL ?? ""),
            ) : const CircleAvatar(
              child: Icon(Icons.smartphone),
            ),
            Text(data.name)
          ],
        ),
      ),
    );
  }
}