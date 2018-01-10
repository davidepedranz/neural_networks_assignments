function lr = lrpcycle(eta, step_size, max_eta)
    lr = @(iteration) eta + (max_eta-eta)*max(0, (1-(abs(iteration/step_size - 2*floor(1+iteration/(2*step_size)) + 1))));
end

