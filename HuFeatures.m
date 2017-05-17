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


function [h] = HuFeatures(I)
% Computes Hu invariant moments for an image I (input)

h = zeros(1, 7);

e02 = momentAux1(I, 0, 2);
e03 = momentAux1(I, 0, 3);
e11 = momentAux1(I, 1, 1);
e12 = momentAux1(I, 1, 2);
e20 = momentAux1(I, 2, 0);
e21 = momentAux1(I, 2, 1);
e30 = momentAux1(I, 3, 0);


h(1) = e20 + e02;
h(2) = (e20 - e02) ^ 2 + 4 * (e11 ^ 2);
h(3) = (e30 - 3 * e12) ^ 2 + (3 * e21 - e03) ^ 2;
h(4) = (e30 + e12) ^ 2 + (e21 + e03) ^ 2;
h(5) = (e30 - 3 * e12) * (e30 + e12) * ((e30 + e12) ^ 2 - 3 *...
    (e21 + e03) ^ 2) + (3 * e21 - e03) * (e21 + e03) *...
    (3 * (e30 + e12) ^ 2 - (e21 + e03) ^ 2);
h(6) = (e20 - e02) * ((e30 + e12) ^ 2 - (e21 + e03) ^ 2) + 4 *...
    e11 * (e30 + e12) * (e21 + e03);
h(7) = (3 * e21 - e03) * (e30 + e12) * ((e30 + e12) ^ 2 - 3 *...
    (e21 + e03) ^ 2) - (e30 - 3 * e12) * (e21 + e03) * (3 *...
    (e30 + e12) ^ 2 - (e21 + e03) ^ 2);

end

function eta = momentAux1(I, p, q)
% Computes pq normalized moments
e = (0.5 * (p + q)) + 1.;
mu00 = sum(I(:));
eta = momentAux2(I, p, q) / (mu00 ^ e);
end

function mu = momentAux2(I, p, q)
% Computes pq central moments

mu = 0;
[x, y] = size(I);
if (~p && ~q) %mu00
    mu = sum(I(:));
else %mu10, mu01, etc.
    m00 = sum(I(:));
    m10 = Aux3(I, 1, 0);
    m01 = Aux3(I, 0, 1);
    alpha = m10 / m00;
    beta = m01 / m00;
    for x = 1:x
        for y = 1:y
            mu = mu + ((x - alpha) ^ p) * ((y - beta) ^ q) * I(x, y);
        end
    end
end
end

function m = Aux3(I, p, q)
% Computes the pq standard moments of image I
m = 0;
[x y] = size(I);
if (~p && ~q) %m00
    m = sum(I(:));
else %m10, m01, etc.
    for x = 1:x
        for y = 1:y
            m = m + double((x ^ p) * (y ^ q) * I(x, y));
        end
    end
end
end
