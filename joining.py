import os
from PIL import Image
import ImageHandler
import filtering
i = 7
pathname = ImageHandler.get_image(i)
created = False

for r,d,files in os.walk(pathname):
    for file in files:
        if file.endswith("_face.jpg"):
            img = Image.open(pathname + file[:-9] + ".jpg")
            width, height = img.size
        elif file.endswith("_upperbody.jpg"):
            img = Image.open(pathname + file[:-14] + ".jpg")
            width, height = img.size
        elif file.endswith("_lowerbody.jpg"): 
            img = Image.open(pathname + file[:-14] + ".jpg")
            width, height = img.size
        else:
            continue
        cropped_img = Image.open(pathname + file)
        should_be_added = filtering.check_num_pixels(cropped_img, img)
        #should_be_added = True
        if (should_be_added):
            pixels = img.load()
            if not created:
                new_img = Image.new('RGB', (width, height))
                new_pixels = new_img.load()
                created = True
            for x in range(width):
                for y in range(height):
                    if pixels[x, y] != (0,0,0):
                        new_pixels[x, y] = pixels[x,y]
if not created:
    print "Image not created"
else:
    new_img.show()
    new_img.save(pathname + "image" + str(i) + "Joined.jpg", "JPEG")

##for r,d,files in os.walk(pathname + "negative"):
##    for file in files:
##        if file.endswith("_cropped.jpg"):
##            im = Image.open(pathname + "negative/" + file[:-12] + ".jpg")
##            width, height = img.size
##        elif file.endswith("_upperbody.jpg"):
##            im = Image.open(pathname + "negative/" + file[:-14] + ".jpg")
##            width, height = img.size
##        elif file.endswith("_lowerbody.jpg"): 
##            im = Image.open(pathname + "negative/" + file[:-14] + ".jpg")
##            width, height = img.size
##        else:
##            continue
##        print file
##        pixels = img.load()
##        all_pixels = []
##        new_img = Image.new('RGB', (width, height))
##        new_pixels = new_img.load()
##        for x in range(width):
##            for y in range(height):
##                if pixels[x, y] != 0:
##                    new_pixels[x, y] = pixels[x,y]
