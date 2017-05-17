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

function NI = normalizeFeat(I)
% Normalizes features matrix I for better classification
% Output: NI the normalized features matrix

NI = I;

minF = min(NI);
sclF = (max(NI) - minF);
for i = 1:size(NI,1)
    for j = 1:size(NI,2)
        if (sclF(j))
            NI(i,j) = (NI(i,j) - minF(j)) ./ sclF(j);
        else
            if (minF(j))
                NI(i,j) = 0.5 * NI(i,j) / minF(j);
            end
        end
    end
end


