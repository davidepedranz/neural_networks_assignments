%-------------------------------------------------------
% Rosenblatt Perceptron Algorithm.
% Bonus 3: homogeneous vs inhomogeneous perceptrons.
%-------------------------------------------------------

% clean the workspace
clf; close; close; close; close; close; close; close; close; close; close;
clear;

% settings
epochs = 200;                                           % n_max
N = 500;                                                % N
alphas = [0.75:0.25:1.5, 1.55:0.05:1.95, 2:0.25:3];     % alpha
repetitions = 200;                                      % n_D
homogeneous = [true, false];

% fix seed for the random number generator
rng(0);

% run all experiments (and cache the results)
cache = 'results/bonus_3.mat';
if (exist(cache, 'file'))
    fprintf('Loading results from cache "%s"...\n', cache);
    success_rates = importdata(cache);
else
    fprintf('Cache not found in "%s"... running the experiments\n', cache);
    
    len_h = length(homogeneous);
    len_alphas = length(alphas);
    success_rates = zeros(len_h, len_alphas);
    tic
    for h = (1 : len_h)
        for alpha = (1 : len_alphas)
            success_rates(h, alpha) = run_experiment(alphas(alpha), N, epochs, repetitions, 0, homogeneous(h));
        end
    end
    toc

    save('results/bonus_3.mat', 'success_rates');
end

mrk={'-o','-s','-*','-v','-+','-^'};
plot_homogeneous(success_rates, alphas, homogeneous, mrk);

function plot_homogeneous(success_rates, alphas, homogeneous, mrk)
    figure;
    box on;
    hold on;
    for h = 1:length(homogeneous)
        set(gca, 'LineStyleOrder', mrk(mod(h, length(mrk))));
        plot(alphas, success_rates(h, :));
    end
    hold off;
    set(gca, 'FontSize', 12)
    title('Storage Success Rate', 'FontSize', 14);
    xlabel('Alpha = P / N');
    ylabel('Success Rate');
    legend(cellstr(num2str(homogeneous', 'homogeneous=%-d')));
    save_for_report('multiple_epochs');
end
