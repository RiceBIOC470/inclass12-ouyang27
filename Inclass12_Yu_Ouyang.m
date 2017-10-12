%Inclass 12. 

% Continue with the set of images you used for inclass 11, the same time 
% point (t = 30)

file = '011917-wntDose-esi017-RI_f0016.tif';
reader = bfGetReader(file);
chan = 2;
time = 30;
zplane = 1;
iplane2 = reader.getIndex(zplane-1,chan-1,time-1)+1;
img2 = bfGetPlane(reader,iplane2);

% 1. Use the channel that marks the cell nuclei. Produce an appropriately
% smoothed image with the background subtracted. 
%%
rad = 10;
sigma = 3;
fgauss = fspecial('gaussian', rad, sigma);
img_sm = imfilter(img2, fgauss);
img_bg = imopen(img_sm, strel('disk',1000));
img_sm_bgsub = imsubtract(img_sm, img_bg); 
imshow (img_sm_bgsub, [0, 4500]);

% 2. threshold this image to get a mask that marks the cell nuclei. 
%%
img_bw = img_sm_bgsub > 1000;

% 3. Use any morphological operations you like to improve this mask (i.e.
% no holes in nuclei, no tiny fragments etc.)
%%

img_close = imclose(img_bw, strel('disk', 5));
imshow(img_close);

% 4. Use the mask together with the images to find the mean intensity for
% each cell nucleus in each of the two channels. Make a plot where each data point 
% represents one nucleus and these two values are plotted against each other
cell_properties = regionprops(img_bw, img_sm_bgsub,'MeanIntensity','MaxIntensity','PixelValues','Area','Centroid');
intensities = [cell_properties.MeanIntensity];
areas = [cell_properties.Area];

plot(areas, intensities, 'r.', 'MarkerSize', 18);
xlabel('Area', 'FontSize', 28);
ylabel('Intensities','FontSize', 28);

