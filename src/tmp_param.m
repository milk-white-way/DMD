%% enabling modules
mrdmdsign = 'x';    % x: enable % -, o: disable
if strcmp(mrdmdsign, 'x')
    fprintf('set \t process dmd analysis = true\n');
else
    fprintf('set \t process dmd analysis = false\n');
end
spectsign = 'x';
if strcmp(spectsign, 'x')
    fprintf('set \t process spectrum analysis = true\n');
else
    fprintf('set \t process spectrum analysis = false\n');
end
plottsign = 'x';
if strcmp(plottsign, 'x')
    fprintf('set \t process plotting = true\n');
else
    fprintf('set \t process plotting = false\n');
end

str_1 = ["low" "high" "low" "high" "low" "high"];
str_2 = ["x" "x" "y" "y" "z" "z"];
%% Table of grid size for all cases at no coarsening scale
extractSubset = zeros(1,6);
for injectStep = 1:6
    official_prompt = strcat(["requesting subset's "], str_1(injectStep), [" bound in "], str_2(injectStep), ["-direction: "]);
    getm = input(official_prompt);
    extractSubset(injectStep) = getm;
end

%% resolution scale
rs = input('requesting resolution scale: '); rs = 1/rs;

%% size of the grid
nx = floor( rs*( extractSubset(2) - extractSubset(1) ) )+1; fprintf('set \t # of point in x-direction = %i\n',nx);
ny = floor( rs*( extractSubset(4) - extractSubset(3) ) )+1; fprintf('set \t # of point in y-direction = %i\n',ny);
nz = floor( rs*( extractSubset(6) - extractSubset(5) ) )+1; fprintf('set \t # of point in z-direction = %i\n',nz);

%% number of levels
lv = 1;             fprintf('set \t number of level = %i\n',lv); 

%% rank of trunctation
rt = 201;             fprintf('set \t rank of truncation = %i\n',rt);

%% total time (seconds)
tt = 0.83;          fprintf('set \t simulation time = %.4f s\n',tt);

%% time of sampled cardiac cycle (seconds)
dt = tt/numstance;  fprintf('set \t simulation timestep = %.4f s\n',dt);

%% cut-off frequency
cf = 200;           fprintf('set \t cut-off frequency = %i \n',cf);

%%
top = 21;
%% save signal
savesign = 1;
