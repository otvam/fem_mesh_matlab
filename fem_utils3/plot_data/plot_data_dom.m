function plot_data_dom(ax, geom, data)

assert(geom.is_2d==true, 'invalid geom');

xdata = geom.x(geom.tri).';
ydata = geom.y(geom.tri).';
zdata = zeros(size(geom.tri)).';

p = patch(ax, xdata,ydata,zdata);

vec = get(p,'Vertices');
idx = knnsearch([geom.x ; geom.y].',vec);
v_unique = data(idx);

set(p,...
    'FaceColor','interp',...
    'FaceVertexCData',v_unique,...
    'EdgeColor','none',...
    'CDataMapping','scaled');
hold('on')

end