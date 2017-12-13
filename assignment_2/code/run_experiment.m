function [average_error, errors] = run_experiment(alpha, N, n_max, repetitions)
    %RUN_EXPERIMENT Run an experiment for a fixes alpha and N.
    
    % choose some W*, for example w* = (1, 1, 1... 1)'
    w_star = ones(N, 1);
    
    % stop the training unless at least one component of the weigths vector
    % does not change significantly...
    min_update = 1e-10;

    % run the experiments
    fprintf('Running experiment for alpha=%.2f, N=%3d, n_max=%d, repetitions=%d ... ', alpha, N, n_max, repetitions);
    errors = zeros(repetitions, 1);
    parfor i = 1:repetitions
        
        % compute the number of examples to generate
        P = ceil(alpha * N);
        
        % generate examples
        [X, y] = generate_dataset(P, N, w_star);
        
        % train the perceptron
        w = minover(X, y, n_max, min_update);
        
        % compure the generalization error
        error = acos(dot(w, w_star) / (norm(w) * norm(w_star))) / pi;
        errors(i) = error;
    end
    average_error = mean(errors);
    fprintf('average generalization error = %f \n', average_error);
end
