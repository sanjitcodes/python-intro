f=1;
nop=2; % initial value of nop = 2
rxsignal=[];
t=0:1/100:1; % choosing sampling freg=100Hz
txsignal=cos(2*pi*f*t); % transmitted signal
z=1;
for t=0:1/100:1
    temp=0;
    for p=1:1:nop
        beta(p)=rand; % for every delayed singal there will be 10
        delay(p)=rand*t; % delay of each multipth component generated
        temp=temp+beta(p)*exp(1i*2*pi*f*(t-delay(p)));
    end
    BETACOL{z}=beta;
    DELAYCOL{z}=delay;
    beta=0;
    delay=0;
    rxsignal=[rxsignal temp];
    z=z+1;
end
save CONSTANTS BETACOL DELAYCOL
figure(1)
subplot(4,1,1)
plot(txsignal)
title('transmitted signal U19EC077');
subplot(4,1,2)
plot(real(rxsignal))
title('received signal after multipath U19EC077');
subplot(4,1,3)
plot(abs(fft(txsignal)))
title('spectrum of the transmitted signal U19EC077');
subplot(4,1,4)
plot(abs(fft(real(rxsignal))))
title('spectrum of the received signal after multipath U19EC077');
hold
load CONSTANTS
fs=100;
u=1;
for f=0:fs/101:(50*fs)/101
    rxsignal=[];
    temp=0;
    z=1;
    for t=0:1/100:1
        temp=0;
        for p=1:1:nop
            temp=temp+BETACOL{z}(p)*exp(1i*2*pi*f*(t-DELAYCOL{z}(p)));
        end
        rxsignal=[rxsignal temp];
        z=z+1;
    end
    % The impulse response of the time-varying channel is computed as followed
    t=0:1/100:1;
    timevaryingTF_at_freq_f{u}=rxsignal.*exp(-1i*2*pi*f*t);
    u=u+1;
end
TEMP=cell2mat(timevaryingTF_at_freq_f');
for i=1:1:101
    u=TEMP(:,i);
    u1=[u;transpose(u(length(u):-1:2)')];
    timevaringIR_at_time_t{i} = ifft(u1);
end
TFMATRIX=abs(cell2mat(timevaryingTF_at_freq_f'));
IRMATRIX=cell2mat(timevaringIR_at_time_t);
s=[2:2:8];
for i=1:1:4
    figure(2)
    subplot (2,2,i)
    plot(IRMATRIX(1:1:101,s(i)))
    title(strcat('t=',num2str((s(i)-1)/100)))
end