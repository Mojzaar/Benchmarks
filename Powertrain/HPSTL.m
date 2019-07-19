function [N, A, exTimeAverage, totalTime] = HPSTL(b_u,dSingnificanceLevel,delta)
tic1 = tic;
% 
%Initial Values will be set here
I_1 = [0,b_u]; % interval between 0 to b_u
I_2 = [b_u,1]; % interval between b_u to 1
dT = [];
sigLevel = 1;
exTime = [];
cnt = 0;
%
while sigLevel > dSingnificanceLevel
    %
    cnt = cnt +1;
    tic
    for sampling = 1 : 2 % sampling from the model
        simOut = sim('AbstractFuelControl_M1_Aquino','SaveTime','on','TimeSaveName','tout');
        time(sampling) = simOut.tout(end);
    end
    exTime(1,cnt)= toc; %consumed time for sampling
    %
    TT = nchoosek(time,2); 
    dT = [dT;abs(TT(:,1) - TT(:,2))]; % calculation of time difference
    s = (dT < delta);% inteded specification
    
    Nk = length(s);
    T = sum(s);
    if T / Nk < b_u
        z = 1; % interval [0 b]
    else
        z = 2; % interval [b 1]
    end
    if T == 0
        Alpha = (1 - I_1(z))^Nk - (1 - I_2(z))^Nk;
    elseif T == Nk
        Alpha = I_2(z)^Nk-I_1(z)^Nk;
    else
        alpha_a = T;
        beta_a = Nk - T +1;
        alpha_b = T +1;
        beta_b = Nk - T;
        pd_a = makedist('Beta','a',alpha_a,'b',beta_a);
        pd_b = makedist('Beta','a',alpha_b,'b',beta_b);
        Alpha = cdf(pd_b,I_2(z)) - cdf(pd_a,I_1(z));
    end
    sigLevel = 1 - Alpha; %the calculated significance level
end

if (T / Nk) < b_u
    A = 1; %assertation is true
else
    A = 0; %assertation is false
end

N = Nk; %sampling cost
exTimeAverage = sum(exTime);% total sampling time
totalTime = toc(tic1);
