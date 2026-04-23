import sys
import os
from PIL import Image, ImageDraw

def process():
    image_path = r"C:\Users\3bdelrahman\.gemini\antigravity\brain\66ba515d-af91-49d7-991a-6df0d3aa00da\media__1776896329832.png"
    output_path = r"d:\TomatoTime\tomato_time\assets\icon.png"
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    img = Image.open(image_path).convert("RGBA")
    
    ImageDraw.floodfill(img, (0, 0), (255, 255, 255, 0), thresh=30)
    ImageDraw.floodfill(img, (img.width-1, 0), (255, 255, 255, 0), thresh=30)
    ImageDraw.floodfill(img, (0, img.height-1), (255, 255, 255, 0), thresh=30)
    ImageDraw.floodfill(img, (img.width-1, img.height-1), (255, 255, 255, 0), thresh=30)
    
    img.save(output_path, "PNG")
    print("Saved to", output_path)

if __name__ == '__main__':
    process()
