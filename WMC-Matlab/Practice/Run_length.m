clc;
clear all;
close all;
seq = input('Enter the sequence : ', 's');
n = length(seq);
mp = zeros(1, n);
prev = seq(1);
cur = 1;
for i=2:1:n
   if(prev ~= seq(i))
       mp(cur) = mp(cur) + 1;
       cur = 1;
       prev = seq(i);
   else
       cur = cur + 1;
       prev = seq(i);
   end  
end
mp(cur) = mp(cur) + 1;
mp

%% VERIFICATION
ok = 1;
run = (n+1)/2
for i=1:1:run
    x = run/(power(2, i))
    if(~(x > 0 && mp(i) == x))
        ok = 0;
    end
end
if(ok == 1)
    disp('Satisfies Run Length Property');
else
    disp('Does NOT satisfies Run Length Property');
end
        


