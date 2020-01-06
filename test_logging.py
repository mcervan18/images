import cv2

# image = cv2.imread('d415_images/square_1_Color.png')
image = cv2.imread('d415_images/penta_0a_Color.png')


blurred = cv2.GaussianBlur(image, (5, 5), 0)
gray = cv2.cvtColor(blurred, cv2.COLOR_BGR2GRAY)
lab = cv2.cvtColor(blurred, cv2.COLOR_BGR2LAB)
thresh = cv2.threshold(gray, 70, 255, cv2.THRESH_BINARY)[1]
# thresh = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 11, 2)


cv2.imshow('thresh', thresh)
cv2.imshow('blur', blurred)
cv2.waitKey(0)
cv2.destroyAllWindows()

