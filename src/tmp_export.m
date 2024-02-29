%% Cleaning visual folder:
deletesign = 1;
for level = 1:rowsize
	numbin = 2.^(level-1);
	for bin = 1:numbin
		currcell = dmdmat{level, bin};
		omega 	 = currcell.omega;
		nummodes = size(omega, 1);

		spectrum{level, bin}.omega = currcell.omega;
		spectrum{level, bin}.power = currcell.p;
		spectrum{level, bin}.sigma = currcell.sigma;
		spectrum{level, bin}.lambda= currcell.lambda;
		spectrum{level, bin}.b     = currcell.b;
		for iter = 1:nummodes
            filename = sprintf('%sdmd_mode_m%d_b%d_l%d.vtk', ...
                anid, iter, bin, level);
            visualflpath = strcat(working_dir, '/vtk_output');
            fullfilename = strcat(visualflpath, '/', filename);
            if deletesign == 1
                delete(strcat(visualflpath, '/*'));
                deletesign = 0;
            end
			
			phi 	 = currcell.phi;
			mymode   = phi(:, iter);
			mysize 	 = length(mymode)/2;

			% Export velocity field
			currmode = mymode(1:mysize);
			numpoint = length(coordx);
			ux 	 = currmode(1:numpoint);
			uy 	 = currmode(numpoint+1:2*numpoint);
			uz 	 = currmode(2*numpoint+1:end);

			velx = reshape(ux, nx, ny, nz);
			vely = reshape(uy, nx, ny, nz);
			velz = reshape(uz, nx, ny, nz);

			umag = sqrt(velx.^2 + vely.^2 + velz.^2);
			x 	 = reshape(coordx, nx, ny, nz);
			y 	 = reshape(coordy, nx, ny, nz);
			z 	 = reshape(coordz, nx, ny, nz);

			Write_To_VTK(fullfilename, ...
				x, ...
				y, ...
				z, ...
				velx, ...
				vely, ...
				velz);
		end
	end
end

save(savepath, 'spectrum', '-v7.3');