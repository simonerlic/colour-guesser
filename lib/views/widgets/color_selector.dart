import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({super.key, required this.onColorChanged});

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  double _redValue = 0.0;
  double _greenValue = 0.0;
  double _blueValue = 0.0;

  Color _getColor() {
    return Color.fromARGB(
        255, _redValue.toInt(), _greenValue.toInt(), _blueValue.toInt());
  }

  void _updateColor() {
    final color = _getColor();
    widget.onColorChanged(color);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSliderRow('🟥', _redValue, (value) {
            setState(() {
              _redValue = value;
              _updateColor();
            });
          }),
          _buildSliderRow('🟩', _greenValue, (value) {
            setState(() {
              _greenValue = value;
              _updateColor();
            });
          }),
          _buildSliderRow('🟦', _blueValue, (value) {
            setState(() {
              _blueValue = value;
              _updateColor();
            });
          }),
        ],
      ),
    );
  }

  Widget _buildSliderRow(
      String label, double value, ValueChanged<double> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SliderTheme(
            data: const SliderThemeData(
              trackHeight:
                  2.0, // Optional: Adjust the track height to your preference
            ),
            child: Slider(
              value: value,
              onChanged: onChanged,
              min: 0.0,
              max: 255.0,
              label: '$value',
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 50, // Adjust the width as needed
          child: Text(
            value.toInt().toString(),
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
