clc;
clear all;
close all;

Tau0 = 0;
f = 1;
nop = 4;

Tauj = [0.62 1.84 0.86 0.37];
BETA = [0.23 0.17 0.23 0.44];

fshift = [];

for i=1:1:nop
   fshift(i) = abs(-f+Tauj(i)); 
end

rx = [];
tvtf = [];

t = 0:0.01:100;

tx = cos(2*pi*f*t);

for t = 0:0.01:100
    temp = 0;
    tf = 0;
    for p = 1:1:nop
        temp = temp + BETA(p)*cos(2*pi*fshift(p)*t);
        tf = tf + BETA(p)*exp(-1i*2*pi*f*Tau0)*exp(-1i*2*pi*f*Tauj(p)*t);
    end
    rx = [rx temp];
    tvtf = [tvtf tf];
end

figure(1);
subplot(2,2,1);
plot(tx);
axis([1 1000 -2 2]);
grid on;


subplot(2,2,2);
plot(real(rx), 'r');
axis([1 1000 -2 2]);
grid on;

fre = (0:1:length(rx)-1)/100;

subplot(2,2,3);
plot(fre, abs(fft(tx)));
axis([0 2 0 6000]);
grid on;

subplot(2,2,4);
plot(fre, abs(fft(real(rx))), 'r');
axis([0 2 0 2500]);
grid on;
