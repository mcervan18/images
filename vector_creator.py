from shapedetector import ShapeDetector
from colorlabeler import ColorLabeler
import numpy as np
import imutils
import cv2

full_image = cv2.imread('pattern_long_color.png')
width_im, length_im = full_image.shape[:2]
num_frames = 10
frame_spacing = length_im/(num_frames+1)

full_vector = []

full_final_vector = []

sd = ShapeDetector()
# shapes = sd.shapeNames
shapes = ["triangle", "square", "rectangle", "pentagon", "circle"]
cl = ColorLabeler()
colors = cl.colorNames

for i in range(num_frames):
    vector = []
    final_vector = []
    im_start = (i*frame_spacing) + 1
    im_end = (i*frame_spacing) + width_im
    if im_start >= length_im:
        print('error')
        break

    if im_end >= length_im:
        current_im = full_image[1:width_im,im_start:length_im]
    else:
        current_im = full_image[1:width_im,im_start:im_end]

    blurred = cv2.GaussianBlur(current_im, (5, 5), 0)
    gray = cv2.cvtColor(blurred, cv2.COLOR_BGR2GRAY)
    lab = cv2.cvtColor(blurred, cv2.COLOR_BGR2LAB)
    thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY)[1]

    cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,
                            cv2.CHAIN_APPROX_SIMPLE)

    cnts = imutils.grab_contours(cnts)

    # loop over the contours
    for c in cnts:
        # compute the center of the contour, then detect the name of the
        # shape using only the contour
        M = cv2.moments(c)
        cX = int((M["m10"] / M["m00"]))
        cY = int((M["m01"] / M["m00"]))
        shape = sd.detect(c)
        size = cv2.contourArea(c)
        size_f = round(size * 0.001, 1) * 1000
        color = cl.label(lab, c)
        vector.append([shape, size_f, color])

    full_vector.append(vector)
    vector_count = 0

    for sh in shapes:
        for co in colors:
            final_vector.append([])
            for v in range(len(vector)):
                if vector[v][0] == sh and vector[v][2] == co:
                    final_vector[vector_count].append([vector[v][1]])
            num_feats = len(final_vector[vector_count])
            final_vector[vector_count] = [(np.mean(final_vector[vector_count]))]
            final_vector[vector_count].append(num_feats)
            vector_count += 1

    full_final_vector.append(final_vector)





