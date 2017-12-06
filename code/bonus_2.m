
clf; close; close; 
clear;

% settings
N = 200;                      % N
alphas = 0.75:0.125:3;       % alpha
repetitions = 100;           % n_D
epochs = [100, 200, 500, 1000, 2000];               % n_max
c = [0 0.1:0.2:0.5 1:2:5];

homogeneity = true;

% fix seed for the random number generator
rng(0);

cache = 'results/bonus_2.mat';
if (exist(cache, 'file'))
    fprintf('Loading results from cache "%s"...\n', cache);
    success_rates = importdata(cache);
else
    fprintf('Cache not found in "%s"... running the experiments\n', cache);
    
    tic
    len_learn_rates = length(c);
    len_epochs = length(epochs);
    len_alphas = length(alphas);
    success_rates = zeros(len_learn_rates, len_alphas);
    for learn_rate = (1 : len_learn_rates)
        for alpha = (1 : len_alphas)
                success_rates(learn_rate, alpha) = run_experiment(alphas(alpha), N, epochs(2), repetitions, c(learn_rate));
        end
    end
    toc

    save('results/bonus_2.mat', 'success_rates');
end

figure;
hold on;
for plot_n = (1:size(success_rates,1))
    plot(alphas, success_rates(plot_n, :));
    legend(sprintf("c%d = %1.1f", plot_n, c(plot_n)));
end
title('Success rate over alpha');
xlabel('Alpha = P / N');
ylabel('Success rate');
hold off;
