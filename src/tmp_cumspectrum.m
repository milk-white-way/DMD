%% state ids for export data
close all; clear all; clc;
spectrumid = {'02', '14', '16', '36'};
markerlist = {'--o', '-.v', '--s', '-.h'};
x = linspace(0, 20, 20); x = x';

%% prepare figure
figure('Renderer', 'painters', ...
    'Position', [0 0 800 600]);
fig = gcf;
ax  = gca;
hold all;
y = 0.99 + 0*x;
a = plot(ax, x, y, 'LineWidth', 2);
xlabel(ax, 'Mode (k)');
ylabel(ax, 'RIC');
grid minor;

%% iterative plot
for iter = 1:length(spectrumid)
    specflpath = strcat('./visualfile/', spectrumid{iter}, ...
        'an/', spectrumid{iter}, 'an_cummulative_spectrum.fig');
    figure = openfig(specflpath);
    line = findobj(figure, 'Type', 'line');
    xdata = get(line, 'xdata');
    ydata = get(line, 'ydata');
    plot(ax, xdata, ydata, markerlist{iter}, ...
        'LineWidth', 2);
end
uistack(a, 'top');
legend(ax, ...
    'Patient c0002', ...
    'Patient c0014', ...
    'Patient c0016', ...
    'Patient c0036', ...
    '99% total energy', ...
    'Location', 'southeast');

hold off;