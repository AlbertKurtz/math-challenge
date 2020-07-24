import os
from PIL import Image


file_name = "new_background.png"
bck = Image.open("background.png")
list_numbers_images = []
for i in range(10):
	list_numbers_images.append(Image.open("{}.png".format(i)))

bck.paste(list_numbers_images[3], (200, 200))

bck.save(file_name)

