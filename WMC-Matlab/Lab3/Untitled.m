clc;
clear all;
close all;

order = [4,8,16,32,64,128];
len = length(order);

for i = 1:1:len
    M = order(i);
    a = imread('cameraman.tif');
    X = de2bi(a);
    X1 = X(:);

    m = log2(M);
    no_of_zeros = rem(length(X1),m);
    if(no_of_zeros~=0)
        X1 = [X1;zeros(m-no_of_zeros , 1)];
    end
    input = reshape(X1 , length(X1)/m , m);
    INPUT = bi2de(input);

    y = qammod(double(INPUT) , M ,0,'bin') ;
    bitError = zeros(1,50);
    for K = 1:1:50
        out = awgn(y,K);
        z = qamdemod(out,M,0,'bin');
        z1 = de2bi(z,m);
        bitError(K) = biterr(input , z1);
        if(no_of_zeros ~= 0)
            z1 = z1(1:end-(m-no_of_zeros));
        end
        Z = reshape(uint8(z1) , size(X));
        I = bi2de(Z);
        OUTPUT = reshape(I , size(a));
    end
    ans{i} = bitError;
end

figure(1);
color = ['b','g','r','c','m','k']
for i=1:1:len
   plot(ans{i}, color(i));
   hold on
end