import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/product/product_bloc.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {

  @override
  Widget build(BuildContext context) {
    final productBloc = BlocProvider.of<ProductBloc>(context, listen: true);

    return Row(
      children: [
        DropdownButton(
          title: 'Filter',
          onTap: (){
            _showFilterBottomSheet(context, productBloc);
          }
        ),
        Expanded(
          child: TextFormField(
            onChanged: (value) {
              productBloc.add(SearchEvent(searchString: value));
            },
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
              prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          )
        ),
        DropdownButton(
          title: 'Sort',
          onTap: (){
            _showSortBottomSheet(context, productBloc);
          }
        )
      ],
    );
  }

  Widget DropdownButton({required String title, required void Function()? onTap}){
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(title),
            Icon(Icons.keyboard_arrow_down, size: 24),
          ],
        ),
      ),
      onTap: onTap
    );
  }

  _showFilterBottomSheet(BuildContext context, ProductBloc productBloc){
    showModalBottomSheet(
        context: context,
        builder: (cxt){
          return StatefulBuilder(
            builder: (context, StateSetter setModalState) {
              return Container(
                padding: EdgeInsets.all(26),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Filter by Categories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    SizedBox(height: 10,),
                    Wrap(
                      spacing: 5.0,
                      children: List<Widget>.generate(productBloc.categories.length, (int index) {
                        final category = productBloc.categories[index];
                        return ChoiceChip(
                          label: Text('$category'),
                          selected: productBloc.selectedCategory == category,
                          onSelected: (bool selected) {
                            if (selected) {
                              setModalState(() {
                                productBloc.add(FilterByCategoryEvent(category: category));
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 30,),
                    Text('Filter by Rating', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 10,),
                    Wrap(
                      spacing: 5.0,
                      children: List<Widget>.generate(productBloc.ratings.length, (int index) {
                        final rating = productBloc.ratings[index];
                        return ChoiceChip(
                          // label: Text('$rating'),
                          label: Text('${rating.toInt() == 0 ? 'All' : '${rating.toInt()}⭐ & up'}'),
                          selected: productBloc.selectedRating == rating,
                          onSelected: (bool selected) {
                            if (selected) {
                              setModalState(() {
                                productBloc.add(FilterByRatingEvent(rating: rating));
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }
          );
        }
    );
  }

  _showSortBottomSheet(BuildContext context, ProductBloc productBloc){

    showModalBottomSheet(
        context: context,
        builder: (cxt){
          return StatefulBuilder(
              builder: (context, StateSetter setModalState) {
                return Container(
                  padding: EdgeInsets.all(26),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Sort by', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      SizedBox(height: 10,),
                      ...productBloc.sortList.map((sort) {
                        return RadioListTile<String>(
                          title: Text(sort),
                          value: sort,
                          groupValue: productBloc.selectedSort,
                          onChanged: (value) {
                            if (value != null) {
                              print(value);
                              setModalState(() {
                                productBloc.add(SortEvent(sort: value));
                              });
                            }
                          },
                        );
                      }).toList(),
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}