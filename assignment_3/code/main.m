% Learning by gradient descent

close all;
clear;

rng(0);

% Your code goes here
load('data/data3.mat');
eta = 0.05;
t_max = 250;

X = xi';
y = tau';

train_range = 1:500;
test_range = 4001:5000;

for i = 1:10
    [w1, w2, err_calc_time, train_error(i, :), test_error(i, :)] = gdtrain(X(train_range, :), y(train_range), X(test_range, :), y(test_range), t_max, eta);
end

mu_train_error = mean(train_error, 1);
mu_test_error = mean(test_error, 1);

figure;
plot(err_calc_time, mu_train_error, 'color', 'r');
hold on;
plot(err_calc_time, mu_test_error, 'color', 'b');
legend('Training error', 'Test error');
xlabel('Iterations');
ylabel('Error');
hold off;
ylim([0, 0.5]);
saveas(gcf, sprintf('img/error_P_%d', max(train_range)),'png');

% Plot weights as barplot

% figure;
% weights = [w1 w2];
% subplot(2, 1, 1);
% bar(w1);
% subplot(2, 1, 2);
% bar(w2, 'r');
