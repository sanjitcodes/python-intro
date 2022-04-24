% LAB04 U19EC008 
% Doppler Spread Fast Spreading

clc;
clear all;
close all;

Tau0 =0;
% f is in MHz and sampling time is in microseconds
f=1;
% Number of Multipaths
nop = 4;

% Rate at which the delay is changing
Tauj = [0.62 1.84 0.86 0.37];
% Attenuation of Individual Paths
BETA = [0.23 0.17 0.23 0.44];

% Actual shift in the frequency
fshift=[];
for j=1:1:nop
    fshift(j)=abs(-f+Tauj(j));
end

% Received Signal
rxsignal =[];
%  time varying transfer function at f
tvtf = [];

t = 0:(0.01):100;

% Transmitted Signal
txsignal = cos(2*pi*f*t);

for t =0:(0.01):100
    temp = 0;
    tf = 0;
    for p=1:1:nop
        temp = temp+ BETA(p)*cos(2*pi*fshift(p)*t);  %1.11
        tf = tf+BETA(p)*exp(-1i*2*pi*f*Tau0)*exp(-1i*2*pi*f*Tauj(p)*t); % 1.9
    end
    rxsignal = [rxsignal temp];
    tvtf = [tvtf tf];
end

% PLOTS

figure(1)
subplot(2,2,1)
plot(txsignal)
axis([1 1000 -2 2]);
title('U19EC008 Transmitted signal');
xlabel('time (microseconds)');
ylabel('Amplitude');
grid on;


subplot(2,2,2)
plot(real(rxsignal),'r')
axis([1 1000 -2 2]);
title('U19EC008 Received signal');
xlabel('time (microseconds)');
ylabel('Amplitude');
grid on;


subplot(2,2,3)
fre = (0:1:length(rxsignal)-1)/100;
plot(fre, abs(fft(txsignal)));
axis([0 2 0 6000]);
title('U19EC008 Spectrum of transmitted signal');
xlabel('Frequency (MHz)');
ylabel('Amplitude');
grid on;


subplot(2,2,4)
plot(fre, abs(fft(real(rxsignal))), 'r');
axis([0 2 0 2500]);
title('U19EC008 Corresponding Spectrum of Received signal');
xlabel('Frequency (MHz)');
ylabel('Amplitude');
grid on;


figure(2);
subplot(2,1,1)
plot(abs(tvtf));
axis([0 1000 0 2]);
title('U19EC008 Time varying transfer function (Magnitude)');
xlabel('time (microseconds)');
ylabel('Magnitude');
grid on;

subplot(2,1,2)
plot(phase(tvtf));
axis([0 1000 -25 0]);
title('U19EC008 Time varying transfer function (Phase)');
xlabel('time (microseconds)');
ylabel('Phase');
grid on;
