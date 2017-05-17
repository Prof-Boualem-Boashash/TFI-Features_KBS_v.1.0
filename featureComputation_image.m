%% Authors: Prof. B. Boashash, Project leader
%           Dr. Samir Ouelha, PostDoc of Prof. Boualem Boashash

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

function ExtractedFeatures=featureComputation_image(tfd,sig_cur_epoch)
% Computes LBP features for image I

[TFC, TF] = signal_features_add(sig_cur_epoch, tfd);
[h] = HuFeatures(tfd);
Hfeatures = HaralickFeatures(tfd);
features = LBPFeatures(tfd);
ExtractedFeatures = [TFC h Hfeatures features];