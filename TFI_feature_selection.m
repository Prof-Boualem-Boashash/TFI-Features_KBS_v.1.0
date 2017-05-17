%% Authors:  Prof. B. Boashash, Project leader
%            Dr. Samir Ouelha Post-Doc of Prof. Boualem Boashash.

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

%Feature Selection algorithm applied to features from EMBD and CKD to
%obtain the results presented in Table 7.

% X_best... represents the best subset of features which lead to the best
% accuracy performance and ACC... is the obtained accuracy.


[Xbest_EMBD, ACC_EMBD]=SFFS(51,3);

fprintf('Accuracy after feature selection using TFI features from EMBD is  : %0.4f\n',ACC_EMBD)
fprintf('The number of selected features using EMBD: %0.4f\n',length(Xbest_EMBD))
fprintf('\n')

[Xbest_CKD, ACC_CKD]=SFFS(51,4);

fprintf('Accuracy after feature selection using TFI features from CKD is  : %0.4f\n',ACC_CKD)
fprintf('The number of selected features using CKD: %0.4f\n',length(Xbest_CKD))
fprintf('\n')