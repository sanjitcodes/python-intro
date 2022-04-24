% Lab-06 U19EC008
% Equalization, Input as Image (FINAL)

clc;
clear all;
close all;

id = imread('cameraman.tif');
figure('name','Transmitted Image U19EC008');
imshow(id);

ida = id(:);
ib = de2bi(ida);
ib = ib(:);

M = 4; 
x = mod(length(ib),log2(M));


Mod=2;
data_vector = reshape(ib, [numel(ib)/Mod Mod]);
msg = bi2de(data_vector);
hMod = comm.QPSKModulator('PhaseOffset',0);

% Modulate using QPSK.
modmsg = step(hMod,msg); 

SNR= 40;
modmsg = awgn(modmsg , SNR);
scatterplot(modmsg);
legend('Modulated signal U19EC008');

% Length of training sequence
trainlen = 200; 

Tauj = [0.986 0.845 0.237 0.123];
Beta = [-0.1 0 -0.03 0.31];

chan = rayleighchan(1,0,Tauj, Beta);
chanCoeff = chan.AvgPathGaindB + 1i*chan.PathDelays;

% Introduce channel distortion.
filtmsg = filter(chanCoeff,1, modmsg); 

% Equalize the received signal.

% Create an equalizer object.
eq1 = lineareq(8, lms(0.01)); 
release(hMod);

% Set signal constellation.
eq1.SigConst = step(hMod,(0:M-1)')'; 

% Equalize.
[symbolest,yd] = equalize(eq1,filtmsg,modmsg(1:trainlen)); 
scatterplot(filtmsg)
legend('Filtered signal U19EC008')
scatterplot(symbolest)
legend('Equilized signal U19EC008')

% Compute error rates with and without equalization.
hDemod = comm.QPSKDemodulator('PhaseOffset',0);
% Demodulate unequalized signal.
demodmsg_noeq = step(hDemod,filtmsg); 
% Demodulate detected signal from equalizer.
demodmsg = step(hDemod,yd); 
bidemodmsg = de2bi(demodmsg);

%% OUTPUT IMAGE WITHOUT EQUALIZATION
de = de2bi(demodmsg_noeq);
ber_without_eq = sum(mean(abs(uint8(de) - data_vector)))
%Double to uint8 converion
r = uint8(de);
r = r(:);

%Reshaping demodulated output
temp = r(1:length(r),:);
t = reshape(temp,[],8);

%Binary to Decimal conversion
k = bi2de(t);
%Reshaping into matrix of the size of image
p = reshape(k,256,256);
%Displaying output
figure('name','Received without Equalisation U19EC008');
imshow(p);

%% OUTPUT IMAGE WITH EQUALIZATION
de = de2bi(demodmsg);
ber_with_eq = sum(mean(abs(uint8(de) - data_vector)))

%Double to uint8 converion
r = uint8(de);
r = r(:);

%Reshaping demodulated output
temp = r(1:length(r),:);
t = reshape(temp,[],8);

%Binary to Decimal conversion
k = bi2de(t);
%Reshaping into matrix of the size of image
p = reshape(k,256,256);
%Displaying output
figure('name','Received with Equalisation U19EC008');
imshow(p);

disp('Bit Error Rates with Equalisation')
disp(ber_with_eq)

disp('Bit Error Rates without Equalisation')
disp(ber_without_eq)

% % ErrorRate calculator
% hErrorCalc = comm.ErrorRate; 
% ser_noEq = step(hErrorCalc, uint8(msg(trainlen+1:end)), uint8(demodmsg_noeq(trainlen+1:end)));
% reset(hErrorCalc)
% 
% ser_Eq = step(hErrorCalc, uint8(msg(trainlen+1:end)),uint8(demodmsg(trainlen+1:end)));
% disp('Symbol error rates with and without equalizer:')
% disp([ser_Eq(1) ser_noEq(1)])