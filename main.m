%% Leukocyte Identification
% Leukocyte (White Blood Cell) Identification MATLAB scripts
%
% ECSE 4540 - Introduction to Image Processing Final Project
% Mitchell Phillips, 661060944
%
% Last Updated: April 1, 2017
%

%% Notes
%
% Currently in development. Using single image to perform preliminary
% identification algorithums.
%

%%

clc, clear, close all;
warning off;

% import image(s)
addpath('images/','test/');

%% test001.jpg
%
% Preliminary Analysis
%

% import test image
im = imread('test001.jpg');

% display test image
figure(1);
imshow(im);

%%
%
% Figure 1 was the test image for identifying Leukocytes. In the image, 
% there are 6 large purple blobs. These are the white blood cells; however,
% not all of these cells are the same. There are five different types of 
% white blood cells, each of which can be distinguished based on their 
% appearance: (1.) Neutrophils, (2.) Lymphocytes, (3.) Monocytes, 
% (4.) Eosinophils, and (5.) Basophils. (Note: each type is indicated on 
% the figure above.) Neutrophils can be identified by their pinched-in 
% nucleus (darker purple region) which may have a horseshoe-like 
% appearence. Lymphocytes contain a large, generally round and uniform 
% nuclues. Monocytes are distinguish from their large nuclues, similar to 
% that of Lymphocytes, except they contain more cytoplasm (the light purple
% surounding the nucleus. Eosinphils are similar to Neutrophils in 
% appearance, with large granules (small dark purple dots) in the 
% cytoplasm. Basophils are the easiest to distinguish as they are
% characterized by large, dark purple granules. These five types of
% Leukocytes can be split into two distinct groups based on the granules; 
%
% 1.) Granulocytes - Basophil, Eosinophil, and Neutrophil
%
% 2.) Agranulocytes - Lymphocytes and Monocytes
%
% Reference: [1]
%

%%
%
% After inital viewing of the test image, the grayscale and each of the RGB
% channels were investigated. 
%

imgray = rgb2gray(im); % grayscale image
R = im(:,:,1); % red channel
G = im(:,:,2); % green channel
B = im(:,:,3); % blue channel

figure(2)
subplot(2,2,1), imshow(imgray)
title('Grayscale')
subplot(2,2,2), imshow(R)
title('Red Channel')
subplot(2,2,3), imshow(G)
title('Green Channel')
subplot(2,2,4), imshow(B)
title('Blue Channel')

%%
%
% Figure 2 contains the grayscale, red, green, and blue channels, of the
% image shown in figure 1. It is observered that the in the test image, the
% Leukocytes contain large intensities in the blue channel, however that is
% true of most of the image. This is indicated by the fact that the
% majority of the image is made up of lighter shades. Conversely, in the
% greyscale, red, and green channels, the Leukocytes are characterized by
% lower intensity values. The intensitivity behavior can be attributed to 
% violet color of the Leukocytes from the original image. It is noted that 
% the dark characterization however is only true for the nucleui, not the 
% cytoplasm. 


%%
%
% Using a similar process as Prinyakupt and Pluempitiwiriyawej [2],
% nucleus segmentation was first performed by averaging the red and blue
% channel intensites. This was done because the the green channel contains
% the lowest pixel intensities of the nuclues (as indicated in figure 2).
% Results are shown below,
%

nucl = histeq((R+B)./(2.*G));

figure(3);
imshow(nucl)

%%
%
% Figure 3 is the histogram equalized image of figure 1. Based on the
% image above, the nucleui of each of the Leukocytes can be distinguished.
% This was perform by first inspecting the histogram levels after
% equalization, thresholding the image appropriatly, and
% applying morphalogical transformations to fill in any gaps that may
% occur.
%

figure(4);
imhist(nucl);

%%
%
% Figure 4 is the histogram corresponding to figure 3. Based on the
% obtained values, a threshold of pixel intensity of 150 will be used.
% Results are shown below.
%

level = 150;
nuclBW = nucl > level;

figure(5);
imshow(nuclBW);

%%
%
% Figure 5 is the binary image from figure 3 after thresholding. From
% inspection, all 6 Leukocytes remain. However, there are several holes and
% undesired elements in the figure. To improve the image and accomadate the
% identification algorithum, the morphalogical transformations were
% performed. 
%

%% References
%
% [1]: http://www.pathologystudent.com/?p=4776
% [2]: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4485641/pdf/12938_2015_Article_37.pdf
