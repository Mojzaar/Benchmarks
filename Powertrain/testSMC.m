clc;
clear
%% parameters
delta = [0.15, 0.20];
epsilon = [0.95, 0.99];
significanceLevel = [0.01, 0.05];
number_of_simulation = 100;
%%

load_system('AbstractFuelControl_M1_Aquino')

for i_e = 1 : length(epsilon)
    for i_s = 1 : length(significanceLevel)
        for i_d = 1 : length(delta)
            j = j +1;
            Pr(j).delta = delta(i_d);% specification threshold
            Pr(j).epsilon = epsilon(i_e);% probability threshold
            Pr(j).dSigLev = significanceLevel(i_s);%desired significance level
            for i = 1 : number_of_simulation
                [N,A,exTimeAverage,totalTime]= HPSTL(epsilon(i_e),significanceLevel(i_s),delta(i_d));
                Pr(j).time(i) = totalTime;% sampling + execution of the algorithm
                Pr(j).N(i) = N; % sampling cost
                Pr(j).A(i) = A; % the obtained assertation by the propose algorithm
                Pr(j).exTimeAverage(i) = exTimeAverage; % total sampling time for the given parameters
                Pr(j).algTime(i) = totalTime - exTimeAverage;
            end
        end
    end
end




