 function [X, y] = generate_dataset(P, N, w_star, lambda)
 
    %%GENERATE_DATASET Generate a dataset of points and binary labels.
    % The function returns a matrix PxN of P points in N dimensions,
    % where each row corresponds to a point and each column corresponds to
    % a feature, and a vector y with binary labels for each point.
    % The labels for each examples are choosen by a teacher vector w_star.
 
    switch nargin
        case 3
            lambda = 0;
    end
    
    prob = rand(P, 1);
        
    noise = iff(prob < lambda, -1, +1);
    
    % check the dimension of w_star
    assert(all(size(w_star) == [N, 1]));
    
    % generate random data and assign the labels according to w_star
    X = randn(P, N);
    y = sign(X * w_star) .* noise;
end
