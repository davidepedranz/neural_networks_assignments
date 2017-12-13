function X= generate_dataset(P, N)
    %%GENERATE_DATASET Generate a dataset of points and binary labels.
    % The function returns a matrix X PxN of P points in N dimensions,
    % where each row corresponds to a point and each column corresponds to
    % a feature, and a vector y with binary labels for each point.
    
    X = randn(P, N);
end