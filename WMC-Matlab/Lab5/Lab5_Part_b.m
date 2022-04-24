% Lab5 U19EC008 
% SNR vs BER 
clc;
clear all;
close all;

% Roll No. = U19EC008
msgbits = 1008;
% Generating Transmitted Signal (1008x1)
msg = randi([0,1],msgbits,1);
% Repeating message signal
msg_re = repmat(msg,[1,8]);

% Generating PN sequence
pn = generate(commsrc.pn('GenPoly', [3 2 0], ... 
                         'InitialStates',[0 0 1], ...
                         'CurrentStates', [0 0 1],...
                         'Mask', [0 0 1], ...
                         'NumBitsOut', 8));
pn = reshape(pn,[1,8]);
% Repeating PN sequence
pn = repmat(pn,msgbits,1);

% taking xor (Spreaded Data)
x = xor(msg_re,pn);
spread_i = x(:);
spread_i = uint8(spread_i);
BER=[];

% For SNR values between -10 to 10
for snr = -10:1:10
    y1 = qammod(spread_i,4);
    y1 = awgn(y1,snr);
 
    y2 = qamdemod(y1,4);
    y2 = reshape(y2,[msgbits,8]);
    despread_d = xor(y2,pn);
    msg_rx = round(mean(despread_d,2));
 
    ber = mean(abs(msg_rx - msg));
    BER = [BER ber];
end

% PLOT
snr = -10:1:10;
plot(snr,BER);
title('U19EC008 SNR v/s BER plot');
xlabel('Signal to Noise Ratio (dB)');
ylabel('Bit Error Rate');
grid on;