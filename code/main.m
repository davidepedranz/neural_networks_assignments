%-------------------------------------------------------
% Rosenblatt Perceptron Algorithm.
% Implement and simulate a base Rosennblatt Perceptron.
% This include the base assignment and bonus 1.
%-------------------------------------------------------

% clean the workspace
clf; close; close; close; close; close; close; close; close; close; close;
clear;

% settings
epochs = [50, 100, 200];                                    % n_max
ns = [100, 200, 500];                                       % N
alphas = [0.75:0.25:1.5, 1.55:0.05:1.95, 2:0.25:3];         % alpha
repetitions = 200;                                          % n_D

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
    len_epochs = length(epochs);
    len_alphas = length(alphas);
    len_ns = length(ns);
    success_rates = zeros(len_epochs, len_alphas, len_ns);
    for epoch = (1 : len_epochs)
        for alpha = (1 : len_alphas)
            for n = (1 : len_ns)
                success_rates(epoch, alpha, n) = run_experiment(alphas(alpha), ns(n), epochs(epoch), repetitions);
            end
        end
    end
    toc

    save('results/base.mat', 'success_rates');
end

mrk={'-o','-s','-*','-v','-+','-^'};
plot_base(success_rates, alphas, epochs, ns);
plot_multiple_epochs(success_rates, alphas, epochs, ns, mrk);
plot_multiple_n(success_rates, alphas, epochs, ns, mrk);

function plot_base(success_rates, alphas, epochs, ns)
    n_epochs = 200;
    N = 200;

    figure;
    box on;
    hold on;
    index_epochs = find(epochs == n_epochs);
    index_ns = find(ns == N);
    plot(alphas, success_rates(index_epochs, :, index_ns)); %#ok<FNDSB>
    hold off;
    set(gca, 'FontSize', 12)
    title('Storage Success Rate', 'FontSize', 14);
    xlabel('Alpha = P / N');
    ylabel('Success Rate');
    save_for_report('base');
end

function plot_multiple_epochs(success_rates, alphas, epochs, ns, mrk)
    N = 200;

    figure;
    box on;
    hold on;
    index_ns = find(ns == N);
    for i = 1:length(epochs)
        set(gca, 'LineStyleOrder', mrk(mod(i, length(mrk))));
        plot(alphas, success_rates(i, :, index_ns)); %#ok<FNDSB>
    end
    hold off;
    set(gca, 'FontSize', 12)
    title('Storage Success Rate', 'FontSize', 14);
    xlabel('Alpha = P / N');
    ylabel('Success Rate');
    legend(cellstr(num2str(epochs', 'epochs=%-d')));
    save_for_report('multiple_epochs');
end

function plot_multiple_n(success_rates, alphas, epochs, ns, mrk)
    n_epochs = 200;
    
    figure;
    box on;
    hold on;
    index_epochs = find(epochs == n_epochs);
    for n=1:length(ns)
        set(gca, 'LineStyleOrder', mrk(mod(n, length(mrk))));
        plot(alphas, success_rates(index_epochs, :, n));  %#ok<FNDSB>
    end
    hold off;
    set(gca, 'FontSize', 12)
    title('Storage Success Rate', 'FontSize', 14);
    xlabel('Alpha = P / N');
    ylabel('Success Rate');
    legend(cellstr(num2str(ns', 'N=%-d')));
    save_for_report('multiple_n');
end
