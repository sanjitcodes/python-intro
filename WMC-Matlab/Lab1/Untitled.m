% Lab01 - Part 1 M-QAM 
% U19EC008 

clc;  
clear all;
close all;

%% Input
image = imread('cameraman.tif');
figure('name', 'transmitted');
imshow(image);

%% Input Matrix to 1-D Vector
imageR = image(:);
%% Decimal matrix to Binary Matrix
binary = de2bi(imageR);
binaryd = double(binary);
%% Reshaping column matrix 
binaryC = binaryd(:);

%% Order of Modulation
M = 64;

%% Performing QAM Modulation
mod = qammod(binaryC, M);
%% Performing QAM Demodulation
demod = qamdemod(mod, M);

%% Reshaping
f = reshape(demod, [65536, 8]);

%% Double to uint8
g = uint8(f);

%% Binary to Decimal Conversion
h = bi2de(g);

%% Reshaping into pixel matrix
received = reshape(h, 256, 256);

%% Output
figure('name', 'received');
imshow(received);
scatterplot(mod);
scatterplot(demod);
