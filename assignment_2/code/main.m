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
    error_rates = zeros(2, len_alphas);
    for alpha = (1 : len_alphas)
        error_rates(1, alpha) = run_experiment(@minover, alphas(alpha), N, n_max, repetitions);
        error_rates(2, alpha) = run_experiment(@rosenblatt, alphas(alpha), N, n_max, repetitions);
    end
    toc
    
    save('results/base.mat', 'error_rates');
end

mrk={'-o','-s','-*','-v','-+','-^'};
plot_base(alphas, error_rates);
plot_comparison(alphas, error_rates, mrk);

function plot_base(alphas, error_rates)
    figure;
    box on;
    hold on;
    plot(alphas, error_rates(1, :));
    hold off;
    set(gca, 'FontSize', 12)
    title('Learning Curve for Minover algorithm', 'FontSize', 14);
    xlabel('Alpha = P / N');
    ylabel('Generalization Error');
    save_for_report('base');
end

function plot_comparison(alphas, error_rates, mrk)
    figure;
    box on;
    hold on;
    for i = 1:size(error_rates, 1)
        set(gca, 'LineStyleOrder', mrk(mod(i, length(mrk))));
        plot(alphas, error_rates(i, :));
    end
    hold off;
    set(gca, 'FontSize', 12)
    title('Learning Curve for Minover algorithm', 'FontSize', 14);
    xlabel('Alpha = P / N');
    ylabel('Generalization Error');
    legend({'Minover', 'Rosenblatt'});
    save_for_report('comparison');
end
