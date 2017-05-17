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


function [Sen,Spe] = roc_rates_function(method_out,ref_mask,N_thresh)
% method_out (N_seg x 1): Output vector of the method
% (maximum values over templates)
% ref_mask (1 x N_seg): Reference seiz/nonseiz binary mask
% N_thresh (integer): Number of thresholding levels for the ROC plot

%% Compute True Positive and False Negative rates
% thresholds for computing the ROC curve
thresh = linspace(min(method_out),max((method_out)),N_thresh);

TP = zeros(1,N_thresh);
FN = zeros(1,N_thresh);
TN = zeros(1,N_thresh);
FP = zeros(1,N_thresh);
Sen = zeros(1,N_thresh);
Spe = zeros(1,N_thresh);

for i = 1 : N_thresh
    
    thresh_i = thresh(i);
    
    %%% Decision making process based on a pre-defined incidence matrix
    mask_i = method_out<=thresh_i;
    % (N_seg x 1) If the seizure is observed completely in at least 
    % one region of adjacent channels
    
    TP(i) = sum(ref_mask.*mask_i'); % True Positive Rate for method 1
    FP(i) = sum((1-ref_mask).*mask_i'); % False Positive Rate for method 1
    TN(i) = sum((1-ref_mask).*(1-mask_i)');% True Negative Rate method 1
    FN(i) = sum(ref_mask.*(1-mask_i)');   % False Negative Rate
    Sen(i) = TP(i)/(TP(i)+FN(i));         % Sensitivity
    Spe(i) = TN(i)/(TN(i)+FP(i));         % Specificity
    
end