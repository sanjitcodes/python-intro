% LAB 02 U19EC008
clc;
clear all;
close all;

% Transmitted Signal Frequency
f = 1;

% Number of paths
nop = 2;

% Received Signal
rxsignal = [];
t = 0:0.01:1;

% Transmitted Signal
txsignal = cos(2*pi*f*t);

z = 1;

for t = 0:0.01:1
    temp = 0;
    for p = 1:1:nop
        beta(p) = rand;
        delay(p) = rand*t;
        temp = temp + beta(p)*exp(1i*2*pi*f*(t-delay(p)));
    end
    BETA{z} = beta;
    DELAY{z} = delay;
    beta = 0;
    delay = 0;
    rxsignal = [rxsignal temp];
    z = z+1;
end
save CONSTANTS BETA DELAY

% OUTPUTS
figure(1);
subplot(4, 1, 1);
plot(txsignal);
title('U19EC008 Transmitted Signal');
ylabel('Amplitude');
xlabel('Time');

subplot(4, 1, 2);
plot(real(rxsignal));
title('U19EC008 Received Signal After Multipath');
ylabel('Amplitude');
xlabel('Time');

subplot(4, 1, 3);
plot(abs(fft(txsignal)));
title('U19EC008 Spectrum of Transmitted Signal');
ylabel('Amplitude');
xlabel('Frequency');

subplot(4, 1, 4);
plot(abs(fft(real(rxsignal))));
title('U19EC008 Spectrum of Receieved Signal After Multipath');
ylabel('Amplitude');
xlabel('Frequency');

hold 

% TRANSFER FUNCTION PART
load CONSTANTS
fs = 100;
u = 1;
for f=0:fs/101:(50*fs)/101
    rxsignal=[];
    temp = 0;
    z = 1;
    for t = 0:0.01:1
        temp = 0;
        for p=1:1:nop
            temp = temp + BETA{z}(p)*exp(1i*2*pi*f*(t-DELAY{z}(p)));
        end
        rxsignal = [rxsignal temp];
        z = z+1;
    end
    t = 0:0.01:1;
    tv_TF_f{u} = rxsignal.*exp(-1i*2*pi*f*t);
    u = u + 1;
end 
    
TEMP = cell2mat(tv_TF_f');
for i=1:1:101
    u = TEMP(:,i);
    u1=[u;transpose(u(length(u):-1:2)')];
    tv_TF_t{i} = ifft(u1);
end

TF_mat = abs(cell2mat(tv_TF_f'));
IR_mat = cell2mat(tv_TF_t);

s = [2:2:8];

for i=1:1:4
    figure(2);
    subplot (2,2,i);
    plot(IR_mat(1:1:101,s(i)));
    title(strcat('(U19EC008) t=',num2str((s(i)-1)/100)));
    xlabel('Samples');
    ylabel('Amplitude');
    figure(3);
    subplot(2,2,i);
    plot(TF_mat(:,s(i)));
    title(strcat('(U19EC008) t=',num2str((s(i)-1)/100)));
    xlabel('Samples');
    ylabel('Amplitude');
end
       