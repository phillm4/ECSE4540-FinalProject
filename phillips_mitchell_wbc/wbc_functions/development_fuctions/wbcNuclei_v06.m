function [] = wbcNuclei_v06(im, OP, CL, tune, num)
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

end