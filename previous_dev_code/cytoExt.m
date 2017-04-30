function type2 = cytoExt(im, A, B, C, D)
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

srgb2lab = makecform('srgb2lab');
lab2srgb = makecform('lab2srgb');

imlab = applycform(im, srgb2lab); % convert to L*a*b*

max_luminosity = 100;
L = imlab(:,:,1)/max_luminosity;

% contrast stretching with luminance
imlab_adjust = imlab;
imlab_adjust(:,:,1) = imadjust(L)*max_luminosity;
imlab_adjust = applycform(imlab_adjust, lab2srgb);

img = rgb2gray(im);
[m, n, o] = size(im);

mask = uint8(zeros(m,n,o));
bnd = [A+10,B-10,C+10,D-10]; % make window smaller
bnd(bnd<0) = 1;

mask(bnd(1):bnd(2),bnd(3):bnd(4),:) = 1;
mask = mask(1:m,1:n,:);
ROI = mask.*im; % region of interest

figure; imshow(ROI)


thresh = (ROI>155 & ROI<180);
figure; imshow(thresh)

cyto = bwareafilt(thresh,1,'largest');
figure; imshow(cyto)

r = regionprops(logical(cyto)); % image properties
cytoArea = r.Area;
E = entropy(cyto);
type2 = 0;

if E<0.05 & cytoArea< 3000
    type2 = 1;
end


disp('Area')
disp(cytoArea)
disp('Entropy')
disp(E)
fprintf('\n\n\n')

