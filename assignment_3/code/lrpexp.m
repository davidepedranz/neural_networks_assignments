function lr = lrpexp(eta, stepsize, drop)
    lr = @(iteration) eta * drop ^ (iteration / stepsize);
end

