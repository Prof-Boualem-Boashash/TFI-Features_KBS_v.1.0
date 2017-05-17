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

function Hfeatures = HaralickFeatures(I)
% Computes a set of features proposed by Haralick for an image I
% Input: image I
% Output: the set of Haralick features

offsets = [0 8; -8 8; -8 0; -8 -8];
glcms = graycomatrix(I, 'Offset', offsets, ...
                        'NumLevels', 256, ...
                        'GrayLimits', [], ...
                        'Symmetric', true);
                    
L = size(glcms(:,:,1), 1);
% glcm
Nglcms = size(glcms, 3);

% Auxiliary variables
glcmSum  = zeros(Nglcms,1);
glcmMean = zeros(Nglcms,1);
glcmVar  = zeros(Nglcms,1);

% Marginal-probabilities
p_x = zeros(L,Nglcms);  
p_y = zeros(L,Nglcms);
p_xplusy = zeros((2*L - 1),Nglcms);
p_xminusy = zeros((L),Nglcms);
mu_x = zeros(Nglcms,1);
mu_y = zeros(Nglcms,1);
sigma_x = zeros(Nglcms,1);
sigma_y = zeros(Nglcms,1);

% Information Measures of Correlation auxiliary variables
hx   = zeros(Nglcms,1); % Entropy of p_x
hy   = zeros(Nglcms,1); % Entropy of p_y
hxy  = zeros(Nglcms,1); % Same as the entropy
hxy_1 = zeros(Nglcms,1);
hxy_2 = zeros(Nglcms,1);

% Maximal Correlation Coefficient auxiliary variables

% normalization
for i=1:Nglcms
    glcmSum(i) = sum(sum(glcms(:,:,i)));
    glcms(:,:,i) = glcms(:,:,i) / glcmSum(i);
    glcmMean(i) = mean2(glcms(:,:,i));
    glcmVar(i) = (std2(glcms(:,:,i)))^2;
end

% compute marginal probabilities and their mean/standard deviation
p_xplusy_range = 2:2*L;
p_xminusy_range = 0:(L - 1);
for k = 1:Nglcms
    for i = 1:L
        for j = 1:L
            p_x(i,k) = p_x(i,k) + glcms(i,j,k); 
            p_y(i,k) = p_y(i,k) + glcms(j,i,k);
            if (ismember((i + j),p_xplusy_range))
                p_xplusy((i+j)-1,k) = p_xplusy((i+j)-1,k) + glcms(i,j,k);
            end
            if (ismember(abs(i-j),p_xminusy_range))
                
                p_xminusy((abs(i-j))+1,k) = p_xminusy((abs(i-j))+1,k) ...
                + glcms(i,j,k);
            end
            mu_x(k)          = mu_x(k) + (i)*glcms(i,j,k);
            mu_y(k)          = mu_y(k) + (j)*glcms(i,j,k);
        end
    end
end

for k = 1:Nglcms
    for i = 1:L
        for j = 1:L
            sigma_x(k)  = sigma_x(k)  + (((i) - mu_x(k))^2) * glcms(i,j,k);
            sigma_y(k)  = sigma_y(k)  + (((j) - mu_y(k))^2) * glcms(i,j,k);
        end
    end
	sigma_x(k) = sigma_x(k) ^ 0.5; % stddev
	sigma_y(k) = sigma_y(k) ^ 0.5;
end

% Initializing features (see Haralick 1973 paper)
f1 = zeros(Nglcms,1);
f2 = zeros(Nglcms,1);
f3 = zeros(Nglcms,1);
f4 = zeros(Nglcms,1);
f5 = zeros(Nglcms,1);
f6 = zeros(Nglcms,1);
f7 = zeros(Nglcms,1);
f8 = zeros(Nglcms,1);
f9 = zeros(Nglcms,1);
f10 = zeros(Nglcms,1);
f11 = zeros(Nglcms,1);
f12 = zeros(Nglcms,1);
f13 = zeros(Nglcms,1);
f14 = zeros(Nglcms,1);
f15 = zeros(Nglcms,1);
f16 = zeros(Nglcms,1);
f17 = zeros(Nglcms,1);
f18 = zeros(Nglcms,1);

for k = 1:Nglcms
    for i = 1:L
        for j = 1:L
            
            f1(k) = f1(k) + (glcms(i,j,k).^2);
			
			f2(k) = f2(k) + (abs (i - j)) ^ 2 * glcms(i,j,k);
			
            f9(k) = f9(k) - ...
                (glcms(i,j,k) * log(glcms(i,j,k) + eps));
			
            f4(k) = f4(k) + ((i - glcmMean(k))^2) ...
                * glcms(i,j,k);
			
			f5(k) = f5(k) + (glcms(i, j, k) / ( 1 + (i - j)^2));

			
		end
	end
end

for k = 1:Nglcms
    for i = 1:L
        for j = 1:L
            
			f14(k) = f14(k) + (i * j * glcms(i,j,k));
			
			f15(k) = f15(k) + (abs(i - j) * glcms(i,j,k));
            
			f16(k) = f16(k) + ((i + j - mu_x(k) - mu_y(k)) ^ 3) *...
                glcms(i,j,k);
			
			f17(k) = f17(k) + (((i + j - mu_x(k) - mu_y(k)) ^ 4) *...
                glcms(i,j,k));
        end
    end
	
    f3(k) = (f14(k) - mu_x(k) * mu_y(k)) / (sigma_x(k) * sigma_y(k));
	
	f18(k) = max(max(glcms(:, :, k)));
end

% Computing Sum Average/Variance/Entropy
for k = 1:(Nglcms)
    for i = 1 : (2 * L - 1)
		
        f6(k) = f6(k) + (i + 1) * p_xplusy(i, k);
		
        f8(k) = f8(k) - (p_xplusy(i, k) * log(p_xplusy(i, k) + eps));
    end
	for i = 1 : (2 * L - 1)
		
		f7(k) = f7(k) + ((i + 1 - f8(k)) ^ 2) * p_xplusy(i,k);
    end
end

% Compute Difference Variance/Entropy 
for k = 1:Nglcms
	for i = 0:(L - 1)
        
		f10(k) = f10(k) + (i ^ 2) * p_xminusy(i + 1,k);
		
		f11(k) = f11(k) - (p_xminusy(i + 1,k) * log(p_xminusy(i + 1,k)...
            + eps));
    end
end

% Compute Information Measures of Correlation
for k = 1:Nglcms
    hxy(k) = f9(k);
    for i = 1:L
        for j = 1:L
            hxy_1(k) = hxy_1(k) - (glcms(i, j, k) * log(p_x(i, k) *...
                p_y(j, k) + eps));
            hxy_2(k) = hxy_2(k) - (p_x(i, k) * p_y(j, k) *...
                log(p_x(i, k) * p_y(j, k) + eps));
        end
        hx(k) = hx(k) - (p_x(i, k) * log(p_x(i, k) + eps));
        hy(k) = hy(k) - (p_y(i, k) * log(p_y(i, k) + eps));
    end

    f12(k) = (hxy(k) - hxy_1(k)) / (max([hx(k) hy(k)]));

	f13(k) = (1 - exp(-2 * (hxy_2(k) - hxy(k))))^0.5;
end

    features = [f1, f2, f3, f4, ...
    f5, f6, f7, f8, f9, ...
    f10, f11, f12, f13, ...
    f14, f15, f16, ...
    f17, f18 ...
    ];
               
means = mean(features);
ranges = max(features) - min(features);
Hfeatures = zeros(1, size(features, 2) * 2);

for i = 1:size(features, 2)
    Hfeatures(i * 2 - 1) = means(i);
    Hfeatures(i * 2) = ranges(i);
end



end

