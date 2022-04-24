clc;
clear all;
close all;
a = imread('cameraman.tif');
X = de2bi(a);
X1 = X(:);

M = 8;

m = log2(M);
    zer_pad = rem(length(X1),m);
    
if(zer_pad~=0)
    X1 = [X1;zeros(m-zer_pad , 1)];
end

Input = reshape(X1 , length(X1)/m , m);
INPUT = bi2de(Input);
size(Input)

y = qammod(double(INPUT) , M ,0,'bin') ;
bitError = zeros(1,35);
for j = 1:1:35
    out = awgn(y,j);
    z = qamdemod(out,M,0,'bin');
    z1 = de2bi(z,m);
    bitError(j) = biterr(Input , z1);
    
    if(zer_pad ~= 0)
        z1 = z1(1:end-(m-zer_pad));
    end
    
    Z = reshape(uint8(z1) , size(X));
    I = bi2de(Z);
    OUTPUT = reshape(I , size(a));
        
end


disp(bitError);
figure(1);
plot(bitError);
  
figure('name','U19EC008');
subplot(1,2,1);
imshow(a);
title('Input Image U19EC008');
subplot(1,2,2);
imshow(OUTPUT);
title('Demodulated Image U19EC008');



