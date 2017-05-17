function [predictedOutput, RealLabel, Performance, ACC, Sen, Spe] = performanceEstimationRandomForests(length_features, signal_features, signal_class, index)
%*************************************************
%% Authors:  Prof. B. Boashash, Project leader
%            Dr. Samir Ouelha, PostDoc of Prof. Boualem Boashash

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

% Description:
% This function estimates the classification performance using random
% forest classifier with 500 trees. The method used for the estimation is
% the leave-one-out-patient.
% predictedOutput represents the estimated output for each epoch.
% RealLabel represents the real outputs for each epoch.
% Performance is the performance for each patient.
% Accuracy is the total classification accuracy.
% Sen is the sensitivity and Spe is the specificity.


predictedOutput = [];
RealLabel = [];
Np = length(length_features);
Performance = zeros(1,Np);
for tt=1:Np
    mask=[];
    TEST=[];
    normal_feature_vector=[];
    artifact_feature_vector=[];
    seizure_feature_vector=[];
    k1=0;
    k2=0;
    
    %Data for learning
    for ii=1:Np
        if ii~=tt % one patient out
            
            for jj=1:length_features(ii)
                if  signal_class(ii,jj)==3
                    k1=k1+1;
                    z(1:length(index))=signal_features(ii,jj,index);
                    normal_feature_vector(k1,:)=z;
                elseif signal_class(ii,jj)==4
                    k1=k1+1;
                    z(1:length(index))=signal_features(ii,jj,index);
                    normal_feature_vector(k1,:)=z;
                else
                    k2=k2+1;
                    z(1:length(index))=signal_features(ii,jj,index);
                    seizure_feature_vector(k2,:)=z;
                end
            end
            
        end
    end
    
    Training=[seizure_feature_vector( :,:);normal_feature_vector(:,:);artifact_feature_vector(:,:)];
    Group     = [ones(k2,1); zeros(k1,1)];
    
    for jj=1:(length_features(tt))
        z(1:length(index))=signal_features(tt,jj,index);
        TEST(jj,:)=z;
        if signal_class(tt,jj)==3 %non seizure and artefact
            mask(jj) = 0;
        elseif signal_class(tt,jj)==4
            mask(jj) = 0;
        else
            mask(jj) =  1;
        end
    end
    
    
    %% Training
    rng(1);
    B = TreeBagger(500,Training,Group,'Method', 'classification');
    
    %% Estimation Performance
    predChar1 = B.predict(TEST);
    % Predictions is a cell though. We want it to be a number.
    predictedClass = str2double(predChar1); 
    predictedOutput = [predictedOutput;predictedClass];
    RealLabel = [RealLabel mask];
    Performance(tt)=sum(predictedClass(:)==mask(:))/length(mask);
end

%% Results
ACC = sum(Performance(:).*length_features(:))/sum(length_features);

TP=sum(predictedOutput(:).*RealLabel(:));% Y=1,output=1
FP=sum(predictedOutput(:).*(1-RealLabel(:)));% Y=0,output=1
TN=sum((1-predictedOutput(:)).*(1-RealLabel(:)));%Y=0,output=0
FN=sum((1-predictedOutput(:)).*(RealLabel(:)));%Y=1,output=0

Sen=TP/(TP+FN);
Spe=TN/(TN+FP);
