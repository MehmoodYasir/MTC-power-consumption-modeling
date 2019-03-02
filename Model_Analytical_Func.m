% Function for Computing Analytical Results

function [delay] = Model_Analytical_Func (lamda, Ti, Ton, Tsc, Tlc, N, Ttail, theta2, theta3, theta4,Trc)
HTwhole_s=0;
HTwhole_on=0;
K=exp(-lamda*Ttail)+exp(lamda*Ti)+1+2*(exp(-lamda*Ttail))*((1-exp(-lamda*N*Tsc))./(1-exp(-lamda*Tsc)))+2*((exp(-lamda*Ttail))*(exp(-lamda*(N-1)*Tsc))*(exp(-lamda*Tsc)))./(1-exp(-lamda*Tlc));

%stationary probability
p=zeros(1,(2*N+7));
p(1)=(exp(-lamda*Ttail))./K;
p(2)=(exp(lamda*Ti)*theta2)./K;
p(3)=(exp(lamda*Ti)*theta3)./K;
p(4)=(exp(lamda*Ti)*theta4)./K;
p(5)=1./K;
p(6)=(exp(-lamda*Ttail))./K;
p(7)=p(6);

for i=1:(N-1)
p(2*i+6)=((exp(-lamda*Ttail)).*(exp(-lamda*i*Tsc)))./K;
p(2*i+7)=p(2*i+6);
end
p(2*N+6)=((exp(-lamda*Ttail)).*(exp(-lamda*N*Tsc)))./((1-exp(-lamda*Tlc))*K);
p(2*N+7)=p(2*N+6);%represents pL+1

%holding time*probability=actual time spent in each state

HT1=Trc*p(1);
HT2=((exp(lamda*Ti)-1)./(1-exp(-lamda))).*(p(2)+p(3)+p(4));%For all three active states
HT5=Ttail*p(5);
HT6=(Tsc-Ton)*p(6);
HT7=((exp(-lamda*(Tsc-Ton))-exp(-lamda*Tsc))./(1-exp(-lamda))).*p(7);%不考虑sleep里来了packet要在on duration里传输的时间
%HT7=(1-exp(-lamda*(Tsc-Ton))+((exp(-lamda*(Tsc-Ton))-exp(-lamda*Tsc))./(1-exp(-lamda)))).*p(7);

for i=2:N
    HT(2*i+4)=(Tsc-Ton)*p(2*i+4);
    HT(2*i+5)=((exp(-lamda*(Tsc-Ton))-exp(-lamda*Tsc))./(1-exp(-lamda))).*p(2*i+5);
    %HT(2*i+5)=(1-exp(-lamda*(Tsc-Ton))+((exp(-lamda*(Tsc-Ton))-exp(-lamda*Tsc))./(1-exp(-lamda)))).*p(2*i+5);
    HTwhole_s=HTwhole_s+HT(2*i+4);%whole sleep time in N short cycles
    HTwhole_on=HTwhole_on+HT(2*i+5);%whole on duration time in N short cycles
end
HTL=(Tlc-Ton)*p(2*N+6);
HTm=((exp(-lamda*(Tlc-Ton))-exp(-lamda*Tlc))./(1-exp(-lamda))).*p(2*N+7);
%HTm=(1-exp(-lamda*(Tlc-Ton))+((exp(-lamda*(Tlc-Ton))-exp(-lamda*Tlc))./(1-exp(-lamda)))).*p(2*N+7);%represents HTL+1
HT=HT1+HT2+HT5+HT6+HT7+HTwhole_s+HTwhole_on+HTL+HTm;

%
P1=HT1./HT;
P2=HT2*theta2./HT;
P3=HT2*theta3./HT;
P4=HT2*theta4./HT;
P5=HT5./HT;
P_ss=(HTwhole_s+HT6)./HT;%short sleep
P_son=(HTwhole_on+HT7)./HT;
P_ls=HTL./HT;%long sleep
P_lon=HTm./HT;
sum=P1+P2+P3+P4+P5+P_ss+P_son+P_ls+P_lon;%sum=1
fprintf('P1 %f\n P2 %f\n P3 %f\n P4 %f\n P5 %f\n P_ss %f\n P_son %f\n P_ls %f\n P_lon %f\n', P1,P2,P3,P4,P5,P_ss,P_son,P_ls,P_lon);
ps=(P_ss+P_ls)/sum;%Power Saving Factor
disp(ps);
delay=((P_son+P_lon)/sum)*Trc+(P_ss/sum)*(((Tsc-Ton)/2)+Trc)+(P_ls/sum)*(((Tlc-Ton)/2)+Trc)+(P1/sum)*(Trc/2);
delay=delay*1000;
disp(delay);
disp(sum);
pa=(exp(lamda*Ti)-1)./(exp(lamda*Ti)-1+Ttail*((1-exp(-lamda))*exp(-lamda*Ti))+Trc*exp(-lamda*Ttail)*((1-exp(-lamda))*exp(-lamda*Ti)));
pa=pa*100;
disp(pa);
power=P1*1210.7+(P2+P3+P4)*1726.43+P5*1060+(P_ss+P_ls)*0+P_son*1680.2+P_lon*1680.1;% Power in mW
disp(power);
lifetime=32.4*1000/(power/1000); %in s
lifetime=lifetime/3600; % in hour
disp(lifetime);
power1=P1*1210.7;
power2=(P2+P3+P4)*1726.43;
power3=P5*1060;
power4=P_son*1680.2+P_lon*1680.1;
end











