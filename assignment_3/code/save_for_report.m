function save_for_report(name, axs, extra_margin)
    switch nargin
        case 1
            axs = gca;
            extra_margin = 0;
        case 2
            extra_margin = 0;
    end

    % make sure the needed folders are available
    mkdir('results');
    mkdir('../report/figures');

    % reduce white spaces
    for ax = axs
        outerpos = ax.OuterPosition;
        ti = ax.TightInset; 
        left = outerpos(1) + ti(1);
        bottom = outerpos(2) + ti(2);
        right = outerpos(3) - ti(1) - ti(3) - extra_margin;
        top = outerpos(4) - ti(2) - ti(4);
        ax.Position = [left bottom right top];
    end

    % make size of PDF equal to the plot
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];

    % save to PDF
    print(gcf, strcat('../report/figures/', name), '-dpdf');
    print(gcf, strcat('results/', name), '-dpdf');
end
