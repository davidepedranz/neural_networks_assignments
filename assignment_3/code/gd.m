function [g1, g2] = gd(example, tau, w1, w2)
    %GD Compute the gradients of the error function for the given example
    %with respect to w1 and w1 (weights of the 2 hidden units).

    tanh_w1 = tanh(example * w1);
    tanh_w2 = tanh(example * w2);
    sigma = tanh_w1 + tanh_w2;
    g_comp = (sigma - tau) * example';
    g1 = g_comp * (1 - (tanh_w1 ^ 2));
    g2 = g_comp * (1 - (tanh_w2 ^ 2));
end
