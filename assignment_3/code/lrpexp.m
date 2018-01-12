function lr = lrpexp(eta, stepsize, drop)
    %LRPEXP: implement the "exponential" learning strategy (see the report)
    
    lr = @(iteration) eta * drop ^ (iteration / stepsize);
end

