% Function for Power Consumption Simulation Model 
function  [DELAY]  = Model_Simulation_Func(lamda,Tin, Ton, Tsc, Tlc, N, Ttail,Trrc)
rand('state',2);
loop=10000;
lamda=1./lamda;                                   %packet inter arrival time
sumttt=0;
activetime=0;
tailtime=0;
Ontime_S=0;                                       %On duration time in Short cycle
Ontime_L=0;                                       %On duration time in Long cycle
Sleeptime_S=0;                                    %Sleep time in Short cycle
Sleeptime_L=0;                                    %Sleep time in Long cycle

RRCtime=0;
offset=0;
counter=0;
for i=1:loop
    ttt(i)=exprnd(lamda);
    if i>1
        ttt(i)=ttt(i)-offset;
    end
    if ttt(i)<=Tin
        if ttt(i)>=0
            latency(i)=0;%arrive within the inactivity timer
            activetime=activetime+1/1000+ttt(i);
        else
            latency(i)=-ttt(i);
        end
    else
         if ttt(i)>Tin && ttt(i)<=Tin+Ttail %tail state arrival
            latency(i)=0;
            activetime=activetime+Tin;
            tailtime=tailtime+Ttail;
         else %DRX mode
             if ttt(i)-Tin-Ttail<N*Tsc %in the N short DRX cycles
                 if ttt(i)-Tin-Ttail<Tsc %first short DRX cycle
                     if ttt(i)-Tin-Ttail<(Tsc-Ton) %first sleep
                         Sleeptime_S=Sleeptime_S+(Tsc-Ton);
                         %Ontime_S=Ontime_S+Ton;
                         activetime=activetime+Tin;
                         tailtime=tailtime+Ttail;
                         RRCtime=RRCtime+Trrc;
                         latency(i)=Tsc-Ton-ttt(i)+Tin+Ttail+Trrc;
                     else
                         Sleeptime_S=Sleeptime_S+(Tsc-Ton); %first on duration
                         Ontime_S=Ontime_S+ttt(i)-Tin-Ttail-Tsc+Ton;
                         activetime=activetime+Tin;
                         tailtime=tailtime+Ttail;
                         RRCtime=RRCtime+Trrc;
                         latency(i)=Trrc;
                     end
                 else %other short DRX cycles
                     aa=mod(ttt(i)-Tin-Ttail,Tsc); %get modulus, so aa means what it is(0,Tsc) in this specific cycle
                     bb=floor((ttt(i)-Tin-Ttail)/Tsc); %floor(x) means rounds the elements of x to the nearest integers towards minus infinity, so bb means sequence of Tsc -1
                     Ontime_S=Ontime_S+bb*Ton;
                     Sleeptime_S=Sleeptime_S+bb*(Tsc-Ton);
                     if aa>Tsc-Ton %on duration
                         Ontime_S=Ontime_S+aa-Tsc+Ton;
                         Sleeptime_S=Sleeptime_S+Tsc-Ton;
                         activetime=activetime+Tin;
                         tailtime=tailtime+Ttail;
                         RRCtime=RRCtime+Trrc;
                         latency(i)=Trrc;
                     else %sleep
                         Sleeptime_S=Sleeptime_S+Tsc-Ton;
                         activetime=activetime+Tin;
                         tailtime=tailtime+Ttail;
                         RRCtime=RRCtime+Trrc;
                         latency(i)=Tsc-Ton-aa+Trrc;
                     end
                 end
             else %in the long DRX cycle
                 if ttt(i)-Tin-Ttail-N*Tsc<Tlc %in the first long DRX cycle
                     if ttt(i)-Tin-Ttail-N*Tsc<(Tlc-Ton) %first sleep 
                         Sleeptime_L=Sleeptime_L+(Tlc-Ton)+N*(Tsc-Ton);%
                         Ontime_L=Ontime_L+N*Ton; %·Ö¿ª¿¼ÂÇon duration time %
                         activetime=activetime+Tin;
                         tailtime=tailtime+Ttail;
                         RRCtime=RRCtime+Trrc;
                         latency(i)=Tlc-Ton-ttt(i)+Tin+Ttail+N*Tsc+Trrc; %need to consider the N short cycles
                     else
                         Sleeptime_L=Sleeptime_L+(Tlc-Ton)+N*(Tsc-Ton);%first on duration %
                         Ontime_L=Ontime_L+ttt(i)-Tin-Ttail-N*Tsc-Tlc+Ton+N*Ton; %
                         activetime=activetime+Tin;
                         tailtime=tailtime+Ttail;
                         RRCtime=RRCtime+Trrc;
                         latency(i)=Trrc;
                     end
                 else %other long DRX cycles
                     cc=mod(ttt(i)-Tin-Ttail-N*Tsc,Tlc);
                     dd=floor((ttt(i)-Tin-Ttail-N*Tsc)/Tlc);
                     Ontime_L=Ontime_L+dd*Ton+N*Ton;%
                     Sleeptime_L=Sleeptime_L+dd*(Tlc-Ton)+N*(Tsc-Ton); 
                     if cc>Tlc-Ton %on duration
                        Ontime_L=Ontime_L+cc-Tlc+Ton;
                        Sleeptime_L=Sleeptime_L+Tlc-Ton;
                        activetime=activetime+Tin;
                        tailtime=tailtime+Ttail;
                        RRCtime=RRCtime+Trrc;
                        latency(i)=Trrc;
                    else %sleep
                        Sleeptime_L=Sleeptime_L+Tlc-Ton; %here is the same with the on duration, because the device can't wake up during sleep
                        activetime=activetime+Tin;
                        tailtime=tailtime+Ttail;
                        RRCtime=RRCtime+Trrc;
                        latency(i)=Tlc-Ton-cc+Trrc;
                        counter=counter+1;
                     end
                 end
             end
         end
    end
    sumttt=sumttt+ttt(i)+latency(i);%the sum of ttt(i) and latency
    offset=latency(i);
end
disp('ED number of long sleep:');
disp(counter);
Ontime=Ontime_S+Ontime_L;
Sleeptime=Sleeptime_S+Sleeptime_L;
t=Ontime+Sleeptime+tailtime+activetime+RRCtime;%total time spent
t1=activetime+tailtime+RRCtime;
PS=Sleeptime/t;
disp('Power saving factor:');
disp(PS);
DELAY=mean(latency);
DELAY=DELAY*1000;
disp('delay:');
disp(DELAY);
PA=activetime/t1;
PA=PA*100;
disp('Pa');
disp(PA);

% %power calculation 1
% POWER=(Ontime_L/t)*1680.1+(Ontime_S/t)*1680.2+(activetime/t)*1726.43+(tailtime/t)*1060+(Sleeptime/t)*0+(RRCtime/t)*1210.7;% Power is in mW, according to the Reference[46]
% %NOT USED: Power=(Ontime/t)*100+(activetime/t)*300+(tailtime/t)*10+(Sleeptime/t)*0+(RRCtime/t)*10;
% %fprintf('Power');
% disp(POWER);
% %battery life calculation 1
% LIFETIME=32.4*1000/(POWER/1000); %in s
% LIFETIME=LIFETIME/3600; % in hour
% %Lifetime=Lifetime/(3600*24*365); %in year
% %fprintf('Lifetime');
% disp(LIFETIME);
% POWER1=(RRCtime/t)*1210.7;
% POWER2=(activetime/t)*1726.43;
% POWER3=(tailtime/t)*1060;
% POWER4=(Ontime_L/t)*1680.1+(Ontime_S/t)*1680.2;


                        
                         
                         
                         
                     
                         
                         
                          