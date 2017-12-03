clf; close; close; clear;


% settings
repetitions = 200;
alphas = 0.75:0.125:3;
N = 50;
epochs = 100;
c_1 = 5;
c_2 = 0;
homogeneity = true;

tic
success_rates_wc = arrayfun(@(alpha) run_experiment(alpha, N, epochs, repetitions, c_1, homogeneity), alphas);
success_rates_woc = arrayfun(@(alpha) run_experiment(alpha, N, epochs, repetitions, c_2, false), alphas);
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

function [success_rate, results] = run_experiment(alpha, N, epochs, repetitions, c, hom)
    switch nargin
        case 4
            c = 0;
            hom = true;
        case 5
            hom = true;
    end

    fprintf('Running experiment for alpha = %f ... ', alpha);
    results = zeros(repetitions, 1);
    parfor i = 1:repetitions
        if hom
             P = ceil(alpha * N);
             [X, y] = generate_dataset(P, N);
        else
            P = ceil(alpha * N+1);
            [X, y] = generate_dataset(P, N+1);
        end
        
        w = train_perceptron(X, y, epochs, c, hom);
        success = all(iff(X * w <= 0, -1, 1) == y);
        results(i) = success;
    end
    success_rate = sum(results) / length(results);
    fprintf('success_rate = %f \n', success_rate);
end