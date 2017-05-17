%% Authors: Prof. B. Boashash, Project leader
%           Dr. Samir Ouelha Post-Doc of Prof. Boualem Boashash.

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

% This function implements the SFS algorithm for feature selection. It is
% used in the SFFS algorithm.

function [Xkp1,xkp1,Jbest] = SFS(Xk,D,kernel)


% D=size(dataTrain,2);
index = 1:D;
YDmk = setdiff(1:D,Xk);
Jbest = 0;
Dmk = length(YDmk);
for nF = 1:Dmk
    X = zeros(1,D);
    Xtmp = union(Xk,YDmk(nF));
    X(Xtmp)=1;
%     bestcv = J_cout(dataTrain(:,index(X==1)), LabelTrain, dataTest(:,index(X==1)), LabelTest, gridWidth);
    bestcv = J_cost(index(X==1),kernel);

    J_fctn_k = bestcv;
    
    
    if J_fctn_k > Jbest
        Jbest = J_fctn_k;
        nF_hat = YDmk(nF);
    end
end

xkp1 = nF_hat;
Xkp1 = union(Xk,xkp1);

