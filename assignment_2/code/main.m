%-------------------------------------------------------
% Learning a Rule in Version Space.
%-------------------------------------------------------

% clean the workspace
clf; close all;
clear;

% settings
repetitions = 50;                       % n_D
n_max = 250;                            % n_max
N = 200;                                % N
alphas = 0.25:0.25:5;                   % alpha
lambdas = 0:0.1:0.5;                    % lambda
algorithms = {@minover, @rosenblatt};   % different training algorithms

% fix seed for the random number generator
rng(0);

% run all experiments (and cache the results)
cache = 'results/errors.mat';
if (exist(cache, 'file'))
    fprintf('Loading results from cache "%s"...\n', cache);
    error_rates = importdata(cache);
else
    fprintf('Cache not found in "%s"... running the experiments\n', cache);
    
    len_alphas = length(alphas);
    len_lambdas = length(lambdas);
    len_algorithms = length(algorithms);
    
    error_rates = zeros(len_lambdas, len_alphas, 2);
    updates = zeros(len_lambdas, len_alphas, 2);
    
    tic
    for alpha = (1 : len_alphas)
        for lambda = (1 : len_lambdas)
            for algorithm = (1 : len_algorithms)
                [error_rates(lambda, alpha, algorithm), updates(lambda, alpha, algorithm)] = ...
                    run_experiment(algorithms(algorithm), alphas(alpha), N, n_max, repetitions, lambdas(lambda));
            end
        end
    end
    toc
    
    save('results/errors.mat', 'error_rates');
    save('results/updates.mat', 'updates');
end

mrk={'-o','-s','-*','-v','-+','-^'};
plot_base(error_rates, alphas, lambdas);
plot_comparison(error_rates, alphas, lambdas, algorithms, mrk);
plot_noise(error_rates, alphas, lambdas, algorithms, mrk);

function plot_base(error_rates, alphas, lambdas)
    figure;
    box on;
    hold on;
    lambda_index = lambdas == 0;
    plot(alphas, error_rates(lambda_index, :, 1));
    hold off;
    set(gca, 'FontSize', 12)
    title('Learning Curve for the Minover Algorithm', 'FontSize', 14);
    xlabel('Alpha = P / N');
    ylabel('Generalization Error');
    save_for_report('base');
end

function plot_comparison(error_rates, alphas, lambdas, algorithms, mrk)
    figure;
    box on;
    hold on;
    lambda_index = lambdas == 0;
    for algorithm = (1 : length(algorithms))
        set(gca, 'LineStyleOrder', mrk(mod(algorithm, length(mrk))));
        plot(alphas, error_rates(lambda_index, :, algorithm));
    end
    hold off;
    set(gca, 'FontSize', 12)
    title('Learning Curve of the Perceptron', 'FontSize', 14);
    xlabel('Alpha = P / N');
    ylabel('Generalization Error');
    legend(cellfun(@(a) capitalize(func2str(a)), algorithms, 'UniformOutput', false));
    save_for_report('comparison');
end

function plot_noise(error_rates, alphas, lambdas, algorithms, mrk)
    figure;
    box on;
    hold on;
    len_lambdas = length(lambdas);
    len_algorithms = length(algorithms);
    labels = cell(len_lambdas * len_algorithms, 1);
    for lambda = (1 : len_lambdas)
        for algorithm = (1 : len_algorithms)
            current_index = algorithm + (lambda - 1) * len_algorithms;
            set(gca, 'LineStyleOrder', mrk(1 + mod(current_index, length(mrk))));
            plot(alphas, error_rates(lambda, :, algorithm));
            labels{current_index} = sprintf("%s, \\lambda=%.1f", capitalize(func2str(algorithms{algorithm})), lambdas(lambda));
        end
    end
    hold off;
    set(gca, 'FontSize', 12)
    title('Learning Curve of the Perceptron', 'FontSize', 14);
    xlabel('Alpha = P / N');
    ylabel('Generalization Error');
    legend(labels, 'Location', 'southwest');
    save_for_report('noise');
end
