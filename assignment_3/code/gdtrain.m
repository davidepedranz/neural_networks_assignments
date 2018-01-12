function [w1, w2, error_time, train_error, test_error, lr] = ...
    gdtrain(X_train, y_train, X_test, y_test, iterations, lr_policy, samples)
    %GDTRAIN Train a neural network with 1 hidden layer and 2 hidden units
    %using stochastic gradient descent.
    
    switch nargin
        case 6
            samples = 51;
    end

    % extract the dimentsion of the dataset
    [p, n_dim] = size(X_train);
    
    % initialization of the weights vectors with norm = 1
    w1_raw = rand(n_dim, 1);
    w1 = w1_raw / norm(w1_raw);
    w2_raw = rand(n_dim, 1);
    w2 = w2_raw / norm(w2_raw);

    % initialize the matrixes to store the train and test errors
    step = floor(iterations / (samples - 1));
    error_time = zeros(samples, 1);
    train_error = zeros(samples, 1);
    test_error = zeros(samples, 1);
    
    % initialize the array where to store the learning rate behaviours
    lr = zeros(iterations, 1);
    
    % train loop
    for iteration = 1 : iterations

        % measure train and test error sometimes
        if mod(iteration, step) == 1
            current = ceil(iteration / step);
            error_time(current) = iteration;
            train_error(current) = gderror(X_train, y_train, w1, w2);
            test_error(current) = gderror(X_test, y_test, w1, w2);
        end
        
        % extract a random example
        index = randi(p); 
        example = X_train(index, :);
        tau = y_train(index);
        
        % compure the gradients for w1 and w2
        [g1, g2] = gd(example, tau, w1, w2);
        
        % update the learning rate according to the given policy
        lr(iteration) = lr_policy(iteration);
        
        % update the weights according to their gradient
        w1 = w1 - lr(iteration) * g1;
        w2 = w2 - lr(iteration) * g2;
    end
end
