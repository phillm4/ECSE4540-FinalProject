function type = cytoplasmClassification(im, A, B, C, D)
%
% cytoplasmClassification: Identify WBC type based on cytoplasm.
% Note: not robust. Works well for Mohamed data set.
% May uncomment figures if desired.
%
% INPUT:    im - image (note: must be color, NOT grayscale)
%           A,B,C,D - region of interest bounds
% OUTPUT:   type - type of wbc identified
%           [] - figures (if desired)
%

[m, n, o] = size(im);

% region of interest mask
mask = uint8(zeros(m,n,o));
bnd = [A+5,B-5,C+5,D-5]; % adjust window if needed.
bnd(bnd<1) = 1;

% consrtuct region of interst
mask(bnd(1):bnd(2),bnd(3):bnd(4),:) = 1;
mask = mask(1:m,1:n,:);
ROI = mask.*im; % region of interest
% figure; imshow(ROI); title('Region of Interest')

% convert to HSV, threshold hue to get cytoplasm
imgh = rgb2hsv(ROI);
% figure; imshow(imgh); title('Region of Interest - HSV Color Space')
imgh = imgh(:,:,1);
% figure; imshow(imgh); title('Region of Interest - Hue Value')
% figure(); imhist(imgh); title('Region of Interest - Hue Histogram')
cyto = (imgh>0.74 & imgh<0.81); % edit these for different data sets
% figure; imshow(cyto); title('Region of Interest - Cytoplasm')

E = entropy(cyto); % entropy of cytoplasm
type = 0;

% classify type of WBC based off of cyoplasm entropy
if E<=0.047
    type = 2; % Lymphocyte or Monocyte
elseif 0.047<E && E<=0.1
    type = 3; % Possible Monocyte or Neutrophil
elseif 0.06<E
    type = 1; % either Neutrophil or Eosinophils
end

% uncomment these to return entropy information to user
% disp('Entropy')
% disp(E)
% disp(type)
% fprintf('\n')

end