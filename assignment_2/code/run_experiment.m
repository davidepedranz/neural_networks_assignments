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
    fprintf('Running experiment for alpha=%.2f, N=%3d, epochs=%d, repetitions=%d, c=%f, homogeneous=%d ... ', alpha, N, epochs, repetitions, c, homogeneous);
    results = zeros(repetitions, 1);
    for i = 1:repetitions
        
        % compute the number of examples to generate
        P = ceil(alpha * N);
        
        % generate examples
        X = generate_dataset(P, N);
        
        % add a column for the biases, if needed
        if ~homogeneous
            X = [ones(size(X, 1), 1), X];
        end
        
        % train the perceptron
        w = train_perceptron(X, epochs, c);
        
        % evaluate the performances
        % all error values tend to c, that's why the success criteria
        % should be c too
        success = all(iff(X * w <= c, -1, 1) == y);
        results(i) = success;
    end
    success_rate = sum(results) / length(results);
    fprintf('success_rate = %f \n', success_rate);
end
