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
% tune parameter may be adjusted after looking at results a small set. 
%
% Can use other data sets if desired, but Mohamed's contains the most
% consistent set of images. WBC identification works well / is somewhat
% robust. Classification has been optimized to work with Mohamed's set.

classificationON = 1; % enter 1 if desired to have classification on. 

% tuning parameters
OP = 3; % morphological opening structuring element size
CL = 15; % morphological closing structuring element size
tune = 65; % resolution threshold tuning parameter

% batch sample for Mohamed data set
a = 000; % min is data set is 000
b = 410; % max in data set is 410
num = 100; % approximate number of sample. Set is less due to duplicates
batch = unique(round((b-a).*rand(num,1) + a));

% structuring element to count cells identified in each image
leukocyteID = cell(length(batch),3);

for i = 1:length(batch)
    try
        leukocyteID{i,1} = ['BloodImage_00',num2str(batch(i),'%03.0f'),'.jpg'];
        imN = imread(leukocyteID{i,1});
        [leukocyteID{i,2}, leukocyteID{i,3}] = wbcNucleiIdentification(...
            imN, OP, CL, tune, classificationON);
    catch ME
        if ~strcmp(ME.identifier,'MATLAB:imagesci:imread:fileDoesNotExist')
            error(ME.message)
        end
    end
end
%% Export Data
% export leukocyteID to txt for further analysis

% uncomment to save
T = cell2table(leukocyteID);
T.Properties.VariableNames = {'File' 'Count' 'Type'};
writetable(T,'wbcResults.csv','Delimiter','\t','WriteRowNames',true)
