function [map, lowfreqcutoff] = tmp_mrdmdmap(mat)

%% what is this? 
[levels, m] 	= size(mat);
map 		= zeros(levels, m);
lowfreqcutoff 	= zeros(levels+1, 1);

for iter1 = 1:levels
	chunks = 2^(iter1-1);
	k = m/chunks;
	for iter2 = 1:chunks
		f = abs(imag(mat{iter1, iter2}.omega));
		p = mat{iter1, iter2}.p;

		p = p(f >= lowfreqcutoff(iter1));
		if ~isempty(p)
			map(iter1, (1:k)+(iter2-1)*k) = mean(p);
		end
	end
	lowfreqcutoff(iter1+1) = mat{iter1,1}.rho;
end

%% ending function:
end
