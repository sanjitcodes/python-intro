clc;
clear all;
close all;
for k=1:3
    ber = [];
    input_signal = randi([0,1],1000,1);
    %PN sequence
    if k==1
        H = commsrc.pn('Genpoly',[3 2 0],'InitialStates',[0 0 1],'CurrentStates',[0 0 1],'Mask',[0 0 1],'NumBitsOut',8);
        pn = generate(H);
    elseif k==2
        H = commsrc.pn('Genpoly',[4 3 0],'InitialStates',[0 0 0 1],'CurrentStates',[0 0 0 1],'Mask',[0 0 0 1],'NumBitsOut',8);
        pn = generate(H);
    else
        H = commsrc.pn('Genpoly',[5 3 0],'InitialStates',[0 0 0 0 1],'CurrentStates',[0 0 0 0 1],'Mask',[0 0 0 0 1],'NumBitsOut',8);
        pn = generate(H);
    end
    %expanding msg data
    msg_signal = repmat(input_signal,[1,8]);
    %pn = repmat(pn,[1000/8,8]);
    for i=1:size(msg_signal,1)
        for j=1:8
            spreaded_data(i,j) = xor(msg_signal(i,j),pn(j));
        end
    end
    spreaded_data = reshape(spreaded_data,8000,1);
    spreaded_data = reshape(uint8(spreaded_data),size(msg_signal));
    %qpsk mod nd demod
    for snr=-10:10
        M = 4;
        m = log2(M);
        X1 = spreaded_data(:); %reshape(x,[],1)%
        zer_pad = rem(length(X1),m);
        if(zer_pad~=0)
            X1 = [X1;zeros(m-zer_pad,1)];
        end
        INPUT = reshape(X1,length(X1)/m,m);
        INPUT = bi2de(INPUT);
        y = pskmod(double(INPUT),M);
        y = awgn(y,snr);
        z= pskdemod(y,M);
        z1 = de2bi(z,m);
        if(zer_pad~=0)
            z1 = z1(1:end-(m-zer_pad));
        end
        output = reshape(uint8(z1),size(spreaded_data));
        output = reshape(output,[1000,8]); %output
        for i=1:size(msg_signal,1)
            for j=1:8
                despread_data(i,j) = xor(output(i,j),pn(j));
            end
        end
        msg_rx = round(mean(despread_data,2));
        ber = [ber mean(abs(msg_rx-input_signal))];
        if k==1
            Ber1 = ber;
        elseif k==2
            Ber2 = ber;
        else
            Ber3 = ber;
        end
    end
end
snr = -10:10;
plot(snr,Ber1,snr,Ber2,snr,Ber3);
legend('Signal-1','Signal-2','Signal-3');
