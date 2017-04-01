function [] = wbcNuclei(bw, num)
%
% wbcNuclei: Identify Leukocytes based on nulcei.
%
% INPUT:    im - image
%           template - template to be cross-correlated on image
%           thresh - threshold
%           num - figure number
% OUTPUT:   [] - figure
%

r = regionprops(logical(bw)); % obtain properties of the resulting image

% display the original image with the thresheld cross-corelation marked
figure(num);
imshow(bw,[]);

hold on
for i = 1:length(r)
    n = 3.*sqrt(r(i).Area/pi());
    rectangle('position',[r(i).Centroid(1)-n/2,r(i).Centroid(2)-n/2,n,n]...
        ,'Curvature',[1 1],'EdgeColor','r','LineWidth',2)
end

end

