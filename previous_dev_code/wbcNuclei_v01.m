function [] = wbcNuclei_v01(nuclMorph, num)
%
% wbcNuclei: Identify Leukocytes based on nulcei.
%
% INPUT:    im - image
%           num - figure number
% OUTPUT:   [] - figure
%

r = regionprops(logical(nuclMorph)); % obtain properties of the resulting image

% display the original image with the thresheld cross-corelation marked
figure(num);
imshow(nuclMorph,[]);

hold on
for i = 1:length(r)
    n = 3.*sqrt(r(i).Area/pi());
    rectangle('position',[r(i).Centroid(1)-n/2,r(i).Centroid(2)-n/2,n,n]...
        ,'Curvature',[1 1],'EdgeColor','g','LineWidth',2.5)
end

title(['Identified ',num2str(length(r)), ' Leukacyte(s) from Nuclei'])

end

