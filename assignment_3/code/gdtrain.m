function [w1, w2, err_calc_time, train_error, test_error, lr] = gdtrain(X_train, y_train, X_test, y_test, t_max, eta)
    [P, N_dim] = size(X_train);
    
%   Initialization of the weights' vectors with norm = 1
    w1 = rand(N_dim, 1);
    w1 = w1/norm(w1);
    w2 = rand(N_dim, 1);
    w2 = w2/norm(w2);
        
    err_calc_time = zeros(t_max + 1, 1);
    train_error = zeros(t_max + 1, 1);
    test_error = zeros(t_max + 1, 1);
    train_error(1) = gderror(X_train, y_train, w1, w2);
    test_error(1) = gderror(X_test, y_test, w1, w2);

    
    for epoch = 1:(t_max*P)

        if (mod(epoch, P) == 0)
            cur_epoch = ceil(epoch/P) + 1;
            err_calc_time(cur_epoch) = epoch;
            train_error(cur_epoch) = gderror(X_train, y_train, w1, w2);
            test_error(cur_epoch) = gderror(X_test, y_test, w1, w2);
        end
        ind = randi(P); 
        example = X_train(ind, :);
        tau = y_train(ind);
        
        [g1, g2] = gd(example, tau, w1, w2);
        
%     Update the learning rate
        lr(epoch) = eta(epoch);
        
        w1 = w1 - lr(epoch) * g1;
        w2 = w2 - lr(epoch) * g2;
    end
end

