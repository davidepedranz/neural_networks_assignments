function w = train_perceptron(X, epochs, c)
    %%TRAIN_PERCEPTRON Train a perceptron on the dataset X, y for #epochs.
    % This implementation uses sequential training.
    
    N = size(X, 2);
    P = size(X, 1);
    
    % in case o f inequal
    w = zeros(N, 1);
    k = ones(P, 1);
    no_update = false;
    old_stability = NaN;
    w_star = ones(N,1);
    
    % repeat training for any epochs
    for epoch = 1:epochs
        
       % iterate on examples
       for i = 1:P
           example = X(i, :);
           label = sign(example * w_star);
           
           for j = 1:P
               k(j) = ((example * w) * label)/norm(w);
           end
           
           [stability, index] = min(k);
           
           if stability == old_stability
               no_update = true;
               break;
           else
               old_stability = stability;
           end
           
           w = w + (X(index, :)' * y(index)) / N;
           
       end
       
       if no_update == true
           break;
       end
    end
end
