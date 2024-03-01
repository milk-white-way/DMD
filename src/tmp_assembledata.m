function [matxdata, ...
    coordx, ...
    coordy, ....
    coordz] = tmp_assembledata(id, dir, tempspace, numstance)

    addzerofin = 10000; % Set the maximum number of frames to read
    aneurysmid = id;

    matxdata = [];

    for mytime = 1:numstance
        namedata = num2str(tempspace(mytime)); 
        if tempspace(mytime) < addzerofin
            namedata = ['0' namedata];
        end
        pathdata = strcat(dir, '/database/', ...
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
end
