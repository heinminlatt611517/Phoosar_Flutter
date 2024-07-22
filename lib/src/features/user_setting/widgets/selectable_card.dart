import 'package:flutter/material.dart';

class SelectableCard extends StatefulWidget {
  final String duration;
  final String price;
  final String label;
  final bool isSelected;
  final Function onTap;

  const SelectableCard({
    Key? key,
    required this.duration,
    required this.price,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  _SelectableCardState createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 8, vertical: widget.isSelected ? 0 : 8),
        padding: EdgeInsets.symmetric(
            horizontal: 16, vertical: widget.isSelected ? 24 : 16),
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.cyan : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.isSelected ? Colors.cyan : Colors.grey,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.duration.split(' ')[0] +
                  '\n' +
                  widget.duration.split(' ')[1] +
                  ' ' +
                  widget.duration.split(' ')[2],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.isSelected ? Colors.white : Colors.pink,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.price,
              style: TextStyle(
                fontSize: 18,
                color: widget.isSelected ? Colors.white : Colors.black,
              ),
            ),
            if (widget.label.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
