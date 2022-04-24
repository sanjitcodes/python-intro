clc;close all;clear;

data = randi([0, 1], 1000, 1);

[n, m] = size(data);

M = 2;

data_vector = reshape(data, [numel(data)/M, M]);

decimal_data = bi2de(data_vector);

transmitted = pskmod(decimal_data, 2^M);

scatterplot(transmitted);

SNR = 10;

noisy = awgn(transmitted, SNR);

scatterplot(noisy);


tauj = [0.62, 1.84, 0.86, 0.37]/10;
PdB = [0.23, 0.17, 0.23, 0.44]/10;

chan= rayleighchan(1,0,-20*log10(tauj),20*log10(PdB));

received= filter(chan,noisy);

alg= lms(0.01);

eqobj = lineareq(2^M, alg);

y = equalize(eqobj, received);
scatterplot(y);