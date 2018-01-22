function lr = lrpstep(eta, stepsize, drop)
    lr = @(iteration) max(eta - (drop * (floor(iteration / stepsize))), drop);
end
