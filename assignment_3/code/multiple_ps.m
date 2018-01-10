%-------------------------------------------------------
% Learning by gradient descent.
% ------------------------------
% Different Ps.
%-------------------------------------------------------

function multiple_ps(X, y, repetitions, t_max, eta, ps, q)

    % utilities for the plots
    colors = [
        228,26,28;
        55,126,184;
        77,175,74;
        152,78,163;
        255,127,0;
    ] / 256;
    markers = '*o+<s';


    % basic learning strategy: fixed learning rate
    fixed = lrpfixed(eta);
    
    % we fix the examples used for the test
    [n_examples, ~] = size(X);
    test_range = q : n_examples;
    X_test = X(test_range, :);
    y_test = y(test_range);
    
    % repeat the experiment some times to get more reliable learning curves
    % that do not depend on the particular initialization of the weights
    n_ps = length(ps);
    trains = zeros(t_max + 1, n_ps, repetitions);
    tests = zeros(t_max + 1, n_ps, repetitions);
    for repetition = 1 : repetitions
        for p_index = 1 : n_ps

            % log the progress
            p = ps(p_index);
            fprintf('[PS] repetition=%d, p=%d ...\n', repetition, p);

            % compute the train examples
            train_range = 1 : p;
            X_train = X(train_range, :);
            y_train = y(train_range);

            % train and save the error curves
            [~, ~, iterations, trains(:, p_index, repetition), tests(:, p_index, repetition)] = ...
                gdtrain(X_train, y_train, X_test, y_test, t_max, fixed);
        end
    end

    % average & std
    train_avg = mean(trains, 3);
    train_std = std(trains, [], 3);
    test_avg = mean(tests, 3);
    test_std = std(tests, [], 3);

    % plot the error curves
    for p_index = 1 : n_ps
        p = ps(p_index);
        figure;
        errorbar(iterations, train_avg(:, p_index), train_std(:, p_index), 'b');
        hold on;
        errorbar(iterations, test_avg(:, p_index), test_std(:, p_index), 'r:', 'LineWidth', 1.25);
        hold off;
        set(gca, 'FontSize', 12);
        title(sprintf('Learning curves for P = %d', p), 'FontSize', 14);
        xlabel('Iterations');
        ylabel('Error');
        legend('Training Error', 'Test Error');
        curtick = get(gca, 'XTick');
        set(gca, 'XTickLabel', cellstr(num2str(curtick(:))));
        ylim([0, 0.5]);
        save_for_report(sprintf('error_p_%d', p));
    end

    % plot curves for different ps on the same graph
    ps_plot = [20, 50, 200, 500];
    figure;
    box on;
    hold on;
    i = 1;
    leg = {};
    for p = ps_plot
        p_index = find(ps == p);
        plot(iterations, train_avg(:, p_index), 'Color', colors(i, :), ...
            'Marker', markers(i), 'MarkerSize', 5);
        leg{end + 1} = sprintf('Train Error, P = %d', p);  %#ok<AGROW>
        plot(iterations, test_avg(:, p_index), 'Color', colors(i, :), ...
            'Marker', markers(i), 'MarkerSize', 5, 'LineWidth', 1.25, 'LineStyle', ':');
        leg{end + 1} = sprintf('Test  Error, P = %d', p); %#ok<AGROW>
        i = i + 1;
    end
    hold off;
    set(gca, 'FontSize', 12);
    title('Learning curves for different values of P', 'FontSize', 14);
    xlabel('Iterations');
    ylabel('Error');
    legend(leg);
    ylim([0, 0.5]);
    curtick = get(gca, 'XTick');
    set(gca, 'XTickLabel', cellstr(num2str(curtick(:))));
    save_for_report('error_ps');
end
