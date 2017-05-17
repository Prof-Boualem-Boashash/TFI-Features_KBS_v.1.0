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

% This script computes the different TFDs and performs a ROC analysis for
% time-domain, frequency-domain, TF signal, and TF Hu features

%% Parameters
cache = 1; % TFD cache
L = 256; % # samples
nS = 200; % Number of cosidered segments
kernel = {'WVD' 'SPEC' 'EMBD' 'CKD' 'DGF' 'MDD'}; % TFD kernel

fprintf('\n1. AUC performance comparison of 1D and TF Hu features');
%% Load signals
load seizure sez_dat;
classS = sez_dat;
clear sez_dat;
load background
classN = back_data;
clear back_data;

current_folder = pwd;
% paths to the already computed TFDs
pathWVDN=[current_folder '\EEG\WVD\Normal\'];
pathWVDS=[current_folder '\EEG\WVD\Seizure\'];


pathSPECN=[current_folder '\EEG\SPEC\Normal\'];
pathSPECS=[current_folder '\EEG\SPEC\Seizure\'];

pathEMBDN=[current_folder '\EEG\EMBD\Normal\'];
pathEMBDS=[current_folder '\EEG\EMBD\Seizure\'];

pathCKDN=[current_folder '\EEG\CKD\Normal\'];
pathCKDS=[current_folder '\EEG\CKD\Seizure\'];

pathDGFN=[current_folder '\EEG\DGF\Normal\'];
pathDGFS=[current_folder '\EEG\DGF\Seizure\'];

pathMDDN=[current_folder '\EEG\MDD\Normal\'];
pathMDDS=[current_folder '\EEG\MDD\Seizure\'];

% Matrices storing the different features
All1DFeaturesS = [];
All1DFeaturesN = [];
% TF features
AllTFFeaturesN = [];
AllTFFeaturesS = [];
% Hu features
HuFeaturesN = [];
HuFeaturesS = [];
% Haralick features
HaralickFeaturesN = [];
HaralickFeaturesS = [];
% LBP features
LBPFeaturesN = [];
LBPFeaturesS = [];

for k_no=1:6 % For all TFDs
    features_vector_N=[]; % 1D features
    features_vector_S=[];
    cfeatures_vector_N=[]; % (t-f) domain features
    cfeatures_vector_S=[];
    Hu_features_vector_N = []; % Hu features
    Hu_features_vector_S = [];
    Haralick_features_vector_N = []; % Haralick features
    Haralick_features_vector_S = [];
    LBP_features_vector_N = []; % LBP features
    LBP_features_vector_S = [];
    
    for class=2:-1:1 % Seizure and non-seizure classes
        for j=1:nS
            if class==1
                signal=classN(j,:);
                loadSaveFileWVD = [pathWVDN num2str(j) '.mat'];
                loadSaveFileSPEC = [pathSPECN num2str(j) '.mat'];
                loadSaveFileEMBD = [pathEMBDN num2str(j) '.mat'];
                loadSaveFileCKD = [pathCKDN num2str(j) '.mat'];
                loadSaveFileDGF = [pathDGFN num2str(j) '.mat'];
                loadSaveFileMDD = [pathMDDN num2str(j) '.mat'];
            end
            if class==2
                signal=classS(j,:);
                loadSaveFileWVD = [pathWVDS num2str(j) '.mat'];
                loadSaveFileSPEC = [pathSPECS num2str(j) '.mat'];
                loadSaveFileEMBD = [pathEMBDS num2str(j) '.mat'];
                loadSaveFileCKD = [pathCKDS num2str(j) '.mat'];
                loadSaveFileDGF = [pathDGFS num2str(j) '.mat'];
                loadSaveFileMDD = [pathMDDS num2str(j) '.mat'];
            end
            
            signal=signal-mean(signal);
            signal=signal/norm(signal);
            
            % Time-frequency signal representation
            switch char(kernel(k_no))
                case 'WVD' %Wigner-Ville Distribution
                    if(cache)
                        S=load(loadSaveFileWVD, 'tfd');
                        tfd=S.tfd;
                    else
                        [~, tfd] = wvd1(signal,L);
                    end
                case 'SPEC' %Spectrogram
                    if(cache)
                        S=load(loadSaveFileSPEC, 'tfd');
                        tfd=S.tfd;
                    else
                        tfd = quadtfd(signal,255,1,'specx', ...
                            71,'bart',L);
                    end
                case 'EMBD'
                    if(cache)
                        S=load(loadSaveFileEMBD, 'tfd');
                        tfd=S.tfd;
                    else
                        tfd=embd(signal,0.045,0.045);
                    end
                case 'CKD'
                    if(cache)
                        S=load(loadSaveFileCKD, 'tfd');
                        tfd=S.tfd;
                    else
                        tfd=ckd(signal,1,0.04,0.04);
                    end
                case 'DGF' % The TFR are already computed to save time.
                    % This TFD can be found
                    %in the Supplementary materail of article 5.10.
                    S=load(loadSaveFileDGF, 'tfd');
                    tfd=S.tfd;
                case 'MDD'
                    if(cache)
                        S=load(loadSaveFileMDD, 'tfd');
                        tfd=S.tfd;
                    else
                        tfd=myMDD(signal,1,0.02);
                    end
            end
            
            %% Feature extraction
            if class==1
                [TFC,TF]=signal_features( signal, tfd );
                cfeatures_vector_N(j,:)=TFC;
                features_vector_N(j,:)=TF;
                mH = HuFeatures(tfd);
                Hu_features_vector_N(j,:) = mH;
                HF = HaralickFeatures(tfd);
                Haralick_features_vector_N(j,:) = HF;
                LBPF = LBPFeatures(tfd);
                LBP_features_vector_N(j,:) = LBPF;
            else
                [TFC, TF]=signal_features(signal,tfd);
                cfeatures_vector_S(j,:)=TFC;
                features_vector_S(j,:)=TF;
                mH = HuFeatures(tfd);
                Hu_features_vector_S(j,:) = mH;
                HF = HaralickFeatures(tfd);
                Haralick_features_vector_S(j,:) = HF;
                LBPF = LBPFeatures(tfd);
                LBP_features_vector_S(j,:) = LBPF;
            end
        end % next signal segment
    end % next class
    
    % Fill All features matrix
    All1DFeaturesN = features_vector_N;
    All1DFeaturesS = features_vector_S;
    AllTFFeaturesN(:,:,k_no)=cfeatures_vector_N;
    AllTFFeaturesS(:,:,k_no)=cfeatures_vector_S;
    HuFeaturesN(:,:,k_no)=Hu_features_vector_N;
    HuFeaturesS(:,:,k_no)=Hu_features_vector_S;
    HaralickFeaturesN(:,:,k_no)=Haralick_features_vector_N;
    HaralickFeaturesS(:,:,k_no)=Haralick_features_vector_S;
    LBPFeaturesN(:,:,k_no)=LBP_features_vector_N;
    LBPFeaturesS(:,:,k_no)=LBP_features_vector_S;
    mask=[ones(1,nS) zeros(1,nS)];
    
    % ROC analysis
    fprintf('\nKernel Number %d: %s\n', k_no, char(kernel(k_no)));
    display('Extended time-frequency features');
    auc=[];
    F=[cfeatures_vector_N;cfeatures_vector_S];
    mask=[ones(1,nS) zeros(1,nS)];
    for k = 1:size(F,2)
        [Sen,Spe] = roc_rates_function(F(:,k),mask,50);
        auc(k) = trapz(1-Spe,Sen);
        
        if auc(k)<0.5
            auc(k) = 1 - auc(k);
        else
        end
    end
    AllTFFeaturesAUC(k_no, :) = auc;
    fprintf('flux          : %0.2f\n',auc(8))
    fprintf('flatness      : %0.2f\n',auc(6))
    fprintf('renyi entropy : %0.2f\n',auc(7))
    fprintf('mean          : %0.2f\n',auc(1))
    fprintf('variance      : %0.2f\n',auc(2))
    fprintf('skewnes       : %0.2f\n',auc(4))
    fprintf('Kurtosis      : %0.2f\n',auc(5))
    fprintf('co-efficient  : %0.2f\n',auc(3))
    fprintf('\n\n')
    
    display('Hu invariant moment features');
    auc=[];
    F=[Hu_features_vector_N;Hu_features_vector_S];
    mask=[ones(1,nS) zeros(1,nS)];
    for k = 1:size(F,2)
        [Sen,Spe] = roc_rates_function(F(:,k),mask,50);
        auc(k) = trapz(1-Spe,Sen);
        
        if auc(k)<0.5
            auc(k) = 1 - auc(k);
        else
        end
    end
    HuFeaturesAUC(k_no, :) = auc;
    for i_auc = 1:size(auc,2)
        fprintf('Hu(%d)         : %0.2f\n', i_auc, auc(i_auc));
    end
end % next TFD



%% AUC analysis for original (time-domain and frequency-domain) features
display('original features');

auc=[];
F=[features_vector_N;features_vector_S];
mask=[ones(1,nS) zeros(1,nS)];
for k = 1:size(F,2)
    [Sen,Spe] = roc_rates_function(F(:,k),mask,50);
    auc(k) = trapz(1-Spe,Sen);
    
    if auc(k)<0.5
        auc(k) = 1 - auc(k);
    end
end
All1DFeaturesAUC = auc;
fprintf('flux          : %0.2f\n',auc(8))
fprintf('flatness      : %0.2f\n',auc(6))
fprintf('renyi entropy : %0.2f\n',auc(7))
fprintf('mean          : %0.2f\n',auc(1))
fprintf('variance      : %0.2f\n',auc(2))
fprintf('skewnes       : %0.2f\n',auc(4))
fprintf('Kurtosis      : %0.2f\n',auc(5))
fprintf('co-efficient  : %0.2f\n',auc(3))
fprintf('\n\n')

TF1DFeat = cat(1, All1DFeaturesN, All1DFeaturesS);
TF2DFeat  = cat(1, AllTFFeaturesN, AllTFFeaturesS);
HuFeat  = cat(1, HuFeaturesN, HuFeaturesS);
HaralickFeat  = cat(1, HaralickFeaturesN, HaralickFeaturesS);
LBPFeat  = cat(1, LBPFeaturesN, LBPFeaturesS);
ClassLabels = mask';

save ('Features.mat', 'TF1DFeat','TF2DFeat', 'HuFeat', 'HaralickFeat', ...
    'LBPFeat', 'ClassLabels');