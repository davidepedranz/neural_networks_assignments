%-------------------------------------------------------
% Learning by gradient descent.
% ------------------------------
% Different learning rate policies.
%-------------------------------------------------------

function multiple_lrp(X, y, repetitions, iterations, p, q, strategies, strategies_names)

    % utilities for the plots
    colors = [
        228,26,28;
        55,126,184;
        77,175,74;
        152,78,163;
        255,127,0;
    ] / 256;
    markers = '*o+<s';

    % extract train and test set
    [n_examples, ~] = size(X);
    train_range = 1 : p;
    test_range = q : n_examples;
    X_train = X(train_range, :);
    y_train = y(train_range);
    X_test = X(test_range, :);
    y_test = y(test_range);
    
    % train for different strategies
    % repeat the experiment some times to get more reliable learning curves
    % that do not depend on the particular initialization of the weights
    samples = 41;
    n_strategies = length(strategies);
    trains = zeros(samples, n_strategies, repetitions);
    tests = zeros(samples, n_strategies, repetitions);
    learning_rates = zeros(iterations, n_strategies);
    for s_index = 1 : n_strategies
        for repetition = 1 : repetitions

            % log the progress
            fprintf('[STRATEGIES]: repetition=%d, strategy=%s...\n', ...
                repetition, strategies_names{s_index});

            % train and save the error curves
            [~, ~, times, trains(:, s_index, repetition), ...
                tests(:, s_index, repetition), lr] = ...
                gdtrain(X_train, y_train, X_test, y_test, ....
                iterations, strategies{s_index}, samples);
        end
        
        % save the learning rate over time to plot it
        learning_rates(:, s_index) = lr;
    end
    
    % average & std
    train_avg = mean(trains, 3);
    train_std = std(trains, [], 3);
    test_avg = mean(tests, 3);
    test_std = std(tests, [], 3);
    
    % plot the error curves
    for s_index = 1 : n_strategies
        strategy = strategies_names{s_index};
        figure;
        errorbar(times, train_avg(:, s_index), train_std(:, s_index), 'b');
        hold on;
        errorbar(times, test_avg(:, s_index), test_std(:, s_index), 'r:', 'LineWidth', 1.25);
        hold off;
        set(gca, 'FontSize', 12);
        title(sprintf('Learning curves for strategy = %s', strategy), 'FontSize', 14);
        xlabel('Iterations');
        ylabel('Error');
        legend('Training Error', 'Test Error');
        xlim([0, iterations]);
        ylim([0, 0.5]);
        curtick = get(gca, 'XTick');
        set(gca, 'XTickLabel', cellstr(num2str(curtick(:))));
        save_for_report(sprintf('error_strategy_%s', strategy));
    end
    
    % plot curves for different strategies on the same graph
    figure;
    box on;
    hold on;
    i = 1;
    leg = {};
    for s_index = 1 : n_strategies
        strategy = strategies_names{s_index};
        plot(times, train_avg(:, s_index), 'Color', colors(i, :), ...
            'Marker', markers(i), 'MarkerSize', 5);
        leg{end + 1} = sprintf('Train Error, %s', strategy);  %#ok<AGROW>
        plot(times, test_avg(:, s_index), 'Color', colors(i, :), ...
            'Marker', markers(i), 'MarkerSize', 5, 'LineWidth', 1.25, 'LineStyle', ':');
        leg{end + 1} = sprintf('Test  Error, %s', strategy);  %#ok<AGROW>
        i = i + 1;
    end
    hold off;
    set(gca, 'FontSize', 12);
    title('Learning curves for different learning strategies', 'FontSize', 14);
    xlabel('Iterations');
    ylabel('Error');
    legend(leg);
    xlim([0, iterations]);
    ylim([0, 0.2]);
    curtick = get(gca, 'XTick');
    set(gca, 'XTickLabel', cellstr(num2str(curtick(:))));
    save_for_report('error_strategies');
    
    % plot the learning rates
    figure;
    box on;
    hold on;
    step = floor(size(learning_rates, 1) / 40);
    range = 1 : step : size(learning_rates, 1);
    for s_index = 1 : n_strategies
        plot(range, learning_rates(range, s_index), 'Color', ...
            colors(s_index, :), 'Marker', markers(s_index), 'MarkerSize', 5);
    end
    hold off;
    set(gca, 'FontSize', 12);
    title('Learning rate for different learning strategies', 'FontSize', 14);
    xlabel('Iterations');
    ylabel('Learning Rate');
    legend(strategies_names);
    xlim([0, iterations]);
    ylim([0, 0.07]);
    curtick = get(gca, 'XTick');
    set(gca, 'XTickLabel', cellstr(num2str(curtick(:))));
    save_for_report('learning_rates');
end
