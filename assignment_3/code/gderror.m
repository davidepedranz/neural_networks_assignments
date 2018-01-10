function err = gderror(X, y, w1, w2)
    [P, ~] = size(X);
    sigma = tanh(X * w1) + tanh(X * w2);
    err = sum((sigma - y).^2) / (2 * P);
end
