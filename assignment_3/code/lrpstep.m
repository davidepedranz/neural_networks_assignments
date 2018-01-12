function lr = lrpstep(eta, stepsize, drop)
    %LRPSTEP: implement the "step" learning strategy (see the report)

    lr = @(iteration) max(eta - (drop * (floor(iteration / stepsize))), drop);
end
