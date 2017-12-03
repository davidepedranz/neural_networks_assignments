function [success_rate, results] = run_experiment(alpha, N, epochs, repetitions, c, homogeneous)
    %RUN_EXPERIMENT Run an experiment for a fixes alpha and N.
    
    % by default, use threashold c = 0 and train homogeneous perceptrons
    switch nargin
        case 4
            c = 0;
            homogeneous = true;
        case 5
            homogeneous = true;
    end

    % run the experiments
    fprintf('Running experiment for alpha=%.2f, N=%3d ... ', alpha, N);
    results = zeros(repetitions, 1);
    parfor i = 1:repetitions
        
        % compute the number of examples to generate
        P = ceil(alpha * N);
        
        % generate examples
        [X, y] = generate_dataset(P, N);
        
        % add a column for the biases, if needed
        if ~homogeneous
            X = [ones(size(X, 1), 1), X];
        end
        
        % train the perceptron
        w = train_perceptron(X, y, epochs, c);
        
        % TODO: check if this should be a zero or c
        % evaluate the performances
        success = all(iff(X * w <= 0, -1, 1) == y);
        results(i) = success;
    end
    success_rate = sum(results) / length(results);
    fprintf('success_rate = %f \n', success_rate);
end
