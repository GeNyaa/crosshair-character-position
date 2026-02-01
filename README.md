# Crosshair Addon

A customizable crosshair overlay addon for World of Warcraft that displays a simple crosshair in the center of your screen.

## Features

- **Customizable Crosshair**: Simple two-line crosshair design that appears in the center of your screen
- **Size Adjustment**: Adjustable X/Y-size from 5 to 100 pixels
- **Thickness Adjustment**: Adjust thickness from 1 to 100 pixels
- **Color Customization**: Full RGB color control with individual sliders for Red, Green, and Blue values
- **Position Control**: Fine-tune the crosshair position with X and Y offset sliders and input fields (range: -500 to +500)
- **Combat Only**: Set to show only in combat
- **Strata**: Set Strata level to choose how it overlap with other UI elements
- **Multi-Language Support**: Automatically detects and displays in:
  - English
  - German
  - Spanish
  - French
- **Easy Configuration**: Access settings via slash commands or through the in-game interface
- **Persistent Settings**: All preferences are saved and restored automatically

## Installation

1. Download the addon
2. Extract the `crosshair` folder to your `World of Warcraft\_retail_\Interface\AddOns\` directory
3. Restart World of Warcraft or type `/reload` in-game

## Usage

### Opening the Settings Menu

- Type `/crosshair` or `/ch` in chat
- Or navigate to: ESC → Interface → AddOns → Crosshair

### Configuration Options

- **Size**: Adjust the crosshair X/Y-size using the slider (5-100)
- **Thickness**: Adjust the crosshair thickness using the slider (1-100)
- **Color**: Customize the color using color picker
- **Border**: Add border to crosshair
- **Border Color**: Change color of the border
- **Border Thickness**: Change thickness of the border
- **Position**: Fine-tune the position using:
  - X Offset slider and input field (horizontal position)
  - Y Offset slider and input field (vertical position)
  - Reset Position button to center the crosshair
- **Enable/Disable**: Toggle the crosshair on or off
- **Show Only in Combat**: Toggle the crosshair to show only in combat
- **Strata**: Set Strata level to choose how it overlap with other UI elements

### Slash Commands

- `/crosshair` or `/ch` - Opens/closes the configuration menu

## Requirements

- World of Warcraft (Retail)
- Interface version 10.0.0 or higher

## Notes

- The crosshair is displayed at the "TOOLTIP" frame strata, ensuring it appears above most UI elements by default
- Position offsets are relative to the screen center
- All settings are saved per character

## Version

1.3.0

## Contributors

<a href="https://github.com/GeNyaa/crosshair-character-position/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=GeNyaa/crosshair-character-position" />
</a>

Forked from Nmxsz

## License

MIT License
