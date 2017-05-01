%% Leukocyte Identification
% Leukocyte (White Blood Cell) Identification MATLAB scripts
%
% ECSE 4540 - Introduction to Image Processing Final Project
% Mitchell Phillips, 661060944
%
% Last Updated: April 30, 2017
%

%% Notes
%
% Demo script to showcase WBC identification and preliminary classification
%

%%

clc, clear, close all;
warning off;
set(0,'DefaultFigureWindowStyle','docked')

% add functions to path
addpath('wbc_functions/')

% import image(s)
addpath(genpath('images/')) % edit as needed

%% Demo using Mohamed's Data Set
%
% Images selected based on the ability to quickly import.
% Construct a random batch from the image set. Stucturing sizes and 
% tuning parameter may be adjusted after looking at results of a small set. 
%
% Can use other data sets if desired, but Mohamed's contains the most
% consistent set of images. WBC identification works well / is somewhat
% robust. Classification was created usign Mohamed's set.
%
% If using classification;
%   Blue   circles: type 1, either Neutrophil or Eosinophils, high entropy
%   Purple circles: type 2, Lymphocyte, low entropy
%   Red    circles: type 3, Monocyte, medium entropy
%

classification = 1; % enter 1 if desired to have classification on. 0 = off

% tuning parameters
OP = 3; % morphological opening structuring element size
CL = 15; % morphological closing structuring element size
tune = 65; % resolution threshold tuning parameter

% batch sample for Mohamed data set
a = 000; % min is data set is 000
b = 410; % max in data set is 410
num = 15; % approximate number of samples
batch = unique(round((b-a).*rand(num,1) + a)); % prevent duplicates

% structuring element to count cells identified in each image
leukocyteID = cell(length(batch),3);

for i = 1:length(batch)
    try
        leukocyteID{i,1} = ['BloodImage_00',num2str(batch(i),'%03.0f'),...
            '.jpg'];
        imN = imread(leukocyteID{i,1});
        [leukocyteID{i,2}, leukocyteID{i,3}] = wbcNucleiIdentification(...
            imN, OP, CL, tune, classification);
    catch ME
        if ~strcmp(ME.identifier,'MATLAB:imagesci:imread:fileDoesNotExist')
            error(ME.message)
        end
    end
end

%% Export Data
%
% export leukocyteID to txt for further analysis
%

% uncomment to save
% T = cell2table(leukocyteID);
% T.Properties.VariableNames = {'File' 'Count' 'Type'};
% writetable(T,'wbcResults.csv','Delimiter',',','WriteRowNames',true)


%% Tests using Images from Bloodline
%
% May need to manually adjust names in folder if it is desired to test more
% images from Bloodline. Images listed here will work.
%

imB1 = imread('4303059.jpg');
imB2 = imread('4303041.jpg');
imB3 = imread('4303101.jpg');
imB4 = imread('4304032.jpg');

opStrl = 3;
clStrl = 15;
tune = 75;

wbcNucleiIdentification(imB1, opStrl, clStrl, tune, classification);
wbcNucleiIdentification(imB2, opStrl, clStrl, tune, classification);
wbcNucleiIdentification(imB3, opStrl, clStrl, tune, classification);
wbcNucleiIdentification(imB4, opStrl, clStrl, tune, classification);

%% Default Image

test_im = imread('test_img.jpg');

opStrl = 4;
clStrl = 4;
tune = 125;
classification = 0; % classification does not work well on default image

wbcNucleiIdentification(test_im, opStrl, clStrl, tune, classification);
