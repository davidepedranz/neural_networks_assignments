%-------------------------------------------------------
% Rosenblatt Perceptron Algorithm.
% Implement and simulate a base Rosennblatt Perceptron.
% This include the base assignment and bonus 1.
%-------------------------------------------------------

% clean the workspace
clf; close; close; close; close; close; close; close; close; close; close;
clear;

% settings
epochs = [50, 100, 200];                                  % n_max
% ns = [20, 50, 100, 500, 1000];                              % N
ns = [100, 200];
alphas = [0.75:0.25:1.5, 1.55:0.05:2.2, 2.25:0.25:3];       % alpha
repetitions = 100;                                          % n_D

% fix seed for the random number generator
rng(0);

% run all experiments (and cache the results)
cache = 'results/base.mat';
if (exist(cache, 'file'))
    fprintf('Loading results from cache "%s"...\n', cache);
    success_rates = importdata(cache);
else
    fprintf('Cache not found in "%s"... running the experiments\n', cache);
    
    tic
    len_epochs = length(epochs);
    len_alphas = length(alphas);
    len_ns = length(ns);
    success_rates = zeros(len_epochs, len_alphas, len_ns);
    for epoch = (1 : len_epochs)
        for alpha = (1 : len_alphas)
            for n = (1 : len_ns)
                success_rates(epoch, alpha, n) = run_experiment(alphas(alpha), ns(n), epochs(epoch), repetitions);
            end
        end
    end
    toc

    save('results/base.mat', 'success_rates');
end

mrk={'-o','-s','-*','-v','-+','-^'};
plot_base(success_rates, alphas, epochs, ns);
plot_multiple_epochs(success_rates, alphas, epochs, ns, mrk);
plot_multiple_n(success_rates, alphas, epochs, ns, mrk);

function plot_base(success_rates, alphas, epochs, ns)
    n_epochs = 200;
    N = 200;

    figure;
    box on;
    hold on;
    index_epochs = find(epochs == n_epochs);
    index_ns = find(ns == N);
    plot(alphas, success_rates(index_epochs, :, index_ns)); %#ok<FNDSB>
    hold off;
    set(gca, 'FontSize', 12)
    title('Storage Success Rate', 'FontSize', 14);
    xlabel('Alpha = P / N');
    ylabel('Success Rate');
    save_for_report('base');
end

function plot_multiple_epochs(success_rates, alphas, epochs, ns, mrk)
    N = 200;

    figure;
    box on;
    hold on;
    index_ns = find(ns == N);
    for i = 1:length(epochs)
        set(gca, 'LineStyleOrder', mrk(mod(i, length(mrk))));
        plot(alphas, success_rates(i, :, index_ns)); %#ok<FNDSB>
    end
    hold off;
    set(gca, 'FontSize', 12)
    title('Storage Success Rate', 'FontSize', 14);
    xlabel('Alpha = P / N');
    ylabel('Success Rate');
    legend(cellstr(num2str(epochs', 'epochs=%-d')));
    save_for_report('multiple_epochs');
end

function plot_multiple_n(success_rates, alphas, epochs, ns, mrk)
    n_epochs = 200;
    
    figure;
    box on;
    hold on;
    index_epochs = find(epochs == n_epochs);
    for n=1:length(ns)
        set(gca, 'LineStyleOrder', mrk(mod(n, length(mrk))));
        plot(alphas, success_rates(index_epochs, :, n));  %#ok<FNDSB>
    end
    hold off;
    set(gca, 'FontSize', 12)
    title('Storage Success Rate', 'FontSize', 14);
    xlabel('Alpha = P / N');
    ylabel('Success Rate');
    legend(cellstr(num2str(ns', 'N=%-d')));
    save_for_report('multiple_n');
end

function save_for_report(name)

    % reduce white spaces
    ax = gca;
    outerpos = ax.OuterPosition;
    ti = ax.TightInset; 
    left = outerpos(1) + ti(1);
    bottom = outerpos(2) + ti(2);
    ax_width = outerpos(3) - ti(1) - ti(3);
    ax_height = outerpos(4) - ti(2) - ti(4);
    ax.Position = [left bottom ax_width ax_height];

    % make size of PDF equal to the plot
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];

    % save to PDF
    print(gcf, strcat('../report/figures/', name), '-dpdf');
    print(gcf, strcat('results/', name), '-dpdf');
end
