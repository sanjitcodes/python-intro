% Lab 5 - U19EC008
clc;
clear all;
close all;

% Generating Transmitted Signal (1000x1)
txsignal = randi([0 1], 1000, 1);
inmsg = txsignal;

figure;
plot(txsignal);
title('U19EC008 Transmitted Signal');

H = commsrc.pn('GenPoly', [3 2 0], ...
               'InitialStates', [0 0 1], ...
               'CurrentStates', [0 0 1], ...
               'Mask', [0 0 1], ...
               'NumBitsOut', 8);
           
% Generating PN sequence
pn = generate(H);  

figure;
plot(pn);
title('U19EC008 PN Signal');

% Repeating message signal
txsignal = repmat(txsignal, [1 8]);   
% Repeating PN sequence
pn = repmat(pn, [1000/8 8]);  

% taking xor (Spreaded Data)
x = xor(txsignal, pn);         
% converting into row
x = reshape(x, [8000 1]);   
x = uint8(x);

figure;
plot(x);
title('U19EC008 Spreaded Data');

BER = []
for snr = -10:1:10
    y1 = qammod(x, 4);
    y1 = awgn(y1, snr);

    y2 = qamdemod(y1, 4);
    y2 = reshape(y2, [1000 8]);

    x2 = xor(y2, pn);
    rxmsg = round(mean(x2, 2));

    ber = mean(abs(rxmsg - inmsg));
    BER = [BER ber]
end

figure;
snr = -10:1:10;
plot(snr, BER);
title('U19EC008 BER vs SNR');
ylabel('BER');
xlabel('SNR(dB)');


