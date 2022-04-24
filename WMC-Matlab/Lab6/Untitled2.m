% Lab-06 U19EC008

clc;
clear all;
close all;

M = 4; 
% Generating message signal
msg = randi([0 1], 5000, 1);

[n, m] = size(msg);

Mod = 2;
data_vector = reshape(msg, [numel(msg)/Mod Mod]);
msg = bi2de(data_vector);
hMod = comm.QPSKModulator('PhaseOffset',0);

% Modulated signal using QPSK.
k = step(hMod, msg);
SNR = 40;
modmsg = awgn(k,SNR); 
scatterplot(modmsg);
legend('Modulated signal');

% Length of training sequence
trainlen = 200; 

Tauj = [0.986 0.845 0.237 0.123];
Beta = [-0.1 0 -0.03 0.31];

chan = rayleighchan(1, 0, Tauj, Beta);
chanCoeff = chan.AvgPathGaindB + 1i*chan.PathDelays;

% Introduce channel distortion
filtmsg = filter(chanCoeff, 1, modmsg); 

%%% Equalize the received signal

% Create an equalizer object
eq1 = lineareq(8, lms(0.01)); 
% Set signal constellation
eq1.SigConst = step(hMod,(0:M-1)')'; 
% Equalize.
[symbolest,yd] = equalize(eq1,filtmsg,modmsg(1:trainlen)); 

scatterplot(filtmsg)
legend('Filtered signal')
scatterplot(symbolest)
legend('Equilized signal')

% Compute error rates with and without equalization.
hDemod = comm.QPSKDemodulator('PhaseOffset',0);

% Demodulate unequalized signal
demodmsg_noeq = step(hDemod,filtmsg); 

% Demodulate detected signal from equalizer
demodmsg = step(hDemod,yd); 

% Calculating Bit Error Rates

de = de2bi(demodmsg_noeq);
ber_without_eq = sum(mean(abs((de) - data_vector)))

de = de2bi(demodmsg);
ber_with_eq = sum(mean(abs((de) - data_vector)))

disp('Bit Error Rates with Equalisation (U19EC008)')
disp(ber_with_eq)

disp('Bit Error Rates without Equalisation (U19EC008)')
disp(ber_without_eq)

% % ErrorRate calculator
% hErrorCalc = comm.ErrorRate; 
% ser_noEq = step(hErrorCalc, msg(trainlen+1:end), demodmsg_noeq(trainlen+1:end));
% reset(hErrorCalc)
% ser_Eq = step(hErrorCalc, msg(trainlen+1:end),demodmsg(trainlen+1:end));
% 
% disp('Symbol error rates with and without equalizer:')
% disp([ser_Eq(1) ser_noEq(1)]);



