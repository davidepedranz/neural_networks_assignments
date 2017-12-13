function [w, n_updates] = rosenblatt(X, y, n_max)
    %%TRAIN_PERCEPTRON Train a perceptron on the dataset X, y for #epochs.
    % This implementation uses the Rosenblatt algorithm (see assignment 1).
    
    % check the input
    assert(size(X, 1) == size(y, 1));
    assert(size(y, 2) == 1);
    
    % extract the number of examples P and number of dimensions (N)
    P = size(X, 1);
    N = size(X, 2);
    
    % initialize the weights to zero
    w = zeros(N, 1);
    
    % repeat training for any epochs
    for epoch = 1:n_max
        
       % iterate on examples
       for i = 1:P
           example = X(i, :);
           label = y(i);

           if (example * w) * label <= 0
                w = w + (example' * label) / N;
           else
               % no-op: the classification for the current example was
               % correct, no need to update the weights
           end
       end

       % exit if all examples are correctly classified
       classification = (X * w) .* y;
       if all(classification > 0)
            break;
       end
    end
    
    % we return the effective number of updates to complete the training
    n_updates = epoch * P;
end
