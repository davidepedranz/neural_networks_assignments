% Learning by gradient descent

close all;
clear;

rng(0);

% Your code goes here
load('data/data3.mat');
t_max = 250;

% Fixed LRP parameters
eta_fixed = 0.02;

% Step LRP parameters
eta_step = 0.05;
drop_step = 2^-1;
stepsize_step = 20000;

% Exponential LRP parameters
eta_exp = 0.05;
drop_exp = 10^-1;
stepsize_exp = 20000;

% Triangular LRP parameters
eta_cycle = 0.01;
max_eta_cycle = 0.05;
stepsize_cycle = 10000;

% Triangular2 LRP parameters
eta_cycle2 = 0.01;
max_eta_cycle2 = 0.05;
stepsize_cycle2 = 10000;

X = xi';
y = tau';

train_range = 1:500;
test_range = 4001:5000;
total_iterations = 1:1:t_max*max(train_range);

fixed = lrpfixed(eta_fixed);
step = lrpstep(eta_step, stepsize_step, drop_step);
exp_lrp = lrpexp(eta_exp, stepsize_exp, drop_exp);
cycle = lrpcycle(eta_cycle, max_eta_cycle, stepsize_cycle);
cycle2 = lrpcycle2(eta_cycle2, max_eta_cycle2, stepsize_cycle2);

[w1, w2, err_calc_time, train_error, test_error ,lr] = gdtrain(X(train_range, :), y(train_range), X(test_range, :), y(test_range), t_max, cycle2);

figure;

subplot(2,1,1);
plot(total_iterations, lr);
xlim([0 max(total_iterations)]);

subplot(2,1,2);
plot(err_calc_time, train_error, 'color', 'r');
hold on;
plot(err_calc_time, test_error, 'color', 'b');
legend('Training error', 'Test error');
xlabel('Iterations');
ylabel('Error');
xlim([0 max(total_iterations)]);
hold off;

% for i = 1:10
%     [w1, w2, err_calc_time, train_error(i, :), test_error(i, :)] = gdtrain(X(train_range, :), y(train_range), X(test_range, :), y(test_range), t_max, eta);
% end

% mu_train_error = mean(train_error, 1);
% mu_test_error = mean(test_error, 1);
% 
% figure;
% plot(err_calc_time, mu_train_error, 'color', 'r');
% hold on;
% plot(err_calc_time, mu_test_error, 'color', 'b');
% legend('Training error', 'Test error');
% xlabel('Iterations');
% ylabel('Error');
% hold off;
% ylim([0, 0.5]);
% saveas(gcf, sprintf('img/error_P_%d', max(train_range)),'png');

% Plot weights as barplot

% figure;
% weights = [w1 w2];
% subplot(2, 1, 1);
% bar(w1);
% subplot(2, 1, 2);
% bar(w2, 'r');
