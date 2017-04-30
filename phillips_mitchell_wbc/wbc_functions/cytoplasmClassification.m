function type = cytoplasmClassification(im, A, B, C, D)
%
% cytoplasmClassification: Identify WBC type based on cytoplasm.
% Note: not robust. Works well for Mohamed data set.
%
% INPUT:    im - image (note: must be color, NOT grayscale)
%           A,B,C,D - region of interest bounds
% OUTPUT:   type - type of wbc identified
%           [] - figures (if desired)
%

[m, n, o] = size(im);

% region of interest mask
mask = uint8(zeros(m,n,o));
bnd = [A+5,B-5,C+5,D-5]; % make window smaller, assists entropy calc.
bnd(bnd<0) = 1;

% consrtuct region of interst
mask(bnd(1):bnd(2),bnd(3):bnd(4),:) = 1;
mask = mask(1:m,1:n,:);
ROI = mask.*im; % region of interest
%figure; imshow(ROI)

% convert to HSV, threshold hue to get cytoplasm
imgh = rgb2hsv(ROI);
imgh = imgh(:,:,1);
cyto = (imgh>0.74 & imgh<0.8); % edit these for different data sets
%figure; imshow(cyto)

E = entropy(cyto); % entropy of cytoplasm
type = 0;

% classify type of WBC based off of cyoplasm entropy
if E<=0.047
    type = 2; % Lymphocyte
elseif 0.047<E && E<=0.1
    type = 3; % Monocyte
elseif 0.1<E
    type = 1; % either Neutrophil or Eosinophils
end

% uncomment these to return entropy information to user
% disp('Entropy')
% disp(E)
% disp(type)
% fprintf('\n')

end