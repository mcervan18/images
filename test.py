from PIL import Image 

import os 
filename = 'dots.png'
from skimage import io 
dots = io.imread(filename)

lines = io.imread('2_color.png')


from skimage.viewer import ImageViewer

viewer = ImageViewer(lines)
viewer.show()

# len, wid, rgb = dots.shape

# mask = dots < 87 

## from PIL import Image 
# img = Image.open('dots.png').convert('LA')
# img.save('gray.png') 

dots1 = dots[:,:,1]
lines1 = dots[:,:,1]

im_dots1 = Image.fromarray(dots1)
im_dots1.show()
im_lines1 = Image.fromarray(lines)
im_lines1.show()

from skimage.feature import canny 
edges = canny(dots1)

im_edges = Image.fromarray(edges)
im_edges.show()

from scipy import ndimage as ndi 
fill_dots = ndi.binary_fill_holes(edges)

im_fill = Image.fromarray(fill_dots)
im_fill.show()