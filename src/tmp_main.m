clear all; close all; clc;
fprintf('\n DYNAMIC MODE DECOMPOSITION: START \n');

%% assembling data:
tic
prompt  = ('\n requesting aneurysm id: ');
anid    = input(prompt, 's');
fprintf('\n ======= aneurysm id: %s ======== \n', anid);
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
[velmat, ...
    coordx, ...
    coordy, ...
    coordz, ...
    numstance, ...
    pathname] = tmp_assembledata(anid);
fprintf('\n ======== assenbling data: complete ======== \n');
%% including parameter file:
fprintf('\n ======== loading parameters: start ======== \n');
% parameters loaded:
% 		1. size of grid
% 		2. length of cardiac cycle
% 		3. number of levels
% 		4. rank of truncation
% 		5. simulation time
% 		6. cut-off frequency
tmp_param
fprintf('\n ======== parameters loaded ======== \n');
%% checking for dmd analysis signal
if strcmp(mrdmdsign, 'x')
    %% implementing dynamic mode decomposition (dmd):
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
    tmp_savedata
    clearvars -except spectsign plottsign pathname top
    fprintf('\n ======== saving data: complete ======== \n');
else
    fprintf('\n ======== skipping dmd module ======== \n');
end

%% checking for spectrum analysis signal
if strcmp(spectsign, 'x')
    %% loading saved data:
    fprintf('\n ======== loading analyzed data: start ======== \n');
    datapath = strcat(pathname(1:24), 'analysis_result.mat');
    load(datapath);
    [rowsize, colsize] = size(dmdmat);
    
    %% exporting to vtk files:
    fprintf('\n ======== loading data: complete ======== \n');
    tmp_export
else
    fprintf('\n ======== skipping spectrum module ======== \n');
end

if strcmp(plottsign, 'x')
    tmp_energyspectrum
else
    fprintf('\n ======== skipping plotting module ======== \n');
end
toc

fprintf('\n DYNAMIC MODE DECOMPOSITION: FINISHED \n');
