clc;
clear all;
close all;

txmsg = randi([0 1], 1000, 1);        % Generating message signal
inmsg = txmsg;

H = commsrc.pn('GenPoly', [3 2 0], ...
                'InitialStates', [0 0 1], ...
                     'CurrentStates', [0 0 1], ...
                     'Mask', [0 0 1], ...
                     'NumBitsOut', 8);
pn = generate(H);       % PN Sequence generation
txmsg = repmat(txmsg, [1 8]);        % Repeating message signal
pn = repmat(pn, [1000/8 8]);       % Repeating pn sequence

x = xor(txmsg, pn);       % taking xor
x = reshape(x, [8000 1]);   % converting into row
x = uint8(x);

BER = []

mod = qammod(x, 4);
dmod = qamdemod(mod, 4);

for snr = -10:1:10
    % y1 = qammod(x, 4);
    y1 = awgn(mod, snr);

    % y2 = qamdemod(y1, 4);
    y2 = reshape(dmod, [1000 8]);

    x2 = xor(y2, pn);
    rxmsg = round(mean(x2, 2));

    ber = mean(abs(rxmsg - inmsg));
    BER = [BER ber]
end

% figure;
% plot(mod);

% figure;
% plot(dmod);

figure;
snr = -10:1:10;
plot(snr, BER);
title('BER vs SNR');
ylabel('BER');
xlabel('SNR(dB)');
