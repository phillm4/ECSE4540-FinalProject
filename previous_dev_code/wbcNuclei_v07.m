function [] = wbcNuclei_v07(im, OP, CL, tune, num)
%
% wbcNuclei: Identify Leukocytes based on nulcei.
%
% INPUT:    
% OUTPUT:   [] - figure
%

srgb2lab = makecform('srgb2lab');
lab2srgb = makecform('lab2srgb');

imlab = applycform(im, srgb2lab); % convert to L*a*b*

max_luminosity = 100;
L = imlab(:,:,1)/max_luminosity;

% contrast stretching with luminance
imlab_adjust = imlab;
imlab_adjust(:,:,1) = imadjust(L)*max_luminosity;
imlab_adjust = applycform(imlab_adjust, lab2srgb);

R = imlab_adjust(:,:,1); % red channel
G = imlab_adjust(:,:,2); % green channel
B = imlab_adjust(:,:,3); % blue channel

nucl = ((1*B)-(0.75*R))./(G);
level = 150;
nuclBW = nucl > level;

sqOpen = strel('disk',OP);
nuclMorph = imopen(nuclBW,sqOpen);
sqClose = strel('disk', CL);
bw = imclose(nuclMorph,sqClose);

r = regionprops(logical(bw)); % obtain properties of the resulting image

% display the original image with the thresheld cross-corelation marked
figure(num);
imshow(im,[]);
[m, n] = size(bw);

cnt = 0;
type = 0;
id =0;

hold on
for i = 1:length(r)
    if r(i).Area>((m*n)/tune)
    n = 3.*sqrt(r(i).Area/pi());
    col = 'g';
    
    % cyto functions
    A = round(r(i).Centroid(2)-n/2);
    B = round((r(i).Centroid(2)-n/2)+n);
    C = round(r(i).Centroid(1)-n/2);
    D = round((r(i).Centroid(1)-n/2)+n);
    

    type = cytoExt2(im, A, B, C, D);
    

    
    if type == 1
       % id = 1;
        col = 'b'; % either Neutrophil or Eosinophils
    elseif type == 2
        col = 'm'; % Lymphocyte
    elseif type == 3 % Monocyte
        col = 'r';
    end
    
        rectangle('position',[r(i).Centroid(1)-n/2,r(i).Centroid(2)-n/2,n,n]...
        ,'Curvature',[1 1],'EdgeColor',col,'LineWidth',2.5)
    cnt = cnt + 1;
    
    end
end

title(['Identified ',num2str(cnt), ' Leukacyte(s) from Nuclei'])
% if id ~= 0
%     title(['Identified ',num2str(cnt),...
%         ' Leukacyte(s). Includes Lymphocyte'])
% end