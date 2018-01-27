%-------------------------------------------------------
% Rosenblatt Perceptron Algorithm.
% Bonus 2: influence of c.
%-------------------------------------------------------

% clean the workspace
clf; close all; 
clear;

% settings
epochs = [200, 500, 1000, 2000];               % n_max
N = 500;                                       % N
alphas = 0.75:0.125:3;                         % alpha
repetitions = 100;                             % n_D
c = [0:0.5:1 2];
c_2 = [0,2];
homogeneity = true;

% fix seed for the random number generator
rng(0);

% experiments for different c, fixed n_max
c_cache = 'results/bonus_2_c.mat';
if (exist(c_cache, 'file'))
    fprintf('Loading results from cache "%s"...\n', c_cache);
    c_success_rates = importdata(c_cache);
else
    fprintf('Cache not found in "%s"... running the experiments\n', c_cache);
    
    len_learn_rates = length(c);
    len_epochs = length(epochs);
    len_alphas = length(alphas);
    c_success_rates = zeros(len_learn_rates, len_alphas);
    for learn_rate = (1 : len_learn_rates)
        for alpha = (1 : len_alphas)
                c_success_rates(learn_rate, alpha) = run_experiment(alphas(alpha), N, epochs(1), repetitions, c(learn_rate));
        end
    end

    save('results/bonus_2_c.mat', 'c_success_rates');
end

% experiments for fixed c and different n_max
epoch_cache = 'results/bonus_2_epoch.mat';
if (exist(epoch_cache, 'file'))
    fprintf('Loading results from cache "%s"...\n', epoch_cache);
    epoch_success_rates = importdata(epoch_cache);
else
    fprintf('Cache not found in "%s"... running the experiments\n', epoch_cache);
    
    len_epochs = length(epochs);
    len_alphas = length(alphas);
    epoch_success_rates = zeros(len_epochs, len_alphas);
    for epoch = (1 : len_epochs)
        for alpha = (1 : len_alphas)
                epoch_success_rates(epoch, alpha) = run_experiment(alphas(alpha), N, epochs(epoch), repetitions, c(4));
        end
    end

    save('results/bonus_2_epoch.mat', 'epoch_success_rates');
end

% experiments for different c and n_max
c_epoch_cache = 'results/bonus_2_c_epoch.mat';
if (exist(c_epoch_cache, 'file'))
    fprintf('Loading results from cache "%s"...\n', c_epoch_cache);
    c_epoch_success_rates = importdata(c_epoch_cache);
else
    c_epoch_success_rates = zeros(2, length(alphas));
    c_epoch_success_rates(1, :) = arrayfun(@(alpha) run_experiment(alpha, N, 200, repetitions, c_2(1)), alphas);
    c_epoch_success_rates(2, :) = arrayfun(@(alpha) run_experiment(alpha, N, 1000, repetitions, c_2(2)), alphas);    
    save('results/bonus_2_c_epoch.mat', 'c_epoch_success_rates');
end


% markers for the plots
mrk={'-o','-s','-*','-v','-+','-^'};

% different epochs and c
figure;
hold on;
box on;
set(gca, 'LineStyleOrder', mrk(1));
plot(alphas, c_epoch_success_rates(1, :));
set(gca, 'LineStyleOrder', mrk(2));
plot(alphas, c_epoch_success_rates(2, :));
set(gca, 'FontSize', 12)
title('Storage Success Rate', 'FontSize', 14);
xlabel('Alpha = P / N');
ylabel('Success rate');
legend(sprintf("c=%.1f, iterations=%4d", c_2(1), epochs(1)), sprintf("c=%.1f, iterations=%4d", c_2(2), epochs(3)));
hold off;
save_for_report('bonus_2_c_epoch');

% different c, fixed epochs
figure;
hold on;
box on;
for plot_n = (1:size(c_success_rates,1))
    set(gca, 'LineStyleOrder', mrk(mod(plot_n, length(mrk))));
    plot(alphas, c_success_rates(plot_n, :));
end
set(gca, 'FontSize', 12)
title('Storage Success Rate', 'FontSize', 14);
xlabel('Alpha = P / N');
ylabel('Success rate');
lgnd = legend(cellstr(num2str(c', 'c=%.1f')));
title(lgnd,'iterations = 200');
hold off;
save_for_report('bonus_2_c');

% different epochs, fixed c
figure;
hold on;
box on;
for plot_n = (1:size(epoch_success_rates,1))
    set(gca, 'LineStyleOrder', mrk(mod(plot_n, length(mrk))));
    plot(alphas, epoch_success_rates(plot_n, :));
end
set(gca, 'FontSize', 12)
title('Storage Success Rate', 'FontSize', 14);
xlabel('Alpha = P / N');
ylabel('Success rate');
lgnd = legend(cellstr(num2str(epochs', 'iterations=%4d')));
title(lgnd, 'c = 2');
hold off;
save_for_report('bonus_2_epoch');
