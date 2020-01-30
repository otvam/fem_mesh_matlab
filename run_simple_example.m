function run_simple_example()

close('all')
addpath('fem_utils')

% load
data_tmp = load('simple.mat');
data_2d = data_tmp.data_2d;
data_3d = data_tmp.data_3d;

% plot_param
plot_param.arrow_scale = 1.0;
plot_param.arrow_color = 'r';
plot_param.marker = 'x';
plot_param.face_color = [0.8 0.8 1.0];
plot_param.edge_color = 'k';
plot_param.edge_alpha = 1.0;
plot_param.face_alpha = 0.5;

% extract 2d data
data_2d.edge = parse_data_2d(data_2d.edge, plot_param);
data_2d.surface = parse_data_2d(data_2d.surface, plot_param);

% extract 3d data
data_3d.edge = parse_data_3d(data_3d.edge, plot_param);
data_3d.surface = parse_data_3d(data_3d.surface, plot_param);
data_3d.volume = parse_data_3d(data_3d.volume, plot_param);

% interpolation 2d
x = linspace(-0.15, +0.15, 25);
y = linspace(-0.15, +0.15, 25);
interp_2d(data_2d.surface, x, y);

% interpolation 2d
x = linspace(-0.15, +0.15, 25);
y = linspace(-0.15, +0.15, 25);
z = linspace(-0.15, +0.15, 25);
interp_3d(data_3d.volume, x, y, z);

% integral 2d
integral_2d(data_2d)

% integral 3d
integral_3d(data_3d)

end

function data = parse_data_2d(data, plot_param)

% geom
data.geom = extract_geom(data.geom);

% data
data.E_x = extract_data(data.geom, data.E_x, @mean);
data.E_y = extract_data(data.geom, data.E_y, @mean);
data.E = extract_data(data.geom, data.E, @mean);

% geom
figure()
plot_geom(data.geom, plot_param);
axis('equal')
grid('on')
xlabel('x [m]')
ylabel('y [m]')
title('Geometry')

% data
figure()
hold('on')
plot_data(data.geom, sum(data.E, 2));
axis('equal')
grid('on')
colorbar();
xlabel('x [m]')
ylabel('y [m]')
title('Electric Field [V/m]')

end

function data = parse_data_3d(data, plot_param)

% geom
data.geom = extract_geom(data.geom);

% data
data.E_x = extract_data(data.geom, data.E_x, @mean);
data.E_y = extract_data(data.geom, data.E_y, @mean);
data.E_z = extract_data(data.geom, data.E_z, @mean);
data.E = extract_data(data.geom, data.E, @mean);

% geom
figure()
plot_geom(data.geom, plot_param);
axis('equal')
grid('on')
view([45,45])
xlabel('x [m]')
ylabel('y [m]')
title('Geometry')

% data
figure()
hold('on')
plot_data(data.geom, sum(data.E, 2));
axis('equal')
grid('on')
view([45,45])
colorbar();
xlabel('x [m]')
ylabel('y [m]')
title('Electric Field [V/m]')

end

function interp_2d(data, x, y)

[x, y] = ndgrid(x, y);
x = x(:).';
y = y(:).';

pts = struct('x', x, 'y', y);
v_int = interp_data(data.geom, sum(data.E, 2), pts);

figure()
scatter(x, y, 5, v_int)
axis('equal')
grid('on')
colorbar();
xlabel('x [m]')
ylabel('y [m]')
title('Electric Field [V/m]')

end

function interp_3d(data, x, y, z)

[x, y, z] = ndgrid(x, y, z);
x = x(:).';
y = y(:).';
z = z(:).';

pts = struct('x', x, 'y', y, 'z', z);
v_int = interp_data(data.geom, sum(data.E, 2), pts);

figure()
scatter3(x, y, z, 5, v_int)
axis('equal')
grid('on')
view([45,45])
colorbar();
xlabel('x [m]')
ylabel('y [m]')
title('Electric Field [V/m]')

end

function integral_2d(data)

fprintf('2d\n')

int = struct('type', 'scalar', 'data', data.edge.E);
v = integrate_data(data.edge.geom, int);
fprintf('    edge / scalar = %s\n', mat2str(v, 3))

int = struct('type', 'tangential', 'data_x', data.edge.E_x, 'data_y', data.edge.E_y);
v = integrate_data(data.edge.geom, int);
fprintf('    edge / tangential = %s\n', mat2str(v, 3))

int = struct('type', 'normal', 'data_x', data.edge.E_x, 'data_y', data.edge.E_y);
v = integrate_data(data.edge.geom, int);
fprintf('    edge / normal = %s\n', mat2str(v, 3))

int = struct('type', 'scalar', 'data', data.surface.E);
v = integrate_data(data.surface.geom, int);
fprintf('    surface / scalar = %s\n', mat2str(v, 3))

end

function integral_3d(data)

fprintf('3d\n')

int = struct('type', 'scalar', 'data', data.edge.E);
v = integrate_data(data.edge.geom, int);
fprintf('    edge / scalar = %s\n', mat2str(v, 3))

int = struct('type', 'tangential', 'data_x', data.edge.E_x, 'data_y', data.edge.E_y, 'data_z', data.edge.E_z);
v = integrate_data(data.edge.geom, int);
fprintf('    edge / tangential = %s\n', mat2str(v, 3))

int = struct('type', 'scalar', 'data', data.surface.E);
v = integrate_data(data.surface.geom, int);
fprintf('    surface / scalar = %s\n', mat2str(v, 3))

int = struct('type', 'normal', 'data_x', data.surface.E_x, 'data_y', data.surface.E_y, 'data_z', data.surface.E_z);
v = integrate_data(data.surface.geom, int);
fprintf('    surface / normal = %s\n', mat2str(v, 3))

int = struct('type', 'scalar', 'data', data.volume.E);
v = integrate_data(data.volume.geom, int);
fprintf('    volume / scalar = %s\n', mat2str(v, 3))

end