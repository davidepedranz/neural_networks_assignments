function w = train_perceptron(X, y, epochs)
    %%TRAIN_PERCEPTRON Train a perceptron on the dataset X, y for #epochs.
    % This implementation uses sequential training.
    
    assert(size(X, 1) == size(y, 1));
    assert(size(y, 2) == 1);
    
    N = size(X, 2);
    P = size(X, 1);
    
    w = zeros(N, 1);
    
    % repeat training for any epochs
    for epoch = 1:epochs
        
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
end
