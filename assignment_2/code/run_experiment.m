function [average_error, errors] = run_experiment(train_function, alpha, N, n_max, repetitions)
    %RUN_EXPERIMENT Run an experiment for a fixes alpha and N.
    
    % choose some W*, for example w* = (1, 1, 1... 1)'
    w_star = ones(N, 1);
    
    % run the experiments
    fprintf('Experiment for "%s": \t alpha=%.2f, N=%3d, n_max=%d, repetitions=%d ... ', func2str(train_function), alpha, N, n_max, repetitions);
    errors = zeros(repetitions, 1);
    updates = zeros(repetitions, 1);
    parfor i = 1:repetitions
        
        % compute the number of examples to generate
        P = ceil(alpha * N);
        
        % generate examples
        [X, y] = generate_dataset(P, N, w_star);
        
        % train the perceptron
        [w, updates(i)] = train_function(X, y, n_max); %#ok<PFBNS>
        
        % compure the generalization error
        error = acos(dot(w, w_star) / (norm(w) * norm(w_star))) / pi;
        errors(i) = error;
    end
    average_error = mean(errors);
    average_updates = round(mean(updates));
    fprintf('average_generalization_error = %f, number_of_updates = %d\n', average_error, average_updates);
end
