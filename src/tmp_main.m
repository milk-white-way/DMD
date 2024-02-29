clearvars; close all; clc;
fprintf('\n DYNAMIC MODE DECOMPOSITION: START \n');

ENABLE_DMD = 1;
ENABLE_SPECTRUM = 0;
ENABLE_PLOTTING = 0;

working_dir = '.';
str_frame = 12000;
end_frame = 16000;
tempo_res = 20;

%% assembling data:
%{
prompt  = ('\n requesting aneurysm id: ');
anid    = input(prompt, 's');
%}
anid = '75';

fprintf('\n ======= aneurysm id: %s ======== \n', anid);

tic
if ENABLE_DMD
    fprintf('\n ======= assembling data: start ======== \n');
    % objective: pull data from text file to matlab workspace
    % 	table data in text file contains six column:
    % 		first three columns are velocity along x, y, z, respectively
    % 		final three columns are coordinates in x, y, z, respectively
    % function: tmp_assembledata()
    % 	input: none (need to change the code accordingly)
    % 	output:
    % 		velmat: stacked velocity matrix (top-down: velx-velz)
    % 		coordx: x-coordinate of point data
    % 		coordy: y-coordinate of point data
    % 		coordz: z-coordinate of point data

    temporalspc = str_frame:tempo_res:end_frame;

    [velmat, coordx, coordy, coordz, numstance, pathname] = tmp_assembledata(anid, working_dir, temporalspc);
    fprintf('\n ======== assenbling data: complete ======== \n');

    %% Setting 1. Grid
    %{
    str_1 = [" low"; " high"; " low"; " high"; " low"; " high"];
    str_2 = [" x"; " x"; " y"; " y"; " z"; " z"];
    % Table of grid size for all cases at no coarsening scale
    extractSubset = zeros(1,6);
    for injectStep = 1:6
        official_prompt = strcat('requesting subset''s ', str_1(injectStep), ' bound in ', str_2(injectStep), '-direction: ');
        getm = input(official_prompt);
        extractSubset(injectStep) = getm;
    end
    %}
    extractSubset = [30, 195, 75, 185, 110, 225];

    % resolution scale
    %rs = input('requesting resolution scale: '); rs = 1/rs;
    rsx = 1/2;
    rsy = 1/2;
    rsz = 1;

    % size of the grid
    nx = floor( rsx*( extractSubset(2) - extractSubset(1) ) )+1;
    fprintf('set \t # of point in x-direction = %i\n', nx);
    ny = floor( rsy*( extractSubset(4) - extractSubset(3) ) )+1;
    fprintf('set \t # of point in y-direction = %i\n', ny);
    nz = floor( rsz*( extractSubset(6) - extractSubset(5) ) )+1; 
    fprintf('set \t # of point in z-direction = %i\n', nz);

    %% Setting 2. DMD
    % number of levels
    lv = 1;             fprintf('set \t number of level = %i\n',lv); 
    % rank of trunctation
    rt = 201;           fprintf('set \t rank of truncation = %i\n',rt);
    % total time (seconds)
    tt = 0.83;          fprintf('set \t simulation time = %.4f s\n',tt);
    % time of sampled cardiac cycle (seconds)
    dt = tt/numstance;  fprintf('set \t simulation timestep = %.4f s\n',dt);
    % cut-off frequency
    cf = 200;           fprintf('set \t cut-off frequency = %i \n',cf);

    %% Implementing dynamic mode decomposition (dmd):
    fprintf('\n ======== decompositioning: start ======== \n');
    % objective:
    % function: tmp_mrdmd()
    % 	input:
    % 		1. velmat (see above)
    % 		2. length of cardiac cycle
    % 		3. rank of truncation
    % 		4. cut-off frequency
    % 		5. number of levels
    % 	output:
    % 		dmdmat
    dmdmat = tmp_mrdmd(velmat, tt, dt, rt, cf, lv);
    fprintf('\n ======== decompositioning: complete ======== \n');
    
    %% compiling visualization of multires mode amplitudes:
    fprintf('\n ======== mapping data for visualization: start ======== \n');
    [dmdmap, lowfreq] = tmp_mrdmdmap(dmdmat);
    
    %% saving analysis as matdata and clearing workspace:
    fprintf('\n ======== mapping: complete, saving data: start ======== \n');

    savepath = strcat(working_dir, '/dmd_output/', anid, ...
        '_spatialCoarse', num2str(1/rsx), '-', num2str(1/rsy), '-', num2str(1/rsz), ...
        '_temporalFrame', num2str(numstance), '_DMD_result.mat');
	save(savepath, ...
		'numstance', ...
		'dmdmat', ...
		'rt', ...
		'tt', ...
		'dt', ...
		'dmdmap', ...
		'lowfreq', ...
		'coordx', ...
		'coordy', ...
		'coordz', ...
		'nx', ...
		'ny', ...
		'nz', ...
		'-v7.3');
	savelist = {'visualization data', ...
		'number of instances', ...
		'rank of truncation', ...
		'total simulation time', ...
		'time step', ...
		'dmd data', ...
		'cut-off frequency', ...
		'x-coordinate', ...
		'y-coordinate', ...
		'z-coordinate', ...
		'x-dimension size', ...
		'y-dimension size', ...
		'z-dimension size'};
	for iter = 1:length(savelist)
		fprintf('save \t %s \n', savelist{iter});
	end
    fprintf('\n ======== saving data: complete ======== \n');

    clearvars -except working_dir anid ENABLE_SPECTRUM ENABLE_PLOTTING
else
    fprintf('\n ======== skipping dmd module ======== \n');
end

%% checking for spectrum analysis signal
if ENABLE_SPECTRUM
    %% loading saved data:
    loadpath = strcat(working_dir, '/dmd_output/', num2str(anid), ...
        '_spatialCoarse', num2str(1/rsx), '-', num2str(1/rsy), '-', num2str(1/rsz), ...
        '_temporalFrame', num2str(numstance), '_DMD_result.mat');
    savepath = strcat(working_dir, '/dmd_output/', num2str(anid), ...
        '_spatialCoarse', num2str(1/rsx), '-', num2str(1/rsy), '-', num2str(1/rsz), ...
        '_temporalFrame', num2str(numstance), '_SPECTRUM_result.mat');
    fprintf('\n ======== loading analyzed data: start ======== \n');
    load(loadpath);
    [rowsize, colsize] = size(dmdmat);
    
    %% exporting to vtk files:
    fprintf('\n ======== loading data: complete ======== \n');
    tmp_export
else
    fprintf('\n ======== skipping spectrum module ======== \n');
end

if ENABLE_PLOTTING
    tmp_energyspectrum
else
    fprintf('\n ======== skipping plotting module ======== \n');
end
toc

fprintf('\n DYNAMIC MODE DECOMPOSITION: FINISHED \n');
