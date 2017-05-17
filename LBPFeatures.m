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

function features = LBPFeatures(I)
% Computes LBP features for image I

features = zeros(1, 256);
for x = 9:(size(I,1) - 8)
    for y = 8+1:(size(I,2) - 8)
        g0 = double(I(x,y + 8) >= I(x,y));
        g1 = double(I(x-8,y+8) >= I(x,y));
        g2 = double(I(x-8,y) >= I(x,y));
        g3 = double(I(x-8,y-8) >= I(x,y));
        g4 = double(I(x,y-8) >= I(x,y));
        g5 = double(I(x+8,y-8) >= I(x,y));
        g6 = double(I(x+8,y) >= I(x,y));
        g7 = double(I(x+8,y+8) >= I(x,y));
        lbp = g0 + g1*2^1 + g2*2^2 +  g3*2^3 +  g4*2^4 + g5*2^5 + ...
             g6*2^6 + g7*2^7;
        ind = lbp + 1;
        features(ind) = features(ind) + 1;
    end
end


end



