function lr = lrpstep(eta, stepsize, drop)
    lr = @(iteration) eta * drop ^ (floor(iteration/stepsize));
end
