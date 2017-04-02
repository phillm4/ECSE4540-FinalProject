function [] = wbcNuclei(im, num)
%
% wbcNuclei: Identify Leukocytes based on nulcei.
%
% INPUT:    im - image
%           template - template to be cross-correlated on image
%           thresh - threshold
%           num - figure number
% OUTPUT:   [] - figure
%

R = im(:,:,1); % red channel
G = im(:,:,2); % green channel
B = im(:,:,3); % blue channel

nucl = histeq((R+B)./(2.*G));
level = 150;
nuclBW = nucl > level;


sqOpen = strel('disk',2);
nuclMorph = imopen(nuclBW,sqOpen);
sqClose = strel('disk', 15);
bw = imclose(nuclMorph,sqClose);

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

title(['Identified ',num2str(length(r)), ' Leukacytes'])

end

