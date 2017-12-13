%-------------------------------------------------------
% Learning a Rule in Version Space.
%-------------------------------------------------------

% clean the workspace
clf; close all;
clear;

% settings
repetitions = 50;           % n_D
n_max = 250;                % n_max
N = 200;                    % N
alphas = 0.2:0.2:5;         % alpha

% fix seed for the random number generator
rng(0);

% run all experiments (and cache the results)
cache = 'results/base.mat';
if (exist(cache, 'file'))
    fprintf('Loading results from cache "%s"...\n', cache);
    error_rates = importdata(cache);
else
    fprintf('Cache not found in "%s"... running the experiments\n', cache);
    
    tic
    len_alphas = length(alphas);
    error_rates = zeros(len_alphas);
    for alpha = (1 : len_alphas)
        error_rates(alpha) = run_experiment(alphas(alpha), N, n_max, repetitions);
    end
    toc
    
    save('results/base.mat', 'error_rates');
end

plot_base(alphas, error_rates);

function plot_base(alphas, error_rates)
    figure;
    box on;
    hold on;
    plot(alphas, error_rates);
    hold off;
    set(gca, 'FontSize', 12)
    title('Learning Curve for Minover algorithm', 'FontSize', 14);
    xlabel('Alpha = P / N');
    ylabel('Generalization Error');
    save_for_report('base');
end
