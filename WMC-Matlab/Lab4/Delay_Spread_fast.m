% NOT FINAL
clc;
clear all;
close all;

TAU0=0;
% Time Instant
t0=1;
% Number of Multipaths
nop=4;

BETA=[0.9143 -0.0292 0.6006 -0.7162];
TAUJ=[0.9575 0.9649 0.1576 0.9706];

% BETA=rand(1,nop);
% TAUJ=(rand(1,nop)*2-1);

tv_tf_comp_at_t0=[];
rxsignal = [];

for f=0:(0.001):1
    temp=0;
    temp1=0;
    for p=1:1:nop
        temp1=temp1+BETA(p)*exp(-1i*2*pi*f*TAU0)*exp(-1i*2*pi*f*TAUJ(p)*t0);
    end
    tv_tf_comp_at_t0=[tv_tf_comp_at_t0 temp1];
end


figure;
% plot((0:(1/1000):0.999)*1000,abs(tv_tf_comp_at_t0));
plot(abs(tv_tf_comp_at_t0));
title('U19EC008 Time Varying Transfer Function computed at the time instant t0 = 1us')
xlim([0 1000])

