%% processing data for dmd analyses:
spectrumpath = strcat(pathname(1:21), 'spectrum.mat');
load(spectrumpath);

mycell 	  = spectrum{1, 1};
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

figure('Renderer', 'painters')%, ...
%    'Position', [100 100 1920 1080]);
fig1 = gcf;
ax1  = gca;
loglog(modeindex, sigmanormal, '-', ...
    'LineWidth', 2);
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