function tree = tmp_mrdmd(xraw, tt, dt, rt, cf, lv)

%% total simulation time:
% The total simulation time is calculated by multiplying the number of snapshots by timestep
% unit: s
%tt = size(xraw, 2)*dt; 		fprintf('debug \t total simulation time = %.3f s\n', tt);

%% high frequency cut-off at this level:
% The ? is calculated by divide the input cut-off frequency by total simulation time
% unit: ?
rho = cf/tt; 			fprintf('debug \t high frequency cut-off = %.3f \n', rho);

%% 4x Nyquist for rho:
% ?
sub = ceil(1/rho/8/pi/dt);

%% DMD at this level:
% The initial velocity matrix 
xaug = xraw(:, 1:sub:end);
xaug = [xaug(:, 1:end-1)
	xaug(:, 2:end)];
x = xaug(:, 1:end-1);
xp = xaug(:, 2:end);

[u, s, v] = svd(x, 'econ');
r = min(size(u, 2), rt);

%% rank truncation:
ur = u(:, 1:r);
sr = s(1:r, 1:r);
vr = v(:, 1:r);

atilde = ur' * xp * vr / sr;
[w, d] = eig(atilde);
lambda = diag(d);
phi = xp * v(:,1:r) / s(1:r, 1:r) * w;

%% compute power of modes:
vandermondemat = zeros(r, size(x, 2));
for iter = 1:size(x, 2)
	vandermondemat(:, iter) = lambda.^(iter-1);
end

%% Jovanovic et al., 2014:
g = sr*vr';
p = (w'*w).*conj(vandermondemat*vandermondemat');
q = conj(diag(vandermondemat*g'*w));
pl = chol(p, 'lower');
b = (pl')\(pl\q);

%% reconstruct the modes:
psi = diag(b)*vandermondemat;

%% consolidate slow modes, where abs(omega) < rho:
omega           = log(lambda)/sub/dt/2/pi;
modes           = find(abs(omega)) <= rho;

currlv.tt       = tt;
currlv.rho      = rho;
currlv.hit      = numel(modes)>0;
currlv.omega 	= omega(modes);
currlv.p        = abs(b(modes));
currlv.phi      = phi(:, modes);
currlv.sigma 	= diag(s);
currlv.lambda 	= lambda;
currlv.b        = b;

%% recurse on halves:
if lv > 1
	sep = floor(size(xraw, 2)/2);
	nextlv1 = tmp_mrdmd(xraw(:, 1:sep), tt, dt, rt, cf, lv-1);
	nextlv2 = tmp_mrdmd(xraw(:, sep+1:end), tt, dt, rt, cf, lv-1);
else
	nextlv1 = cell(0);
	nextlv2 = cell(0);
end

%% reconcile indexing on output:
% because MATLAB does not support recursive data structures
tree = cell(lv, 2^(lv-1));
tree{1,1} = currlv;
for iter1 = 2:lv
	col = 1;
	for iter2 = 1:2^(iter1-2)
		tree{iter1, col} = nextlv1{iter1 - 1, iter2};
		col = col + 1;
	end
	for iter3 = 1:2^(iter1-2)
		tree{iter1, col} = nextlv2{iter1 - 1, iter3};
		col = col + 1;
	end
end

%% ending function:
end
