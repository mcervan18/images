######

circles = cv2.HoughCircles(thresh,cv2.HOUGH_GRADIENT,1,20,
                            param1=50,param2=30,minRadius=0,maxRadius=0)

circles = np.uint16(np.around(circles))
for i in circles[0,:]:
    # draw the outer circle
    cv2.circle(thresh,(i[0],i[1]),i[2],(0,255,0),2)
    # draw the center of the circle
    cv2.circle(thresh,(i[0],i[1]),2,(0,0,255),3)

cv2.imshow('detected circles',thresh)
cv2.waitKey(0)
cv2.destroyAllWindows()