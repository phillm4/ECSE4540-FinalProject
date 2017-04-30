function flag = wbcNuclei_v04(im, thresh, tune, num)
%
% wbcNuclei: Identify Leukocytes based on nulcei.
%
% INPUT:    im - image
%           num - figure number
% OUTPUT:   [] - figure
%

% R = im(:,:,1); % red channel
% G = im(:,:,2); % green channel
% B = im(:,:,3); % blue channel

% sharpen image
im = imsharpen(im, 'Amount', [2], 'Threshold', 0.8, 'Radius', 0.5);

imgray = rgb2gray(im);
[m, n] = size(imgray);



Low_High = stretchlim(imgray)*255;
L = (255 / (Low_High(2) - Low_High(1))) * (imgray - Low_High(1));
L(L<0) = 0;
L(L>255) = 255;
H = histeq(L);
R1 = L+H;
R2 = L-H;
R3 = R1+R2;

for i = 1:3
    R3 = ordfilt2(R3,1,ones(3,3));
end

%level = graythresh(R3)*255;
bw = R3 < thresh;

% nucl = histeq((histeq(R)+histeq(B))./(2.*histeq(G)));
% level = 150;
% nuclBW = nucl > level;


sqOpen = strel('disk',9);
nuclMorph = imopen(bw,sqOpen);
sqClose = strel('disk', 15);
nuclMorph = imclose(nuclMorph,sqClose);

r = regionprops(logical(nuclMorph)); % obtain properties of the resulting image

% display the original image with the thresheld cross-corelation marked
figure(num);
imshow(im,[]);

cnt = 0;
hold on
for i = 1:length(r)
    if r(i).Area>((m*n)/tune)
        n = (2.5).*sqrt(r(i).Area/pi());
        rectangle('position',...
            [r(i).Centroid(1)-n/2,r(i).Centroid(2)-n/2,n,n]...
            ,'Curvature',[1 1],'EdgeColor','g','LineWidth',2.5)
        cnt = cnt + 1;
    end
end

if cnt > 3;
    title(['Identified ',num2str(cnt), ' Leukacyte(s) from Nuclei.',...
        '\color{red}Warning: Check Results'])
    flag = true;
else
    title(['Identified ',num2str(cnt), ' Leukacyte(s) from Nuclei'])
    flag = false;
end
end

