function [matxdata, ...
    coordx, ...
    coordy, ....
    coordz, ...
    numstance, ...
    pathdata] = tmp_assembledata(id)

tempspace = 12000:20:16000;
numstance = length(tempspace); fprintf('debug \t number of instances = %i\n',numstance);
addzerofin = 10000;
aneurysmid = id;

matxdata = [];

for mytime = 1:numstance
	namedata = num2str(tempspace(mytime)); 
	if tempspace(mytime) < addzerofin
		namedata = ['0' namedata];
	end
	pathdata = strcat('./datafile/', ...
        aneurysmid, 'an/', ...
        'aneu', aneurysmid, '_dmd_inputdata_', namedata, '.csv');
	loaddata = readmatrix(pathdata);

	matveloc = [];
	matveloc = [loaddata(:,1)
		loaddata(:,2)
		loaddata(:,3)];
	%matveloc = loaddata(:,5);
	
	matxdata = [matxdata matveloc];

	if mytime==1
		coordx = loaddata(:,4);
		coordy = loaddata(:,5);
		coordz = loaddata(:,6); 
	end
end
