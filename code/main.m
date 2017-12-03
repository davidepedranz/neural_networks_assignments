%-------------------------------------------------------
% Rosenblatt Perceptron Algorithm.
% Implement and simulate a base Rosennblatt Perceptron.
% This include the base assignment and bonus 1.
%-------------------------------------------------------

% clean the workspace
clf; close; clear;

% settings
ns = [20, 50, 100, 500, 1000];                              % N
alphas = [0.75:0.25:1.5, 1.55:0.05:2.2, 2.25:0.25:3];       % alpha
repetitions = 100;                                          % n_D
epochs = 200;                                               % n_max

% fix seed for the random number generator
rng(0);

% run all experiments (and cache the results)
cache = 'results/base.mat';
if (exist(cache, 'file'))
    fprintf('Loading results from cache "%s"...\n', cache);
    success_rates = importdata(cache);
else
    fprintf('Cache not found in "%s"... running the experiments\n', cache);
    
    tic
    len_alphas = length(alphas);
    len_ns = length(ns);
    success_rates = zeros(len_alphas, len_ns);
    for i = (1 : len_alphas)
        for j = (1 : len_ns)
            success_rates(i, j) = run_experiment(alphas(i), ns(j), epochs, repetitions);
        end
    end
    toc

    save('results/base.mat', 'success_rates');
end

% plot
p = plot(alphas, success_rates);
title('Storage Success Rate');
xlabel('Alpha = P / N');
ylabel('Success Rate');
legend(cellstr(num2str(ns', 'N=%-d')));
saveas(p, 'results/base', 'png');

% run an experiment for a fixes alpha and N multiple times
function [success_rate, results] = run_experiment(alpha, N, epochs, repetitions)
    fprintf('Running experiment for alpha=%.2f, N=%3d ... ', alpha, N);
    results = zeros(repetitions, 1);
    parfor i = 1:repetitions
        P = ceil(alpha * N);
        [X, y] = generate_dataset(P, N);
        w = train_perceptron(X, y, epochs);
        success = all(iff(X * w <= 0, -1, 1) == y);
        results(i) = success;
    end
    success_rate = sum(results) / length(results);
    fprintf('success_rate = %f \n', success_rate);
end
