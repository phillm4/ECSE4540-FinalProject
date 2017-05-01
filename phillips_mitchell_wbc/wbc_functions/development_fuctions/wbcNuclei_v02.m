function [] = wbcNuclei_v02(im, num)
%
% wbcNuclei: Identify Leukocytes based on nulcei.
%
% INPUT:    im - image
%           num - figure number
% OUTPUT:   [] - figure
%

figure()
imshow(im)

R = im(:,:,1); % red channel
G = im(:,:,2); % green channel
B = im(:,:,3); % blue channel

imgray = rgb2gray(im);

figure()
subplot(2,2,1), imshow(imgray)
title('Grayscale')
subplot(2,2,2), imshow(R)
title('Red Channel')
subplot(2,2,3), imshow(G)
title('Green Channel')
subplot(2,2,4), imshow(B)
title('Blue Channel')

op = ((R+B)./(2.*G));
figure(); imshow(op); title('Channel Operation')
nucl = histeq(op);
figure(); imshow(nucl); title('Histogram EQ')
level = 150;
nuclBW = nucl > level;


sqOpen = strel('disk',2);
nuclMorph = imopen(nuclBW,sqOpen);
figure(); imshow(nuclMorph); title('Opening')
sqClose = strel('disk', 3);
bw = imclose(nuclMorph,sqClose);
figure(); imshow(bw); title('Closing')

r = regionprops(logical(bw)); % obtain properties of the resulting image

% display the original image with the thresheld cross-corelation marked
figure(num);
imshow(im,[]);

hold on
for i = 1:length(r)
    n = 3.*sqrt(r(i).Area/pi());
    rectangle('position',[r(i).Centroid(1)-n/2,r(i).Centroid(2)-n/2,n,n]...
        ,'Curvature',[1 1],'EdgeColor','g','LineWidth',2.5)
end

title(['Identified ',num2str(length(r)), ' Leukacyte(s) from Nuclei'])

end

