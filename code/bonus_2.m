clf; close; close; clear;


% settings
repetitions = 200;
alphas = 0.75:0.125:3;
N = 20;
epochs = 100;
c = 1;

tic
success_rates_wc = arrayfun(@(alpha) run_experiment(alpha, N, epochs, repetitions, c, 0.1), alphas);
success_rates_woc = arrayfun(@(alpha) run_experiment(alpha, N, epochs, repetitions), alphas);
toc

figure;
hold on;
plot(alphas, success_rates_wc);
plot(alphas, success_rates_woc);
title('Success rate over alpha');
xlabel('Alpha = P / N');
ylabel('Success rate');
legend(sprintf("c = %0.1f", c) , 'c = 0');
hold off;

function [success_rate, results] = run_experiment(alpha, N, epochs, repetitions, c, theta)
    switch nargin
        case 4
            c = 0;
            theta = 0;
        case 5
            theta = 0;
    end

    fprintf('Running experiment for alpha = %f ... ', alpha);
    results = zeros(repetitions, 1);
    parfor i = 1:repetitions
        P = ceil(alpha * N);
        [X, y] = generate_dataset(P, N);
        w = train_perceptron(X, y, epochs, c, theta);
        success = all(iff(X * w <= 0, -1, 1) == y);
        results(i) = success;
    end
    success_rate = sum(results) / length(results);
    fprintf('success_rate = %f \n', success_rate);
end