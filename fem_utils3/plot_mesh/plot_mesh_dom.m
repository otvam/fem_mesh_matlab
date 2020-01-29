function plot_mesh_dom(geom, color, width)

assert(geom.is_2d==true, 'invalid geom');

xdata = geom.x(geom.tri).';
ydata = geom.y(geom.tri).';
zdata = zeros(size(geom.tri)).';

patch(xdata,ydata,zdata, 'FaceColor', 'none', 'EdgeColor',color, 'LineWidth', width);
    hold('on')

end