%% Authors:  Prof. B. Boashash, Project leader
%            Dr.  Hichem Barkiand Dr. Samir Ouelha, PostDocs of Prof. Boualem Boashash

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

%% parameters
kernel = {'EMBD' 'CKD'}; % TFD kernel

%% Previous results
fprintf('\n')
fprintf('\n')
disp('Results from KBS 2016 paper');
disp('Kernel EMBD: ACC: 77.13%');
disp('Kernel CKD: ACC: 78.06%');

%% Results using the proposed methodology

fprintf('\nResults of the proposed TF image features pattern recognition');
fprintf('\n')
load result_CKD

[~, ~, ~, ACC_CKD, Sen_CKD, Spe_CKD] = performanceEstimationRandomForests...
    (length_features, signal_features, signal_class, 1:size(signal_features,3));

fprintf('Accuracy using TFI features from CKD is  : %0.4f\n',ACC_CKD)
fprintf('\n')

load result_EMBD

[~, ~, ~, ACC_EMBD, Sen_EMBD, Spe_EMBD] = performanceEstimationRandomForests...
    (length_features, signal_features, signal_class, 1:size(signal_features,3));

fprintf('Accuracy using TFI features from EMBD is  : %0.4f\n',ACC_EMBD)
fprintf('\n\n')
fprintf('\n')
