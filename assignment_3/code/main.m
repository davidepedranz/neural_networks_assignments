%-------------------------------------------------------
% Learning by gradient descent.
%-------------------------------------------------------
clf; close all; clear; clc;

% fix seed for the random number generator
rng(0);

% utilities for the plots
colors = [
    228,26,28;
    55,126,184;
    77,175,74;
    152,78,163;
    255,127,0;
    255,220,15;
    166,86,40;
    247,129,191;
] / 256;
markers = '+o*<sxd^';

% load the data
load('data/data3.mat');
X = xi';
y = tau';
[n_examples, n_dim] = size(X);

% settings
repetitions = 10;
t_max = 100;
eta_fixed = 0.05;
ps = [20, 50, 200, 500, 1000, 2000];

% fixed learning rate
fixed = lrpfixed(eta_fixed);

% we fix the examples used for the test
test_range = (max(ps) + 1) : n_examples;
X_test = X(test_range, :);
y_test = y(test_range);


% train one last time to plot the weights in a bar plot
p = max(ps);
X_train = X(1 : p, :);
y_train = y(1 : p);
[w1, w2, ~, ~, ~] = gdtrain(X_train, y_train, X_test, y_test, t_max, fixed);

% plot weights as barplot
figure;
ax1 = subplot(2, 1, 1);
bar(w1);
title('Weights for the hidden unit 1');
xlabel('Feature');
ylabel('Weight');
xticks(2:2:n_dim);
yticks(-5:1:5);
ylim([-5, 5]);
ax2 = subplot(2, 1, 2);
bar(w2, 'r');
title('Weights for the hidden unit 2');
xlabel('Feature');
ylabel('Weight');
xticks(2:2:n_dim);
yticks(-5:1:5);
ylim([-5, 5]);
save_for_report(sprintf('weights_p_%d', p), [ax1, ax2], 0.01);


% repeat the experiment some times to get more reliable learning curves
% that do not depend on the particular initialization of the weights
n_ps = length(ps);
trains = zeros(t_max + 1, n_ps, repetitions);
tests = zeros(t_max + 1, n_ps, repetitions);
for repetition = 1 : repetitions
    for p_index = 1 : n_ps
        
        % log the progress
        p = ps(p_index);
        fprintf('Train: repetition=%d, p=%d...\n', repetition, p);
        
        % compute the train examples
        train_range = 1 : p;
        X_train = X(train_range, :);
        y_train = y(train_range);
        
        % train and save the error curves
        [~, ~, epochs, trains(:, p_index, repetition), tests(:, p_index, repetition)] = ...
            gdtrain(X_train, y_train, X_test, y_test, t_max, fixed);
    end
end

% average
train_errors = mean(trains, 3);
test_errors = mean(tests, 3);

% plot the error curves
for p_index = 1 : n_ps
    p = ps(p_index);
    figure;
    plot(epochs, train_errors(:, p_index), 'color', 'b');
    hold on;
    plot(epochs, test_errors(:, p_index), 'color', 'r');
    hold off;
    title(sprintf('Learning curves for P = %d', p));
    xlabel('Iterations');
    ylabel('Error');
    legend('Training Error', 'Test Error');
    ylim([0, 0.5]);
    save_for_report(sprintf('error_p_%d', p));
end

% plot curves for different ps on the same graph
ps_plot = [20, 50, 200, 500];
step = 3;
figure;
box on;
hold on;
i = 1;
leg = {};
for p = ps_plot
    p_index = find(ps == p);
    plot(epochs(1 : step : end), train_errors(1 : step : end, p_index), ...
        'Color', colors(i, :), 'Marker', markers(i), 'MarkerSize', 5);
    leg{end + 1} = sprintf('Train Error, P = %d', p);  %#ok<SAGROW>
    plot(epochs(1 : step : end), test_errors(1 : step : end, p_index), ... 
        'Color', colors(i, :), 'Marker', markers(i), ...
        'LineWidth', 1.25, 'LineStyle', ':', 'MarkerSize', 5);
    leg{end + 1} = sprintf('Test  Error, P = %d', p); %#ok<SAGROW>
    i = i + 1;
end
hold off;
title('Learning curves for different values of P');
xlabel('Iterations');
ylabel('Error');
ylim([0, 0.5]);
legend(leg);
save_for_report('errors');


% TODO: test different learning rates

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

fixed = lrpfixed(eta_fixed);
step = lrpstep(eta_step, stepsize_step, drop_step);
exp_lrp = lrpexp(eta_exp, stepsize_exp, drop_exp);
cycle = lrpcycle(eta_cycle, max_eta_cycle, stepsize_cycle);
cycle2 = lrpcycle2(eta_cycle2, max_eta_cycle2, stepsize_cycle2);

% plot(total_iterations, lr);
% xlim([0 max(total_iterations)]);
