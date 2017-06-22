function m = LOO(length_features_spec, signal_features_spec, signal_class_spec, index)
%% Authors: Prof. B. Boashash, Project leader
%           Dr. Samir Ouelha and Dr. Hichem Barki , PostDocs of Prof. Boualem Boashash


% The following reference should be cited whenever this script is used:
% B. Boashash, H. Barki, S. Ouelha, Performance evaluation of
% time-frequency image feature sets for improved classification and
% Analysis of non-stationary signals: Application to Newborn EEG Seizure
% Detection, Knowledge-Based Systems, 2017.

% This study was funded by grants from the ARC and QNRF NPRP 6-885-2-364.

% This code implements the leave-one-out (LOO) technique and it is used to
% reproduce the results (see Table 8) that allow to compare the results with the
% following study:

% B. Boashash, S. Ouelha,  Automatic signal abnormality detection 
% using time-frequency features and machine learning: A newborn EEG seizure
% case study. Knowledge-Based Systems, 106, 38-50, 2017


Np = length(length_features_spec);
k1 =0;
k3=0;




%Data for learning
for ii=1:Np
    for jj=1:length_features_spec(ii)
        if  or(signal_class_spec(ii,jj)==3,signal_class_spec(ii,jj)==4)
            k1=k1+1;
            z(1:length(index))=signal_features_spec(ii,jj,index);
            normal_feature_vector(k1,:)=z;
        else
            k3=k3+1;
            z(1:length(index))=signal_features_spec(ii,jj,index);
            seizure_feature_vector(k3,:)=z;
        end
    end
end

Training=[seizure_feature_vector( :,:);normal_feature_vector(:,:)];
Group     = [ones(k3,1); zeros(k1,1)];
ds = Training;
lb = Group;
c = cvpartition(7280,'KFold',10);
for i=1:10
    TrainId = training(c,i);
    TestId = not(TrainId);
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



