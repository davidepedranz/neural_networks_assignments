%-------------------------------------------------------
% Learning by gradient descent.
% ------------------------------
% Base assignment.
%-------------------------------------------------------

function base(X, y, repetitions, t_max, eta, p, q)

    % extract train and test set
    [n_examples, n_dim] = size(X);
    train_range = 1 : p;
    test_range = q : n_examples;
    X_train = X(train_range, :);
    y_train = y(train_range);
    X_test = X(test_range, :);
    y_test = y(test_range);
    
    % basic learning strategy: fixed learning rate
    fixed = lrpfixed(eta);

    
    % train one last time to plot the weights in a bar plot
    fprintf('[BASE] weights bar plot ...\n');
    [w1, w2, ~, ~, ~, ~] = ...
        gdtrain(X_train, y_train, X_test, y_test, t_max, fixed);
    
    % plot weights as barplot
    figure;
    ax1 = subplot(2, 1, 1);
    bar(w1);
    title('Weights for the hidden unit 1');
    xlabel('Feature');
    ylabel('Weight');
    xticks(2:2:n_dim);
    yticks(-5:1:5);
    ylim([-3, 3]);
    ax2 = subplot(2, 1, 2);
    bar(w2, 'r');
    title('Weights for the hidden unit 2');
    xlabel('Feature');
    ylabel('Weight');
    xticks(2 : 2 : n_dim);
    yticks(-5 : 1 : 5);
    ylim([-3, 3]);
    save_for_report(sprintf('weights_p_%d', p), [ax1, ax2], 0.01);

    
    % repeat the experiment some times to get more reliable learning curves
    % that do not depend on the particular initialization of the weights
    trains = zeros(t_max + 1, repetitions);
    tests = zeros(t_max + 1, repetitions);
    for repetition = 1 : repetitions

        % log the progress
        fprintf('[BASE] repetition=%d, p=%d ...\n', repetition, p);
        
        % train and save the error curves
        [~, ~, iterations, trains(:, repetition), tests(:, repetition)] = ...
            gdtrain(X_train, y_train, X_test, y_test, t_max, fixed);
    end

    % average & std
    train_avg = mean(trains, 2);
    train_std = std(trains, [], 2);
    test_avg = mean(tests, 2);
    test_std = std(tests, [], 2);

    % plot the error curves
    figure;
    errorbar(iterations, train_avg, train_std, 'b');
    hold on;
    errorbar(iterations, test_avg, test_std, 'r:', 'LineWidth', 1.25);
    hold off;
    title(sprintf('Learning curves for P = %d', p));
    xlabel('Iterations');
    ylabel('Error');
    legend('Training Error', 'Test Error');
    ylim([0, 0.5]);
    save_for_report('error');
end
