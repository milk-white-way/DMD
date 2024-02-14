close all; clc;
clearvars;

%H1 = openfig('figfile\RIC_aneu02_NEW_2x_201f_full_loglog.fig');
%H2 = openfig('figfile\RIC_aneu14_NEW_2x_201f_full_loglog.fig');
%H3 = openfig('figfile\RIC_aneu16_NEW_2x_201f_full_loglog.fig');
%H4 = openfig('figfile\RIC_aneu36_NEW_2x_201f_full_loglog.fig');
%H5 = openfig('figfile\RIC_aneu42_NEW_2x_201f_full_loglog.fig');
%H6 = openfig('figfile\RIC_aneu75_NEW_2x_201f_full_loglog.fig');

H1 = openfig('figfile\RIC_aneu02_NEW_2x_41f_FIG.fig');
H2 = openfig('figfile\RIC_aneu14_NEW_2x_41f_FIG.fig');
H3 = openfig('figfile\RIC_aneu16_NEW_2x_41f_FIG.fig');
H4 = openfig('figfile\RIC_aneu36_NEW_2x_41f_FIG.fig');
H5 = openfig('figfile\RIC_aneu42_NEW_2x_41f_FIG.fig');
H6 = openfig('figfile\RIC_aneu75_NEW_2x_41f_FIG.fig');

pause;

figure;
gcf;
hAxes = axes;
h = findobj([H6, H5, H4, H3, H2, H1], 'type', 'line');
copyobj(h, hAxes);
    grid on;
    set(hAxes, 'XScale', 'log', 'YScale', 'log');