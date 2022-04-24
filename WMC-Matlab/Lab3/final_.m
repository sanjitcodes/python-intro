% LAB 03 - U19EC008
clc;
clear all;
close all;

% Read Image
img=imread('cameraman.tif');

mxM = 6;
mxSNR = 40;
BERQAM = zeros(mxM,mxSNR/2);
BERPSK = zeros(mxM,mxSNR/2);
QAMstr = 'QAM (M = %d) U19EC008';
PSKstr = 'PSK (M = %d) U19EC008';
t = 1:2:mxSNR;

figure(1);
subplot(mxM/3,3,1);
imshow(img);
title('Original U19EC008');
figure(2);
subplot(mxM/3,3,1);
imshow(img);
title('Original U19EC008');

col = ['b','g','r','y','m','k']

for m  = 2:mxM
    Mod_Ord = 2^m;
    SymSize = log2(Mod_Ord);
    z = rem(length(img),SymSize);

    if z ~= 0;
        img = [img; zeros(SymSize - z, prod(size(img))/length (img))];
    end
    
    img_bin = de2bi(img);
    img_rsp = reshape(img_bin, 8*length(img_bin)/SymSize, SymSize);
    img_dec = bi2de(img_rsp);
    yQAM = qammod(img_dec, Mod_Ord);
    yPSK = pskmod(double(img_dec), Mod_Ord);

    for s = 1:2:mxSNR
        nQAM = awgn(yQAM,s);
        nPSK = awgn(yPSK,s);
        zQAM = qamdemod(nQAM, Mod_Ord);
        zPSK = pskdemod(nPSK, Mod_Ord);
        [a,b] = biterr(img_dec,zQAM);
        BERQAM(m,(s+1)/2) = 100*b;
        [c,d] = biterr(img_dec,zPSK);
        BERPSK(m,(s+1)/2) = 100*d;
    end

    QAM_dec = de2bi(zQAM);
    QAM_rsp = reshape(QAM_dec, size(img_bin));
    QAMM = bi2de(QAM_rsp);
    QAMM = uint8(reshape(QAMM,size(img)));

    PSK_dec = uint8(de2bi(zPSK));
    PSK_rsp = reshape(PSK_dec, size(img_bin));
    PSKK = bi2de(PSK_rsp);
    PSKK = uint8(reshape(PSKK,size(img)));

    scatterplot(nQAM);
    suptitle('U19EC008')
    scatterplot(nPSK);
    suptitle('U19EC008')

    figure(1);
    subplot(mxM/3,3,m);
    imshow(QAMM);
    title(sprintf(QAMstr,Mod_Ord));
    figure(2);
    subplot(mxM/3,3,m);
    imshow(PSKK);
    title(sprintf(PSKstr,Mod_Ord));

    figure(mxM+1);
    subplot(211);
    plot(t,BERQAM(m,:),'linewidth',2,'DisplayName',sprintf(QAMstr,Mod_Ord), 'color', col(m-1));
    title('BER vs SNR (QAM) U19EC008');
    xlabel('Signal to Noise Ratio');
    ylabel('Bit Error Rate(%)');
    legend;
    
    hold on;
    
    subplot(212);
    plot(t,BERPSK(m,:),'linewidth',2,'DisplayName',sprintf(PSKstr,Mod_Ord), 'color', col(m-1));
    title('BER vs SNR (PSK) U19EC008');
    xlabel('Signal to Noise Ratio');
    ylabel('Bit Error Rate(%)');
    legend;
    hold on;

end
