%% Authors: Prof. B. Boashash, Project leader
%           Dr. Hichem Barki, PostDoc of Prof. Boualem Boashash


%The following reference should be cited whenever this script is used:
% B. Boashash, H. Barki, S. Ouelha, Performance evaluation of
% time-frequency image feature sets for improved classification and
% Analysis of non-stationary signals: Application to Newborn EEG Seizure
% Detection, Knowledge-Based Systems, 2017.
%
% Additional information can be obtained from the following reference:
% 1) B. Boashash and S. Ouelha, "Automatic signal abnormality detection 
% using time-frequency features and machine learning: a newborn EEG seizure
% case study, "Knowledge-Based Systems, vol. 106, pp. 38-50, 2016.
% 2) B. Boashash, G. Azemi, and J. O' Toole, "Time-frequency processing of 
% nonstationary signals: Advanced TFD design to aid diagnosis with 
% highlights from medical applications," Signal Processing Magazine, IEEE, 
% vol. 30, no. 6, pp. 108-119, 2013.
%
% This study was funded by grants from the ARC and QNRF NPRP 6-885-2-364.

% Main script
% This script reproduces the results of the TF image features study with
% application to newborn EEG seizure detection
% Input:    Newborn EEG data (cf. seizure.mat and background.mat)
% Output 1:   Classification results (ROC analysis evaluation of features)
% Output 2:   Classification metrics (confusion matrix measures)
% of TF signal and TF image features
% Output 3:   Classification performance evaluation and comparison of the
% proposed TF image pattern recognition methodology with recent work
% http://dx.doi.org/10.1016/j.knosys.2016.05.027 using the same large and
% complex data set and the same experiment conditions.
% TFSAP is needed to run this code.
% Output 4: (Option) Classification results using feature selection (see
% Table 7).
% (time-consuming).

%% 1. Compute TFDs and perform ROC analysis of 1D, TF, and Hu features
clc; clear all, close all;
featureSelection=0;

fprintf('TF image features pattern recognition results');

ROCAnalysis

%% 2. Classification Performance Evaluation of TF signal and TF image features

ClassifPerfTFSignalImageFeat

%% 3. Comparison with Knowledge-based Systems 2016 paper
% Boualem Boashash, Samir Ouelha, Automatic signal abnormality detection
% using time-frequency features and machine learning: A newborn EEG seizure
% case study, Knowledge-Based Systems, Volume 106, 15 August 2016,
% Pages 38-50, ISSN 0950-7051,
% http://dx.doi.org/10.1016/j.knosys.2016.05.027.

Performance_Comparison_KBS

%% Feature selection using CKD and EMBD to reproduce the results depicted in Table 7.

if featureSelection == 1
    
    TFI_feature_selection
    
else
    
    load feature_Selection_CKD
    load feature_Selection_EMBD
    
end

%% EMBD
load('Features_up.mat');
tfdIdx = 3;
TF2DFeatTFD = TF2DFeat(:, :, tfdIdx);
TFHuFeatTFD = HuFeat(:, :, tfdIdx);
TFHaralickFeatTFD = HaralickFeat(:, :, tfdIdx);

% Normalize data
TF2DFeatTFD = normalizeFeat(TF2DFeatTFD);
TFHuFeatTFD = normalizeFeat(TFHuFeatTFD);
TFHaralickFeatTFD = normalizeFeat(TFHaralickFeatTFD);

% All TF signal and image features concatenated
AllFeat = cat(2, TF2DFeatTFD, TFHuFeatTFD, TFHaralickFeatTFD);
AllFeatM = crossValidate(AllFeat(:,:), ClassLabels);
fprintf(['For TF2D, Hu, Haralick features with EMBD: SEN, SPC, ACC: %0.2f \t %0.2f' ...
    '\t %0.2f\n'], AllFeatM.SEN*100, AllFeatM.SPC*100, AllFeatM.ACC*100);

AllFeatM = crossValidate(AllFeat(:,Xbest_EMBD), ClassLabels);
fprintf(['For TF2D, Hu, Haralick features with EMBD and feature Selection: SEN, SPC, ACC: %0.2f \t %0.2f' ...
    '\t %0.2f\n'], AllFeatM.SEN*100, AllFeatM.SPC*100, AllFeatM.ACC*100);

%% CKD
tfdIdx = 4;
TF2DFeatTFD = TF2DFeat(:, :, tfdIdx);
TFHuFeatTFD = HuFeat(:, :, tfdIdx);
TFHaralickFeatTFD = HaralickFeat(:, :, tfdIdx);

% Normalize data
TF2DFeatTFD = normalizeFeat(TF2DFeatTFD);
TFHuFeatTFD = normalizeFeat(TFHuFeatTFD);
TFHaralickFeatTFD = normalizeFeat(TFHaralickFeatTFD);

% All TF signal and image features concatenated
AllFeat = cat(2, TF2DFeatTFD, TFHuFeatTFD, TFHaralickFeatTFD);
AllFeatM = crossValidate(AllFeat(:,:), ClassLabels);
fprintf(['For TF2D, Hu, Haralick features with CKD: SEN, SPC, ACC: %0.2f \t %0.2f' ...
    '\t %0.2f\n'], AllFeatM.SEN*100, AllFeatM.SPC*100, AllFeatM.ACC*100);

AllFeatM = crossValidate(AllFeat(:,Xbest_CKD), ClassLabels);
fprintf(['For TF2D, Hu, Haralick features with CKD and feature selection: SEN, SPC, ACC: %0.2f \t %0.2f' ...
    '\t %0.2f\n'], AllFeatM.SEN*100, AllFeatM.SPC*100, AllFeatM.ACC*100);


