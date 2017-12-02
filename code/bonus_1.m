clf; close; close; clear;


% settings
repetitions = 200;
alphas = [1.75 2.25];
N = (10:1:50);
epochs = 100;

for i = (1 : length(alphas))
   for j = (1 : length(N))
       success_rates(i, j) = run_experiment(alphas(i), N(j), epochs, repetitions);
       
   end
end

figure;
hold on;
plot(N, success_rates(1, :));
title('title');
xlabel('N = P / Alpha');
ylabel('Success Rate');
plot(N, success_rates(2, :));
title('title');
xlabel('N = P / Alpha');
ylabel('Success Rate');
legend('alpha = 1.75', 'alpha = 2.25');
hold off;

function [success_rate, results] = run_experiment(alpha, N, epochs, repetitions)
    fprintf('Running experiment for alpha = %f ... ', alpha);
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