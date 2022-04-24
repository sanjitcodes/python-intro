clc;
clear all;
close all;

f = 1;
nop = 2;
t = 0:0.01:1;
tx = cos(2*pi*f*t);

rx = [];
z = 1;
for t=0:0.01:1
    temp = 0;
    for p=1:1:nop
        beta(p) = rand;
        delay(p) = rand*t;
        temp = temp + beta(p)*cos(2*pi*f*(t - delay(p)));
    end
    BETA{z} = beta;
    DELAY{z} = delay;
    beta = 0;
    delay = 0;
    rx = [rx temp];
    z = z+1;
end

figure(1);
subplot(4, 1, 1);
plot(tx);

subplot(4, 1, 2);
plot(real(rx));

subplot(4, 1, 3);
plot(abs(fft(tx)));

subplot(4, 1, 4);
plot(abs(fft(real(rx))));

