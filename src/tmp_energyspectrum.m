%% processing data for dmd analyses:
function tmp_energyspectrum(spectrumpath, numstance, top)
    mystruct = load(spectrumpath);

    mycell 	  = mystruct.spectrum{1, 1};
    lambdak   = mycell.lambda;
    myomega   = mycell.omega;
    mysigma   = mycell.sigma;
    r       = length(lambdak);
    bk 	  = mycell.b;
    mybk    = bk(1:length(myomega));
    mylambda  = lambdak(1:length(myomega));
    mysigma   = mysigma(1:length(myomega));
    vandemat  = zeros(r, numstance);
    for iter1 = 1:numstance
        vandemat(:, iter1) = lambdak.^(iter1-1);
    end
    time_dynamics = diag(bk)*vandemat;

    powerlambd = abs(mybk .* mylambda .^ numstance);
    powerscale = abs(mybk);

    for iter2 = 1:length(myomega)
        freq(iter2) = imag(myomega(iter2));
        pows(iter2) = powerscale(iter2);
        powl(iter2) = powerlambd(iter2);
    end

    %% plotting:
    reallambd = real(mylambda);
    imaglambd = imag(mylambda);

    datatable = table(freq', ...
        powl', ...
        pows', ...
        reallambd, ...
        imaglambd, ...
        mysigma);

    outputnm  = strcat('an02_result.csv');
    writetable(datatable, outputnm, 'WriteRowNames', false);

    myfreq = freq'; mypowl = powl'; mypows = pows';

    %% sorting?
    [ire, idx] = sort(mypows, 'descend');
    sortfreq= myfreq(idx);

    numfreq = idx; 
    topfreq = sortfreq(1:top);
    topnumb = numfreq(1:top);
    matfreq = [topfreq topnumb]

    sigmacumsum = cumsum(mysigma);

    sigmanormal = sigmacumsum./max(sigmacumsum);
    modeindex = 1:length(sigmanormal);
    modeindex = modeindex./max(modeindex);

    % Determine the number of data points to use for the fit
    numPoints = round(0.1 * length(sigmanormal));

    % Extract the first 10% of the data
    xData = modeindex(1:numPoints);
    yData = log(sigmanormal(1:numPoints));

    % Fit a linear curve to the data
    p = polyfit(xData, yData, 1);

    % Generate y-values based on the fit
    yFit = polyval(p, xData);

    figure('Renderer', 'painters')%, ...
    %    'Position', [100 100 1920 1080]);
    fig1 = gcf;
    ax1  = gca;
    loglog(modeindex, sigmanormal, 'o', ...
        'LineWidth', 2);
    hold on;

    % Plot the fitted line
    plot(xData, yFit, 'r-', 'LineWidth', 2);
    slope = p(1);
    text(0.1, 0.1, ['Slope = ', num2str(slope)], 'Units', 'normalized');
    grid minor;
    
    figure('Renderer', 'painters')%, ...
    %    'Position', [100 100 1080 1080]);
    fig2 = gcf;
    ax2  = gca;
    tmp_unitcircle(0, 0, 1, ax2); hold on;
    plot(reallambd, imaglambd, 'r o', 'LineWidth', 1);
    xlim([-1.5 1.5]);
    ylim([-1.5 1.5]);
    grid minor;
    set(ax2, 'XTick', linspace(-1, 1, 3));
    set(ax2, 'XTicklabel', {'-1', '0', '1'});
    set(ax2, 'YTick', linspace(-1, 1, 3));
    set(ax2, 'YTicklabel', {'-1', '0', '1'});
end