

import os 
filename = '1_Color.png'
from skimage import io 
moon = io.imread(filename)

from skimage.viewer import ImageViewer

viewer = ImageViewer(one)
viewer.show()

len, wid, rgb = one.shape