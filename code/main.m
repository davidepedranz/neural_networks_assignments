clf; close; close; clear;

% cluster start
parpool('local', 8);

% settings
repetitions = 200;
alphas = 0.75:0.125:3;
N = 20;
epochs = 100;

% run all experiments
success_rates = arrayfun(@(alpha) run_experiment(alpha, N, epochs, repetitions), alphas);

% alpha_min = 0.75;
% alpha_max = 3;
% alpha_step = 0.25; 
% steps = (alpha_max - alpha_min) / alpha_step;
% 
% success_rates = zeros(1, steps);
% for i = 1:steps
%     alpha = alpha_min + alpha_step * i;
%     success_rates(i) = run_experiment(alpha, N, epochs, repetitions);
% end

% plot
plot(alphas, success_rates);
title('title');
xlabel('Alpha = P / N');
ylabel('Success Rate');

% cluster shutdown
delete(gcp('nocreate'));


function [success_rate, results] = run_experiment(alpha, N, epochs, repetitions)
    fprintf('Running experiment for alpha = %f ... ', alpha)
    results = zeros(repetitions, 1);
    parfor i = 1:repetitions
        P = ceil(alpha * N);
        [X, y] = generate_dataset(P, N);
        w = train_perceptron(X, y, epochs);
        success = all(iff(X * w < 0, -1, 1) == y);
        results(i) = success;
    end
    success_rate = sum(results) / length(results);
    fprintf('success_rate = %f \n', success_rate)
end
