function [nuclei, wbcType] = wbcNucleiIdentification(im, OP, CL, tune, ty)
%
% wbcNuclei: Identify Leukocytes based on nulcei.
%
% INPUT:    im - image
%           OP - opening structuring element size
%           CL - closing structuring element size
%           tune - parameter related to area limit and resolution
% OUTPUT:   [] - figures
%           nuclei - number of WBC's identified in image
%           wbcType - vector returning type of each WBC identified
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

nuclBW = ((1*B)-(0.75*R))./(G); % result will be capped at 0 or 1 (255)
level = 150;
nuclBW = nuclBW > level; % preventative measure


sqOpen = strel('disk',OP);
nuclMorph = imopen(nuclBW,sqOpen);
sqClose = strel('disk', CL);
bw = imclose(nuclMorph,sqClose);

r = regionprops(logical(bw)); % obtain properties of the resulting image

% display the original image with the thresheld cross-corelation marked
figure()
imshow(im,[])
[m, n] = size(bw);

cnt = 0; % number of WBCs
type = 0; % classification for one WBC
wbcType = 0; % classifcation vector to be returned to user

hold on
for i = 1:length(r)
    if r(i).Area>((m*n)/tune) % relative area threshold for WBC
        z = 3.*sqrt(r(i).Area/pi()); % identification circle
        col = 'g';
        
        % region of interest bounds
        A = round(r(i).Centroid(2)-z/2);
        B = round((r(i).Centroid(2)-z/2)+z);
        C = round(r(i).Centroid(1)-z/2);
        D = round((r(i).Centroid(1)-z/2)+z);
        
        if ty == 1 % if classification is turned on
            
            % WBC classification based on entropy
            type = cytoplasmClassification(im, A, B, C, D);
            
            if type == 1
                col = 'b'; % either Neutrophil or Eosinophils
            elseif type == 2
                col = 'm'; % Lymphocyte
            elseif type == 3
                col = 'r'; % Monocyte
            end
        end
        
        rectangle('position', [C,A,z,z],...
            'Curvature',[1 1],'EdgeColor',col,'LineWidth',2.5)
        
        cnt = cnt + 1;
        
        if type > 0
            wbcType = horzcat(wbcType,type);
        end 
    end
end

title(['Identified ',num2str(cnt), ' Leukocyte(s) from Nucleus'])

% return information to user / output
nuclei = cnt;
if length(wbcType) > 1
    wbcType(1) = []; % remove 0 if classification is on
end

end