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

% This function implements the SFFS algorithm for feature selection.

function [Xbest, J_hat_best]=SFFS(D,kernel)


J_hat_best = 0;
Xk = [];
Xbest = [];
k = 0;


% SFS(k=2)
while k<2
    [Xkp1,~,Jbest] = SFS(Xk,D,kernel);
    Xk = Xkp1;
    J_hat(k+1) = Jbest;
    k = k+1;
end


% SFFS (2<=k<=d<=D)
while k<D
    %Inclusion
[Xkp1,xkp1,JbestF] = SFS(Xk,D,kernel);

    %Test
[Xr,xr,JbestBr] = SBS(Xkp1,D,kernel);
    if xr==xkp1
        Xk = Xkp1;
        k = k+1;
        J_hat(k) = JbestF;
    else

        if JbestBr <= J_hat(k)
            Xk = Xkp1;
            k = k+1;
            J_hat(k) = JbestF;
        else

            if k==2
                Xk = Xr;
                J_hat(k) = JbestBr;
            else

                %Exclusion
                Xs = Xr;
                while k>2
                    [Xsm1,~,JbestBs] = SBS(Xs,D,kernel);
                    if JbestBs <= J_hat(k-1)
                        break;
                    else
                        Xs = Xsm1;
                        k = k-1;
                    end
                end
                %if k=2 or JbestBs <= J_hat(k-1)
                Xk = Xs;
                J_hat(k) = JbestBs;
            end
        end
    end

    if J_hat(k) > J_hat_best
        J_hat_best = J_hat(k)
        Xbest = Xk
    end

end
