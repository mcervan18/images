# import the necessary packages
from shapedetector import ShapeDetector
from colorlabeler import ColorLabeler
import imutils
import cv2

# full_image = cv2.imread('pattern_4_shapes.png')
# image = full_image[1:1000, 1:1000]

# image = cv2.imread('d415_images/penta1_a_Color.png')
# image = cv2.imread('pattern_test.png')
# image = cv2.imread('d415_images/square_1_Color.png')
image = cv2.imread('d415_images/penta_0a_Color.png')


# resized = imutils.resize(image, width=500)
# ratio = image.shape[0] / float(resized.shape[0])
ratio = 1

# convert the resized image to grayscale, blur it slightly,
# and threshold it
blurred = cv2.GaussianBlur(image, (5, 5), 0)
gray = cv2.cvtColor(blurred, cv2.COLOR_BGR2GRAY)
lab = cv2.cvtColor(blurred, cv2.COLOR_BGR2LAB)
thresh = cv2.threshold(gray, 70, 255, cv2.THRESH_BINARY)[1]

# thresh = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 11, 2)
#
# cv2.imshow('Threshold', thresh)
# cv2.waitKey(0)

# find contours in the threshold image and initialize the
# shape detector
cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,
                        cv2.CHAIN_APPROX_SIMPLE)

cnts = imutils.grab_contours(cnts)
print("I found {} shapes".format(len(cnts)))

sd = ShapeDetector()
cl = ColorLabeler()
counter = 0

# loop over the contours
for c in cnts:
    counter += 10
    # compute the center of the contour, then detect the name of the
    # shape using only the contour
    M = cv2.moments(c)
    if M["m00"] == 0:
        continue
    cX = int((M["m10"] / M["m00"]) * ratio)
    cY = int((M["m01"] / M["m00"]) * ratio)
    shape = sd.detect(c)
    size = cv2.contourArea(c)
    if size <= 50:
        continue
    color = cl.label(lab, c)
    # multiply the contour (x, y)-coordinates by the resize ratio,
    # then draw the contours and the name of the shape on the image
    c = c.astype("float")
    c *= ratio
    c = c.astype("int")
    text = "{} {} {}".format(shape, size, color)
    cv2.drawContours(image, [c], -1, (0, 255, 0), 2)
    cv2.putText(image, text, (cX, cY), cv2.FONT_HERSHEY_SIMPLEX,
                0.5, (255, 0, 0), 2)

# cv2.imwrite("detected_shapes_48.png", image)
cv2.imshow('Contours', image)
cv2.waitKey(0)
cv2.destroyAllWindows()
