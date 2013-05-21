from PIL import Image
import ImageHandler

def check_null_pixels(cropped_img):
    w1, h1 = cropped_img.size
    pixels = cropped_img.load()
    num_pixels_mask = 0
    num_pixels_inside = 0
    for x in range(w1):
        for y in range(h1):
            if pixels[x,y] == (0,0,0):
                num_pixels_mask +=1
            else:
                num_pixels_inside += 1
    if (num_pixels_mask > num_pixels_inside):
        return False
    else:
        return True

def check_num_pixels(cropped_img, seg_img):
    w1, h1 = cropped_img.size
    w2, h2 = seg_img.size
    pixels = cropped_img.load()
    seg_pixels = seg_img.load()
    num_pixels_crop = 0
    num_pixels_seg = 0
    for x in range(w1):
        for y in range(h1):
            if pixels[x,y] != (0,0,0):
                num_pixels_crop +=1
    for x in range(w2):
        for y in range(h2):
            if seg_pixels[x,y] != (0,0,0):
                num_pixels_seg +=1
    if (num_pixels_crop < num_pixels_seg*0.4):
        return False
    else:
        return True
