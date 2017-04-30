function type = cytoExt2(im, A, B, C, D)
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


[m, n, o] = size(im);

mask = uint8(zeros(m,n,o));
bnd = [A+5,B-5,C+5,D-5]; % make window smaller
bnd(bnd<0) = 1;

mask(bnd(1):bnd(2),bnd(3):bnd(4),:) = 1;
mask = mask(1:m,1:n,:);
ROI = mask.*im; % region of interest

%figure; imshow(ROI)

imgh = rgb2hsv(ROI);
imgh = imgh(:,:,1);
cyto = (imgh>0.74 & imgh<0.8);
%figure; imshow(cyto)

% cyto = bwareafilt(thresh,1,'largest');
% figure; imshow(cyto)

% r = regionprops(logical(cyto)); % image properties
% cytoArea = r.Area;


E = entropy(cyto);
type = 0;

if E<=0.047
    type = 2;
elseif 0.047<E && E<=0.1
    type = 3;
elseif 0.1<E
    type = 1;
end

% 
% disp('Area')
% disp(cytoArea)
disp('Entropy')
disp(E)
disp(type)
fprintf('\n\n')

