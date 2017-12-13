function w = minover(X, y, n_max, min_update)
    %%TRAIN_PERCEPTRON Train a perceptron on the dataset X, y for at most
    % (n_max * P) epochs using the Minover algorithm.
    
    % extract the number of examples P and number of dimensions (N)
    P = size(X, 1);
    N = size(X, 2);
    
    % initialize the weights to zero
    w = zeros(N, 1);

    % repeat training for any epochs
    epochs = n_max * P;
    for epoch = 1:epochs
        
        % compute stabilities k^{v(t)}
        % NB: we do NOT divide by |w| since it is a constant for all
        % examples and we only want to take the examples with the lowest
        % stability
        stabilities = (X * w) .* y;
        
        % keep track of the old weight... we use this to stop the training
        % if the weights do not change significanty for a traning step
        old_w = w;
        
        % extract the example with lowest stability
        [~, index] = min(stabilities);
        
        % perform a Hebbian update step of the weights
        example = X(index, :);
        label = y(index);
        w = old_w + (example' * label) / N;
        
        % stopping criteria: stop if there is no significant update...
        if all(abs(old_w - w) < (ones(N) * min_update))
            break
        end
    end
end
