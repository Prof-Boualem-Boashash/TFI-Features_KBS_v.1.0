%% Authors: Prof. B. Boashash, Project leader
%           Dr. Samir Ouelha and Dr. Hichem Barki Post-Docs of Prof. Boualem Boashash.

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

function [TFC, TF] = signal_features(signal, tfd)
% Input: 1D signal and corresponding 2D tfd
% Output: TFC (t, f) features vector
% Output: TF t-domain and f-domain features vector

tfd11=tfd;			% Temp variable
[N, M]=size(tfd);

% time-domain features
T1=mean(signal); % mean
T2=var(signal);  % variance
T3=sqrt(T2)/T1;  % coefficient of variance
T4=skewness(signal); % skewness
T5=kurtosis(signal); % kurtosis

% time-frequency extension of of time-domain features
TF_t1=mean(tfd(:)); % mean
TF_t2=var(tfd(:));  % variance
TF_t3=sqrt(TF_t2)/TF_t1;  % coefficient of variance
TF_t4=skewness(tfd(:)); % skewness
TF_t5=kurtosis(tfd(:)); % kurtosis
tfd=tfd/sum(sum(tfd)); % normalization
TF_t6=wentropy(tfd,'shannon'); % shannon entropy

%  frequency domain features
signal_f=fft(hilbert(signal));
signal_f=signal_f(1:end/2);
signal_f=abs(signal_f).^2;
signal_f(signal_f==0)=eps; % Values of the TFD replaced by epsilon

F1=prod(signal_f.^(1/(length(signal))))/mean(signal_f); %Spectral flatness

signal_f=fft(signal)/sum(abs(fft(signal)).^2);
F2=sum(abs(signal_f).*log2(abs(signal_f)));    % Spectral entropy

F3=sum(abs(fft((signal(1:3*end/4)))).^2- ...
abs(fft((signal(end/4+1:end)))).^2); % Spectral flux

% time-frequency extension of frequency-domain features
tfd_n=(tfd-min(min(tfd)))/(max(max(tfd))-min(min(tfd)));
tfd_n(tfd_n==0)=eps;
TF_f1 = (prod(prod(tfd_n.^(1/(N*M)))))/ ...
mean2(tfd_n); % time-frequency entropy flatness

tfd=tfd/sum(sum(abs(tfd))); % time-frequency entropy

TF_f2=log(sum(sum((tfd.^3))));  % Shannon entropy
LL=1;
QQ=1;
tfd=tfd11;
tfd=(tfd(1:end-LL,:)-tfd(LL+1:end,:));
tfd=tfd(:,1:end-QQ)-tfd(:,QQ+1:end);
TF_f3=sum(sum(abs(tfd)));   % Time-frequency flux

TF=[ T1 T2 T3 T4 T5  F1 F2 F3 ]; % All time and frequency features

TFC=[  TF_t1 TF_t2 TF_t3 TF_t4 TF_t5  TF_f1 TF_f2 TF_f3 ]; %(t, f) features

end
