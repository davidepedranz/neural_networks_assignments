% clf; close; close; 
clear;

% settings
N = 50;                      % N
alphas = 0.75:0.125:3;       % alpha
repetitions = 100;           % n_D
epochs = 2000;               % n_max

c_1 = 1;
c_2 = 0;
homogeneity = true;

% fix seed for the random number generator
rng(0);

tic
success_rates_wc = arrayfun(@(alpha) run_experiment(alpha, N, epochs, repetitions, c_1, homogeneity), alphas);
success_rates_woc = arrayfun(@(alpha) run_experiment(alpha, N, epochs, repetitions, c_2, homogeneity), alphas);
toc

figure;
hold on;
plot(alphas, success_rates_wc);
plot(alphas, success_rates_woc);
title('Success rate over alpha');
xlabel('Alpha = P / N');
ylabel('Success rate');
legend(sprintf("c = %0.2f", c_1) , sprintf("c = %0.2f", c_2));
hold off;
