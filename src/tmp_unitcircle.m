function tmp_unitcircle(x, y, r, ax)
ang = 0:0.001:2*pi; 
xp  = r*cos(ang);
yp  = r*sin(ang);
plot(ax, x+xp, y+yp, 'LineWidth', 4);
end