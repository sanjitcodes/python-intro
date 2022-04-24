% LAB4 - U19EC008
% DELAY SPREAD

clc;
clear all;
close all;

TAU0=0;
% Time Instant
t0=1;
% Number of Multipaths
nop=4;

% Attenuation of Individual Paths
BETA=[0.9575 0.9649 0.1576 0.9706];
% Rate at which the delay is changing
TAUJ=[0.9143 -0.0292 0.6006 -0.7162];

%  time varying transfer function at t0
tvtf_t0=[];

for f=0:(1/1000):1
    temp1=0;
    for p=1:1:nop
        temp1=temp1+BETA(p)*exp(-1i*2*pi*f*TAU0)*exp(-1i*2*pi*f*TAUJ(p)*t0);
    end
    tvtf_t0=[tvtf_t0 temp1];
end

figure;
plot((0:(1/1000):1)*1000,abs(tvtf_t0));
title('U19EC008 Time Varying Transfer Function computed at the time instant t0=1us')
xlim([0 1000])
xlabel('Frequency (KHz)');
ylabel('Amplitude');
grid on;

