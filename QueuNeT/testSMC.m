clear;
clc;
%% parameters
delta = [0.1, 5];
epsilon_1 = [0.1, 0.5];
epsilon_2 = [0.1, 0.5];
significanceLevel = 0.05;
number_of_simulation = 20;
%%

load_system('QueuingSys')

for i_e1 = 1 : length(epsilon_1)
    for i_e2 = 1 : length(epsilon_2)
        for i_s = 1 : length(significanceLevel)
            for i_d = 1 : length(delta)
                j=j+1;
                Pr(j).delta = delta(i_d); % Specification threshold
                Pr(j).epsilon_1 = epsilon_1(i_e1);% Probability threshold1
                Pr(j).epsilon_2 = epsilon_2(i_e2);% Probability threshold2
                Pr(j).dSigLev = significanceLevel(i_s);% Desired significance level
                for i = 1 : number_of_simulation
                    [A,N_1,N_mean, exTimeAverage,totalTime]= QNT(delta(i_d),epsilon_1(i_e1),epsilon_2(i_e2),significanceLevel(i_s));
                    Pr(j).time(i) = totalTime; % sampling + execution of the algorithm
                    Pr(j).N(i) = N_mean;% The average number of samples in each branches
                    Pr(j).N_1(i) = N_1; % Number of branches
                    Pr(j).A(i) = A; % The obtained assertation by the propose algorithm
                    Pr(j).exTimeAverage(i) = exTimeAverage; % Total sampling time for the given parameters
                    Pr(j).algTime(i) = totalTime - exTimeAverage;
                end
            end
        end
    end
end