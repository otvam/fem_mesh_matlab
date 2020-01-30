function run_bridge_example()

close('all')
addpath('fem_mesh_utils')

% load
data_tmp = load('model_bridge/bridge.mat');
data_edge = data_tmp.data_edge;
data_surface = data_tmp.data_surface;

% parse
[geom_edge, geom_deform_edge, disp_edge] = parse_data(data_edge, 100.0);
[geom_surface, geom_deform_surface, disp_surface] = parse_data(data_surface, 100.0);

keyboard

% plot_param
plot_param.arrow_scale = 1.0;
plot_param.arrow_color = 'r';
plot_param.marker = 'x';
plot_param.face_color = [0.8 0.8 1.0];
plot_param.edge_color = 'k';
plot_param.edge_alpha = 1.0;
plot_param.face_alpha = 0.5;

keyboard

end

function [geom, geom_deform, disp] = parse_data(data, scale)

geom = deform_geometry(data, 0.0);
geom_deform = deform_geometry(data, scale);
disp = extract_data(geom, data.disp, @mean);

end

function geom = deform_geometry(data_fem, scale)

geom_fem = data_fem.geom_fem;

geom_fem.pts = geom_fem.pts+scale.*data_fem.disp_mat;

geom = extract_geom(geom_fem, false);

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