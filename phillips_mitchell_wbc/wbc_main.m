%% Leukocyte Identification
% Leukocyte (White Blood Cell) Identification MATLAB scripts
%
% ECSE 4540 - Introduction to Image Processing Final Project
% Mitchell Phillips, 661060944
%
% Last Updated: April 30, 2017
%

%% Notes
%
% Script used to generate (majority) of the results for project submission.
% 

%%

clc, clear, close all;
warning off;
set(0,'DefaultFigureWindowStyle','docked') % keep figures together

% import image(s)
addpath(genpath('images/')); % edit as needed

%% test001.jpg
%
% Preliminary Analysis
%

% import test image
im = imread('test_img.jpg');

% display test image
figure()
imshow(im)
title('Test Image')

%%
%
% After inital viewing of the test image, the grayscale and each of the RGB
% channels were investigated. 
%

imgray = rgb2gray(im); % grayscale image
R = im(:,:,1); % red channel
G = im(:,:,2); % green channel
B = im(:,:,3); % blue channel

figure()
subplot(2,2,1), imshow(imgray)
title('Grayscale')
subplot(2,2,2), imshow(R)
title('Red Channel')
subplot(2,2,3), imshow(G)
title('Green Channel')
subplot(2,2,4), imshow(B)
title('Blue Channel')

% color histogram
[Red, x] = imhist(R);
[Green, x] = imhist(G);
[Blue, x] = imhist(B);
%Plot them together in one plot
figure()
plot(x, Red, 'r', x, Green, 'g', x, Blue, 'b');
title('Color Histogram of Test Image')

%%
%
% replicating PPA
% "nucleus region was enhanced in the input images by averaging the pixel 
% values in the red and blue channels together and then dividing the sum 
% by the intensity value of the green channel ... Histogram equalization 
% was then applied to redistribute the image intensity to cover the whole 
% intensity range of both images"
%

nucl = histeq((R+B)./(2.*G));
figure()
imshow(nucl)
title('PPA Nuclei Enhancement')

%%
%
% Using a similar process as Prinyakupt and Pluempitiwiriyawej.
%

% adjusting luminosity - using MATLAB's tutorial

srgb2lab = makecform('srgb2lab');
lab2srgb = makecform('lab2srgb');
imlab = applycform(im, srgb2lab); % convert to L*a*b*

max_luminosity = 100;
L = imlab(:,:,1)/max_luminosity;

% replace the luminosity and convert
imlab_adjust = imlab;
imlab_adjust(:,:,1) = imadjust(L)*max_luminosity;
imlab_adjust = applycform(imlab_adjust, lab2srgb);

figure()
imshow(imlab_adjust)

%%
% 
% It is observered that the nuclei of the WBCs now appear to have a strong,
% dark blue color. The RGB color channels were
% investigated once again.
% 

imgray = rgb2gray(imlab_adjust); % grayscale image
R = imlab_adjust(:,:,1); % red channel
G = imlab_adjust(:,:,2); % green channel
B = imlab_adjust(:,:,3); % blue channel

figure()
subplot(2,2,1), imshow(imgray)
title('Grayscale')
subplot(2,2,2), imshow(R)
title('Red Channel')
subplot(2,2,3), imshow(G)
title('Green Channel')
subplot(2,2,4), imshow(B)
title('Blue Channel')


% color histogram
[Red, x] = imhist(R);
[Green, x] = imhist(G);
[Blue, x] = imhist(B);
%Plot them together in one plot
figure()
plot(x, Red, 'r', x, Green, 'g', x, Blue, 'b');
title('Color Histogram of Test Image with Contrast Enhancement ')

%%
%
% Exploring Weighted Differences
%

wB = [-1:0.4:1];
wR = [-1:0.4:1];

for i = 1:length(wB)
    for j = 1:length(wR)
        nucl = (wB(i)*B- wR(j)*R)./(G);
        figure()
        imshow(nucl)
    end
end

wB = 1;
wR = 0.75;

nuclBW = ((wB*B)-(wR*R))./(G);
figure()
imshow(nucl)


%%
%
% The previous is the binary image after performing color channel operations
% and thresholding to the enhanced image. From inspection, all 6 Leukocytes
% remain. Although the above image produces similar results to PPA, the 
% strength of the proposed algorithum shines when using Mohamed's data set,
% which is presented in the following section.
%

%%
%
% Once the binary image was obtained, the morphalogical transformations 
% were implemented to remove both any unwanted small objects or small holes
% from the nucleui, hence both the opening and closeing processes.
% The constructed algorithum is designated to be robust so a user may be
% able to adjust the structuring element sizes involved during the
% morphological processes. Ths may be changed depending on the resolution
% of the imported image(s) and the relative size of the WBS(s). The effects
% of applying morphological opening and subsequent closing are present
% below.
%

sqOpen = strel('disk',4);
nuclMorph = imopen(nuclBW,sqOpen);
sqClose = strel('disk', 4);
bw = imclose(nuclMorph,sqClose);

figure()
imshow(bw)

%%
% Above is the morphologically transformed binary image using the
% thresheld image as an input. Based on the image obtained and comparing it
% to before, it is seen that while both pixel islands and holes have
% been removed, some distinguishing characteristcs of the WBC nuclei have
% also been lost.
% The last step of the process in the algorithum is filtering out high
% intensity objects based on their relative area in the image and a tuning
% parameter of the user corresponding to data set being used. If the high
% intensity object area is less than a certain area, the object is mapped
% to a low intensity and is not considered a WBC. Once this is done, the
% results are indicated on the original, imported image with shappening and
% relayed back to the user. The results of the described area filter and
% information presentation is demonstrated below. 

tune = 125; % user inputted value for area filtering 

r = regionprops(logical(bw)); % obtain properties of the resulting image

% display the original image with the thresheld cross-corelation marked
figure()
imshow(im,[])
[m, n] = size(bw);

cnt = 0;

hold on
for i = 1:length(r)
    if r(i).Area>((m*n)/tune)
    n = 3.*sqrt(r(i).Area/pi());
    rectangle('position',[r(i).Centroid(1)-n/2,r(i).Centroid(2)-n/2,n,n]...
        ,'Curvature',[1 1],'EdgeColor','g','LineWidth',2.5)
    cnt = cnt + 1;
    end
end

title(['Identified ',num2str(cnt), ' Leukacyte(s) from Nuclei'])
hold off

%% Tests usign Images from Bloodline 

imN1 = imread('4303059.jpg');
imN2 = imread('4303041.jpg');
imN3 = imread('4303101.jpg');
imN4 = imread('4304032.jpg');

openStrl = 3;
closeStrl = 15;
thresh = 100;
tune = 50;

wbcNuclei_v06(imN1, openStrl, closeStrl, tune, 8);
wbcNuclei_v06(imN2, openStrl, closeStrl, tune, 9);
wbcNuclei_v06(imN3, openStrl, closeStrl, tune, 10);
wbcNuclei_v06(imN4, openStrl, closeStrl, tune, 11);

%% Test Using Mohammed's Data Set
%
% Images selected based on the ability to quickly import
% Construct a random batch from the image set. Stucturing sizes and 
% parameters tunnes after looking at results from three random images. 
%

% tuning parameters
openStrl = 3;
closeStrl = 15;
tune = 65;

figNum = 12; % figure number
a = 101;
b = 400;

batch = unique(round((b-a).*rand(50,1) + a));

for i = 1:length(batch)
    try
        imN = imread(['BloodImage_00',num2str(batch(i)),'.jpg']);
        wbcNuclei_v06(imN, openStrl, closeStrl, tune, 12+i)
    catch ME
        if ~strcmp(ME.identifier,'MATLAB:imagesci:imread:fileDoesNotExist')
            error(ME.message)
        end
    end
    figNum = figNum + 1;
end

%%
%
% Version 6 works pretty well on the data set as well as several other
% images. Has trouble with lighter cells.
%
% Work on nuclei extraction now.
%

%% References
%
% [1]: http://www.pathologystudent.com/?p=4776
%
% [2]: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4485641/pdf/12938_2015_Article_37.pdf
%
% [#]: https://www.mathworks.com/help/images/examples/contrast-enhancement-techniques.html
