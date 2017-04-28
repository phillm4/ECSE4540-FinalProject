function [] = cytoExt(im, A, B, C, D)
%
% cytoExt: Extract Cytoplasm.
%
% INPUT:    
% OUTPUT:   [] - figure
%

% create zeros
% put ones in spots of interest
% element wise mult with og. 

% test image is mohamed 201

img = rgb2gray(im);
[m, n] = size(img);

mask = uint8(zeros(m,n));
bnd = [A,B,C,D];
bnd(bnd<0) = 1;

mask(bnd(1):bnd(2),bnd(3):bnd(4)) = 1;
mask = mask(1:m,1:n);
ROI = mask.*img; % region of interest

figure; imhist(ROI)

thresh = (ROI>155 & ROI<180);
figure; imshow(thresh)

cyto = bwareafilt(thresh,1,'largest');
figure; imshow(cyto)

r = regionprops(logical(cyto)); % image properties
cytoArea = r.Area;

