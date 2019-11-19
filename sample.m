%% sample_images 

% close all 
% clear all 

sample_length = 300 ; 
sample_width = 300 ; 
feat_size = round(linspace(50, 80, 3)) ; 


%%
first_color=[255,0,0];      % starting color RGB
second_color=[255, 255, 255] ;    % end color RGB
gradient(1:sample_width,1:sample_length,1:3)=255;  % preparing image for gradient
red_component=round(linspace(first_color(1),second_color(1),sample_length));
green_component=round(linspace(first_color(2),second_color(2),sample_length));
blue_component=round(linspace(first_color(3),second_color(3),sample_length));
gradient=uint8(gradient);
for x=1:length(red_component)
    gradient(:,x,1)= red_component(x); 
    gradient(:,x,2)= green_component(x); 
    gradient(:,x,3)= blue_component(x); 
%     figure(1),imshow(final_image)
%     drawnow
end

figure 
imshow(gradient) 

%% Circle 

% simg(1:sample_width,1:sample_length, 1:length(feat_size))=0; 
simg(1:sample_width,1:sample_length, 1:length(feat_size))= 0;


for i = 1:length(feat_size) 
    [p, q] = meshgrid(1:sample_length, 1:sample_width) ;
    dots_logic = zeros(sample_length, sample_width) ; 
    dot_x = 150; 
    dot_y = 150 ;  
    dot_rad = feat_size(i) ;
    circlePixels = (q - dot_y).^2 + (p - dot_x).^2 <= dot_rad.^2 ; 
    dots_logic= dots_logic + circlePixels;
    dots_logic(dots_logic == 1) = 255; 
    simg(:,:,i) = rgb2gray(gradient) - uint8(dots_logic) ; 
    figure
    imshow(simg(:,:,i))
%     filename = input('Filename: ', 's') ; 
%     imwrite(simg(:,:,i), convertCharsToStrings(filename)) 
end 
   
im1 = simg(:,:,1) ; 
im2 = simg(:,:,2) ; 
im3 = simg(:,:,3) ; 
% 
% imwrite(im1, 'circle_1.png') 
% imwrite(im2, 'circle_2.png') 
% imwrite(im3, 'circle_3.png') 

%% Squares 



%% test 

base_im = rgb2gray(imread('pattern_test_4.png')) ; 

points1 = detectHarrisFeatures(im1) ;
points2 = detectHarrisFeatures(base_im) ; 

[feats1, vpts1] = extractFeatures(im1, points1) ;  
[feats2, vpts2] = extractFeatures(base_im, points2) ; 

indexPairs = matchFeatures(feats1, feats2) ; 

matched1points = vpts1(indexPairs(:,1), :); 
matched2points = vpts2(indexPairs(:,2), :); 

figure 
showMatchedFeatures(im1, base_im, matched1points, matched2points, 'montage') ; 


