%% Authors: Prof. B. Boashash, Project leader
%           Dr. Hichem Barki, PostDoc of Prof. Boualem Boashash

% The following reference should be cited whenever this script is used:
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
%
% This script uses a state-of-the-art classifier and a cross-validation
% process, in order to evaluate the classification performance of the
% TF signal and image features, according to several metrics

clear
fprintf(['\n2. Classification performance evaluation for 1D,'...
    'TF signal and image features\n']);
%% Parameters
kernel = {'WVD' 'SPEC' 'EMBD' 'CKD' 'MDD'}; % TFD kernel

load('Features_up.mat');

for tfdIdx = 1:5
    fprintf('\nKernel Number %d: %s\n', tfdIdx, char(kernel(tfdIdx)));
    % Load TFD data samples
    TF2DFeatTFD = TF2DFeat(:, :, tfdIdx);
    TFHuFeatTFD = HuFeat(:, :, tfdIdx);
    TFHaralickFeatTFD = HaralickFeat(:, :, tfdIdx);
    TFLBPFeatTFD = LBPFeat(:, :, tfdIdx);
    
    % Normalize data
    TF2DFeatTFD = normalizeFeat(TF2DFeatTFD);
    TFHuFeatTFD = normalizeFeat(TFHuFeatTFD);
    TFHaralickFeatTFD = normalizeFeat(TFHaralickFeatTFD);
    TFLBPFeatTFD = normalizeFeat(TFLBPFeatTFD);
    
    % All TF signal and image features concatenated
    AllFeat = cat(2, TF2DFeatTFD, TFHuFeatTFD, TFHaralickFeatTFD, ...
        TFLBPFeatTFD);
    
    % Cross-validate
    TF2DM = crossValidate(TF2DFeatTFD, ClassLabels);
    HuFeatM = crossValidate(TFHuFeatTFD, ClassLabels);
    HaralickFeatM =crossValidate(TFHaralickFeatTFD,ClassLabels);
    LBPFeatM = crossValidate(TFLBPFeatTFD, ClassLabels);
    AllFeatM = crossValidate(AllFeat, ClassLabels);
    fprintf(['For TF2D features: SEN, SPC, ACC: %0.2f \t %0.2f' ...
        '\t %0.2f\n'], TF2DM.SEN*100, TF2DM.SPC*100, TF2DM.ACC*100);
    fprintf(['For Hu features: SEN, SPC, ACC: %0.2f \t %0.2f \t ' ...
        '%0.2f\n'], HuFeatM.SEN*100, HuFeatM.SPC*100, HuFeatM.ACC*100);
    fprintf(['For Haralick features: SEN, SPC, ACC: %0.2f \t %0.2f '...
        '\t %0.2f\n'], HaralickFeatM.SEN*100, HaralickFeatM.SPC*100, ...
        HaralickFeatM.ACC*100);
    fprintf(['For LBP features: SEN, SPC, ACC: %0.2f \t %0.2f \t'...
        '%0.2f\n'], LBPFeatM.SEN*100, LBPFeatM.SPC*100, ...
        LBPFeatM.ACC*100);
    fprintf(['For All features: SEN, SPC, ACC: %0.2f \t %0.2f \t' ...
        '%0.2f\n'], AllFeatM.SEN*100, AllFeatM.SPC*100, ...
        AllFeatM.ACC*100);
end

