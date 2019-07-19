# Benchmarks
These are the benchmark models which have been used in the paper titled "Statistical Verification of Hyperproperties for Cyber-Physical Systems" at Emsoft 2019.

There are four different benchmark Simulink models, here. In all of the provided models, if one runs the *testSMC.m* file in Matlab, the corresponding model will be loaded and based on the defined parameters, the result will be gathered in a struct variable called *Pr*. The result contains the following fields:
- **time**, which indicates the consumption time to carry out the algorithm and sampling.
- **N**, in the powertrain and thermostat, indicates the sampling cost, while in the queueing network models, it stands for the average number of samples in each branch.
- **N_1** (merely in queuing network models), indicates the total number of branches.
- **A**, which indicates the considered assertation.
- **exTimeAverage**, which stands for total sampling time for the given parameters.
- **algTime**, which denotes the consumption time for the algorithm.
- **delta**, which denotes the specification threshold.
- **epsilon**, which stands for the probability threshold (in the queuing network models we have two prob. thresholds).
- **dSigLev**, which indicates the desired significance level.

The majority of the votes indicates the assertation status (*True* or *False*). Moreover, sampling cost in the powertrain and thermostat models are equal to **N** and in the queuing network models, it is calculated by `N×N_1`.
