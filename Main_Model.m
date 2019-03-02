%%%%%%% MATLAB Simulation Model for Semi-Markov Based Power Consumption
%%%%%%% Modeling for M2M Communication %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%  Master Thesis of Han Xie , Dec 2016 %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%  Code by Han Xie %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Initializing different parameters for DRX mechanism
Ttail_big=[0 5 10 15 20 25 30];                     %Ttail is in seconds
Ton_big=[5 10 20 40 60 80 100];                     %TON is in seconds
Ton=Ton_big/1000;
lamda_time=[10 30 60 180 360 1800 3600];            %Packet inter arrival time in second
lamda=1./lamda_time;                                %Packet inter arrival rate in second,
Ti_big=[20 100 200 500 750 1280 2560];
Ti=Ti_big/1000;
% Tlc_big=[160 320 640 1024 1280 2048 2560]; original by HanXie
Tlc_big=[160 320 640 1024 1280 2048 2560];
Tlc=Tlc_big/1000;
Tsc_big=[640 768 896 1024 1280 2048 2560];
Tsc=Tsc_big/1000;
N_set=[1 2 4 6 8 10 16];


% Calculation of power saving factor and wake up latency for given cases
for j=1:7 

%     Calculation of Wake Up Latency 
%     delay(j)=Model_Analytical_Func (lamda(j), 0.02, 0.04, 0.64, 1.28, 16, 11.576, 0.3, 0.3, 0.4,0.26);
%     DELAY(j)=Model_Simulation_Func(lamda(j),0.02, 0.04, 0.64, 1.28, 16, 11.576, 0.26);

%     Calculation of PSF against Arrival rate
      PS(j)=Model_Simulation_Func(lamda(j),0.02, 0.04, 0.64, 1.28, 16, 11.576,0.26);
      ps(j)=Model_Analytical_Func (lamda(j), 0.02, 0.04, 0.64, 1.28, 16, 11.576, 0.3, 0.3, 0.4,0.26);

%     Calculation of PSF against Inactivity Timer
%     pa(j)=Model_Analytical_Func (1/60, Ti(j), 0.04, 0.64, 1.28, 16, 11.576, 0.3, 0.3, 0.4,0.26);
%     PA(j)=Model_Simulation_Func(1/60,Ti(j), 0.04, 0.64, 1.28, 16, 11.576,0.26);

%     Calculation of Estimated Battery Lifetime against Inactivity Timer
%     lifetime(j)=Model_Analytical_Func (1/60, Ti(j), 0.04, 0.64, 1.28, 16, 11.576, 0.3, 0.3, 0.4,0.26);
%     LIFETIME(j)=Model_Simulation_Func(1/60, Ti(j), 0.04, 0.64, 1.28, 16, 11.576,0.26);
end
