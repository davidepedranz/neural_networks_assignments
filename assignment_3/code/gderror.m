function err = gderror(X, y, w1, w2)
    %GDERROR Compute the error over the entire given dataset (X, y) given
    %the weights w1, w2 of the neural network.

    [P, ~] = size(X);
    sigma = tanh(X * w1) + tanh(X * w2);
    err = sum((sigma - y).^2) / (2 * P);
end
