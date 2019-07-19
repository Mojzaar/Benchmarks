function [A,N_1,N_mean, exTimeAverage,totalTime] = QNT(delta,b_p2,b_p1,dSignificant_level)

tic_total = tic;
% 
%Initial Values will be set here
c = 0; % number of branches
exTime1 = 0; % execution time for the first sample
exTime2 = 0; % execution time for the second sample
sigLevel_main = 1; % The main significance level
u = 1;
N = []; % sampling cost
Pai1(1).T2 = [];
alpha_1 = dSignificant_level;
%
while sigLevel_main > dSignificant_level
    clear s_p2
    tic_1 = tic;
    set_param('simple/Constant','Value','1') % set the model to get the time value from the first processor
    simtime = sim('simple','SaveTime','on','TimeSaveName','tout');% sampling from the model
    exTime1 = exTime1 + toc(tic_1);
    if simtime.tout(end)< 100
        c = c +1;
        Pai1(c).T1 = simtime.tout(end); % time to get the maximum capacity of the first processor
        set_param('simple/Constant','Value','2')% set the model to get the time value from the second processor
        for k = 1 : c
            if k < c % using the previouse time differences for next computations
                Pai1(k).dT2_History = [Pai1(c).dT2_History [abs(Pai1(k).T1 - Pai1(k).T2)]];
            else
                Pai1(k).dT2_History = [];
            end
            dT_p2 = Pai1(k).dT2_History;
            alpha_p2 = 1.25*alpha_1;
            while alpha_p2 > alpha_1 % update significance level with Clopper and Pearson algorithm
                tic_2 = tic;
                simtime = sim('simple','SaveTime','on','TimeSaveName','tout');% sampling from the model
                exTime2 = exTime2 + toc(tic_2);
                dT_p2 = [dT_p2, [abs(Pai1(k).T1 - simtime.tout(end))]];
                Pai1(k).T2 = [Pai1(k).T2, simtime.tout(end)];
                s_p2 = (dT_p2 < delta); % The intended specification
                Nk_p2 = length(s_p2); 
                T_p2 = sum(s_p2);
                alpha_p2 = alphaCP(T_p2 , Nk_p2 , b_p2);
            end
            N(k) = Nk_p2; % number of samples in each branches
            alpha_i(k)=alpha_1;
            if (T_p2 / Nk_p2) < b_p2 % the associated assertations with branches
                A_i(k) = 1;
            else
                A_i(k) = 0;
            end
        end
        Nk_p1 = length(A_i);
        Delta = Nk_p1*u*alpha_i(c);% A small deviation in the assertation of branches
        A_pirim = [max(sum(A_i)-Delta,0) , min(sum(A_i)+Delta,Nk_p1)]; % should be between 0 and 1
        if sum(A_i)/Nk_p1 < b_p1% find a value to tolerate a deviation
            while ~(A_pirim(1)/Nk_p1 < b_p1 &&  A_pirim(2)/Nk_p1 < b_p1)
                Delta = 0.95*Delta;
                A_pirim = [max(sum(A_i)-Delta,0) , min(sum(A_i)+Delta,Nk_p1)];
            end
        else
            while ~(A_pirim(1)/Nk_p1 >= b_p1 &&  A_pirim(2)/Nk_p1 >= b_p1)
                Delta = 0.95*Delta;
                A_pirim = [max(sum(A_i)-Delta,0) , min(sum(A_i)+Delta,Nk_p1,1)];
            end
        end
        alpha_2 = 1 - binocdf(Delta,Nk_p1,alpha_i(c));% calculate the corresponding significance level with the obtained parameters
        T2 = max(A_pirim);
        T1 = min(A_pirim);
        
        if T2/Nk_p1 < b_p1 %update the main significance level
            sigLevel_main = alpha_2 + max(alphaCP(T2, Nk_p1 , b_p1),alphaCP(T1, Nk_p1 , b_p1));
        elseif T1/Nk_p1 > b_p1
            sigLevel_main = alpha_2 + alphaCP(T1, Nk_p1 , b_p1);
        end
        %
        if alpha_2 > sigLevel_main/2
            u = u + 1;
        else
            alpha_1 = alpha_1/2;
        end
    end
end

if T2/Nk_p1 < b_p1
    A = 1;
elseif T1/Nk_p1 > b_p1
    A = 0;
end
N_1 = Nk_p1 ;% number of branches
N_mean = mean(N);% average number of samples in each branches
totalTime = toc(tic_total);
exTimeAverage = exTime2 + exTime1;% average time consumption for sampling

