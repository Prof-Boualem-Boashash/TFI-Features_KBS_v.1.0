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

function m = crossValidate(ds, lb)
% Performs a K-fold cross validation on DataSet ds
% It returns the average confusion matrix measures over all
% training/test rounds (or folds)

conf = zeros(10, 4);
load ('crossValidate'); % Random sequence generating the results

% Generate Training/Test data sets, and classify
for i=1:10
    TrainId = find(ind ~= i);
    TestId = find(ind == i);
    TrainS = ds(TrainId, :);
    TestS = ds(TestId, :);
    Trainlb = lb(TrainId);
    Testlb = lb(TestId);
    Classlb = ClassifP(TrainS, TestS, Trainlb);
    % Compute confusion matrix measures
    lb2Num = str2num(cell2mat(Classlb));
    TP = (Testlb & (lb2Num == 1));
    FN = (Testlb & (lb2Num == 0));
    FP = (~Testlb & (lb2Num == 1));
    TN = (~Testlb & (lb2Num == 0));   
    conf(i, :) = [sum(TP), sum(FN), sum(FP), sum(TN)];
end

% Sum the confusion matrix measures and extract metrics
ConfM = sum(conf);
m.ACC = (ConfM(1) + ConfM(4)) / sum(ConfM); % Accuracy
m.SEN = ConfM(1)/(ConfM(1) + ConfM(2)); % Sensitivity
m.SPC = ConfM(4)/(ConfM(3) + ConfM(4)); % Specificity