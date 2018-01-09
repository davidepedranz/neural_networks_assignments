% Learning by gradient descent

close all;
clear;

rng(0);

% Your code goes here
load('data/data3.mat');
eta = 0.05;
t_max = 500;

X = xi';
y = tau';

train_range = 1:100;
test_range = 4001:5000;

[w1, w2, err_calc_time, train_error, test_error] = gdtrain(X(train_range, :), y(train_range), X(test_range, :), y(test_range), t_max, eta);

figure;
plot(err_calc_time, train_error, 'color', 'r');
hold on;
plot(err_calc_time, test_error, 'color', 'b');
legend('Training error', 'Test error');
xlabel('Iterations');
ylabel('Error');
hold off;
ylim([0, 0.5]);
