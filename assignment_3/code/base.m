%-------------------------------------------------------
% Learning by gradient descent.
% ------------------------------
% Base assignment.
%-------------------------------------------------------

function base(X, y, repetitions, iterations, eta, p, q)

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
        gdtrain(X_train, y_train, X_test, y_test, iterations, fixed);
    
    % plot weights as barplot
    figure;
    ax1 = subplot(2, 1, 1);
    bar(w1);
    set(gca, 'FontSize', 12);
    title('Weights for the hidden unit 1', 'FontSize', 14);
    xlabel('Feature');
    ylabel('Weight');
    xticks(2:2:n_dim);
    yticks(-5:1:5);
    ylim([-3, 3]);
    ax2 = subplot(2, 1, 2);
    bar(w2, 'r');
    set(gca, 'FontSize', 12);
    title('Weights for the hidden unit 2', 'FontSize', 14);
    xlabel('Feature');
    ylabel('Weight');
    xticks(2 : 2 : n_dim);
    yticks(-5 : 1 : 5);
    ylim([-3, 3]);
    save_for_report(sprintf('weights_p_%d', p), [ax1, ax2], 0.01);

    
    % repeat the experiment some times to get more reliable learning curves
    % that do not depend on the particular initialization of the weights
    samples = 41;
    trains = zeros(samples, repetitions);
    tests = zeros(samples, repetitions);
    for repetition = 1 : repetitions

        % log the progress
        fprintf('[BASE] repetition=%d, p=%d ...\n', repetition, p);
        
        % train and save the error curves
        [~, ~, times, trains(:, repetition), tests(:, repetition)] = ...
            gdtrain(X_train, y_train, X_test, y_test, iterations, fixed, samples);
    end

    % average & std
    train_avg = mean(trains, 2);
    train_std = std(trains, [], 2);
    test_avg = mean(tests, 2);
    test_std = std(tests, [], 2);

    % plot the error curves
    figure;
    errorbar(times, train_avg, train_std, 'b');
    hold on;
    errorbar(times, test_avg, test_std, 'r:', 'LineWidth', 1.25);
    hold off;
    set(gca, 'FontSize', 12);
    title(sprintf('Learning curves for P = %d', p), 'FontSize', 14);
    xlabel('Iterations');
    ylabel('Error');
    legend('Training Error', 'Test Error');
    xlim([0, iterations]);
    ylim([0, 0.5]);
    curtick = get(gca, 'XTick');
    set(gca, 'XTickLabel', cellstr(num2str(curtick(:))));
    save_for_report('error');
end
