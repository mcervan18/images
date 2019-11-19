%% Testing patterns 

length_image=1200;     % length of the output image
width_image=400;      % width of the output image

n_feat_x = 11 ;
n_feat_y = 3 ; 

im(1:width_image,1:length_image,1:3)=0; 

%% Gradient 
first_color=[255,0,0];      % starting color RGB
second_color=[255, 200, 200] ;    % end color RGB
im(1:width_image,1:length_image,1:3)=0;  % preparing image for gradient
red_component=round(linspace(first_color(1),second_color(1),length_image));
green_component=round(linspace(first_color(2),second_color(2),length_image));
blue_component=round(linspace(first_color(3),second_color(3),length_image));
im=uint8(im);
for x=1:length(red_component)
    im(:,x,1)= red_component(x); 
    im(:,x,2)= green_component(x); 
    im(:,x,3)= blue_component(x); 
%     figure(1),imshow(final_image)
%     drawnow
end

figure 
imshow(im) 

feat_spacing_x = round(linspace(1,length_image,n_feat_x+2)) ; 
feat_spacing_y = round(linspace(1,width_image,n_feat_y+2)) ; 
feat_size = round(linspace(20, 80, 6)) ; 

%% Dots 

[p, q] = meshgrid(1:length_image, 1:width_image) ;
dots_logic = zeros(width_image, length_image) ; 

circle_rad = flip(feat_size)/2 ; 

for i = 1:6 
    for j = 1:3 
        dot_x = feat_spacing_x(2*i) ; 
        dot_y = feat_spacing_y(j+1) ; 
        dot_rad = circle_rad(i) ; 
        circlePixels = (q - dot_y).^2 + (p - dot_x).^2 <= dot_rad.^2 ; 
        dots_logic= dots_logic + circlePixels;
        dots_logic(dots_logic == 1) = 255; 
    end 
end 

for k = 1:3 
    im(:,:,k) = im(:,:,k) - uint8(dots_logic) ; 
end 
figure
imshow(im) 



%% Squares 

for i = 1:5 
    for j = 1:3 
        square_x = feat_spacing_x(2*i+1) - feat_size(i)/2  ; 
        square_y = feat_spacing_y(j+1) - feat_size(i)/2; 
        square_dx = square_x + feat_size(i) ; 
        square_dy = square_y + feat_size(i) ; 
        im(square_y:square_dy , square_x:square_dx, 1:3) = 0 ; 
    end 
end 

figure 
imshow(im) 

%% Dots

[p, q] = meshgrid(1:length_image, 1:width_image) ;
dots_logic = zeros(width_image, length_image) ; 

dot_x_a(1:4) = [feat_spacing_x(2), feat_spacing_x(3), feat_spacing_x(2), feat_spacing_x(3)] ; 
dot_y_a(1:4) = [feat_spacing_y(2), feat_spacing_y(3), feat_spacing_y(5), feat_spacing_y(4)] ; 
dot_rad_a = feat_size(3)/2 ; 

dot_x_b(1:2) = [feat_spacing_x(4), feat_spacing_x(5)] ; 
dot_y_b(1:2) = [feat_spacing_y(3), feat_spacing_y(2)] ; 
dot_rad_b = feat_size(2)/2 ; 

dot_x_c(1:2) = [feat_spacing_x(4), feat_spacing_x(5)] ; 
dot_y_c(1:2) = [feat_spacing_y(5), feat_spacing_y(4)] ; 
dot_rad_c = feat_size(1)/2 ; 

for i = 1:4 
    circlePixels = (q - dot_y_a(i)).^2 + (p - dot_x_a(i)).^2 <= dot_rad_a.^2 ; 
    dots_logic= dots_logic + circlePixels;
    dots_logic(dots_logic == 1) = 255; 
end

for i = 1:2 
    circlePixels = (q - dot_y_b(i)).^2 + (p - dot_x_b(i)).^2 <= dot_rad_b.^2 ; 
    dots_logic= dots_logic + circlePixels;
    dots_logic(dots_logic == 1) = 255; 
end

for i = 1:2 
    circlePixels = (q - dot_y_c(i)).^2 + (p - dot_x_c(i)).^2 <= dot_rad_c.^2 ; 
    dots_logic= dots_logic + circlePixels;
    dots_logic(dots_logic == 1) = 255; 
end


for i = 1:3 
    im(:,:,i) = im(:,:,i) - uint8(dots_logic) ; 
end 

imshow(im) 
%% 

square_x_a(1:4) = [feat_spacing_x(2), feat_spacing_x(3), feat_spacing_x(4), feat_spacing_x(5)]; 
square_y_a(1:4) = [feat_spacing_y(3), feat_spacing_y(2), feat_spacing_y(2), feat_spacing_y(3)]; 

square_x_b(1:2) = [feat_spacing_x(2), feat_spacing_x(3)]; 
square_y_b(1:2) = [feat_spacing_y(4), feat_spacing_y(5)]; 

square_x_c(1:2) = [feat_spacing_x(4), feat_spacing_x(5)]; 
square_y_c(1:2) = [feat_spacing_y(4), feat_spacing_y(5)]; 

for i = 1:4 
    im(square_x_a(i):square_x_a(i)+feat_size(1), square_y_a(i):square_y_a(i)-feat_size(1), 1:3) = 0; 
end 

for i = 1:2 
    im(square_x_b(i):square_x_b(i)+feat_size(2), square_y_b(i):square_y_b(i)-feat_size(2), 1:3) = 0;
    im(square_x_c(i):square_x_c(i)+feat_size(3), square_y_c(i):square_y_c(i)-feat_size(3), 1:3) = 0;
end 

imshow(im) 

%%
imwrite(im, 'pattern_test_long.png') 

%% testing algorithms 

bw_image = rgb2gray(im) ;
% [centers, radii] = imfindcircles(bw_image, [30 120], 'Sensitivity', 0.85) ; 

Ibw = imbinarize(bw_image,graythresh(bw_image));
% Ifill = imfill(Ibw,'holes');
% Iarea = bwareaopen(Ifill,100);
% Ifinal = bwlabel(Iarea);
stat = regionprops(Ibw,'boundingbox');
[centers, radii] = imfindcircles(Ibw, [10 50]) ; 

imshow(im); hold on;
viscircles(centers, radii, 'edgecolor', 'c') ; 
for cnt = 1 : numel(stat)
    bb = stat(cnt).BoundingBox;
    rectangle('position',bb,'edgecolor','b','linewidth',2);
end


