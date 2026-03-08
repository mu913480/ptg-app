import 'package:flutter/material.dart';

class MapStyleToggle extends StatefulWidget {
  final String currentStyle;
  final ValueChanged<String> onStyleChanged;

  const MapStyleToggle({
    super.key,
    required this.currentStyle,
    required this.onStyleChanged,
  });

  @override
  State<MapStyleToggle> createState() => _MapStyleToggleState();
}

class _MapStyleToggleState extends State<MapStyleToggle> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _handleStyleChange(String style) {
    widget.onStyleChanged(style);
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSatellite = widget.currentStyle.contains('satellite');

    return GestureDetector(
      onTap: () {
        if (_isExpanded) _toggleExpanded();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: _isExpanded ? 180.0 : 48.0,
        height: 48.0,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: _isExpanded
            ? Stack(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    alignment: isSatellite
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: 86.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildOption(
                          context,
                          title: 'Map',
                          isSelected: !isSatellite,
                          onTap: () => _handleStyleChange(
                            'mapbox://styles/mapbox/streets-v12',
                          ),
                        ),
                        _buildOption(
                          context,
                          title: 'Satellite',
                          isSelected: isSatellite,
                          onTap: () => _handleStyleChange(
                            'mapbox://styles/mapbox/satellite-streets-v12',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : IconButton(
                onPressed: _toggleExpanded,
                icon: const Icon(Icons.layers),
                tooltip: 'Map Style',
              ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 86.0,
        // height: 40.0,
        alignment: Alignment.center,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          child: Text(title, style: const TextStyle(fontSize: 13)),
        ),
      ),
    );
  }
}
