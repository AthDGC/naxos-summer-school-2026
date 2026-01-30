#!/usr/bin/env python3
"""
Script to edit the 10th Naxos Summer School logo and update it to the 11th Naxos Summer School 2026.
Requires Pillow (PIL) library for image editing.
"""

from PIL import Image, ImageDraw, ImageFont
import os

# Paths
input_logo_path = "images/naxos-logo-10th.png"
output_logo_path = "images/naxos-logo-11th-2026.png"

# Load the existing logo
try:
    logo = Image.open(input_logo_path)
except FileNotFoundError:
    print(f"Error: The file {input_logo_path} does not exist.")
    print("Please download the 10th Naxos Summer School logo and save it as 'naxos-logo-10th.png' in the 'images' folder.")
    exit(1)

# Create a drawing context
draw = ImageDraw.Draw(logo)

# Define the new text
new_text = "11th Naxos Summer School 2026"

# Load a font (use a default font if a custom font is not available)
try:
    font = ImageFont.truetype("arial.ttf", size=40)
except IOError:
    font = ImageFont.load_default()
    print("Warning: Custom font not found. Using default font.")

# Calculate text size and position
text_width = draw.textlength(new_text, font=font)
text_height = font.size
logo_width, logo_height = logo.size
text_x = (logo_width - text_width) // 2
text_y = logo_height - text_height - 20  # Adjust this value to position the text

# Overlay the new text
draw.text((text_x, text_y), new_text, font=font, fill="white")

# Save the new logo
logo.save(output_logo_path)
print(f"Success! The new logo has been saved as {output_logo_path}")
