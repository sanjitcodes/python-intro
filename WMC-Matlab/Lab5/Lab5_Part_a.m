% Lab5 U19EC008 
% Modulated, Demodulated
clc;
clear all;
close all;

% Generating Transmitted Signal (4x1)
msg = randi([0,1],4,1);

% Repeating message signal
msg_re = repmat(msg,[1,8]);

H = commsrc.pn('GenPoly', [3 2 0], ... 
               'InitialStates',[0 0 1], ...
               'CurrentStates', [0 0 1],...
               'Mask', [0 0 1], ...
               'NumBitsOut', 8);
           
% Generating PN sequence
pn = generate(H);  
rn = pn;
% Repeating PN sequence
pn = repmat(pn', [4, 1]);

% taking xor (Spreaded Data)
x = xor(msg_re,pn);
spread_i = x(:);
spread_i = uint8(spread_i);
 
snr = 4;
% Modulated Signal
y1 = qammod(spread_i,4);
y2 = awgn(y1,snr);
 
% Demodulated Signal
y3 = qamdemod(y2,4);
y3 = reshape(y3,[],8);

% Despreaded Signal
despread_d = xor(y3,pn);

% Received Signal
rxsignal = round(mean(despread_d,2));
BER = mean(abs(rxsignal - msg));

% PLOTS 
subplot(7,1,1);
plot(msg);
title('U19EC008 Message Signal');
 
subplot(7,1,2);
plot(rn);
title('U19EC008 Pseudo Random Noise');
 
subplot(7,1,3);
plot(spread_i);
title('U19EC008 Spreaded Data');
 
subplot(7,1,4);
plot(y1);
title('U19EC008 Modulated Signal');
 
subplot(7,1,5);
plot(bi2de(y3));
title('U19EC008 Demodulated SIgnal');
 
subplot(7,1,6);
plot(despread_d);
title('U19EC008 Despreaded Signal');
 
subplot(7,1,7);
plot(rxsignal);
title('U19EC008 Received Signal');