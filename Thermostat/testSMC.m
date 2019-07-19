clc;
clear
%% parameters
delta = [0.9, 1.1];
epsilon = [0.05, 0.01];
significanceLevel = [0.01, 0.05];
number_of_simulation = 100;
%%

load_system('thermostatslx')

for i_e = 1 : length(epsilon)
    for i_s = 1 : length(significanceLevel)
        for i_d = 1 : length(delta)
            j = j +1;
            Pr(j).delta = delta(i_d);% Specification threshold
            Pr(j).epsilon = epsilon(i_e);% Probability threshold
            Pr(j).dSigLev = significanceLevel(i_s);% Desired significance level
            for i = 1 : number_of_simulation
                [N,A,exTimeAverage,totalTime]= HPSTL(epsilon(i_e),significanceLevel(i_s),delta(i_d));
                Pr(j).time(i) = totalTime;% Sampling + execution of the algorithm
                Pr(j).N(i) = N; % Sampling cost
                Pr(j).A(i) = A; % The obtained assertation by the propose algorithm
                Pr(j).exTimeAverage(i) = exTimeAverage; % Total sampling time for the given parameters
                Pr(j).algTime(i) = totalTime - exTimeAverage;
            end
        end
    end
end
