function lr = lrpcycle2(eta, max_lr, step_size)

    lr = @(iteration) eta + (max_lr-eta)* ...
        max(0, (1-abs(iteration/step_size - 2*floor(1+iteration/(2*step_size)) + 1)))/ ...
        ((2*(floor(1+iteration/(2*step_size))))-1);
end

