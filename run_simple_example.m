function run_simple_example()
%RUN_SIMPLE_EXAMPLE Test the toolbox with a 2d and 3d electrostatic simulation.
%
%   This example is meant to systemically test/demonstrates the different functions.
%   The example 'run_bridge_example' is meant to show-off the toolbox with a complex model.
%
%   Please note that the plotted/computed data don't have any phyical meaning.
%
%   See also RUN_EXTRACT_COMSOL, RUN_BRIDGE_EXAMPLE, EXTRACT_GEOM, EXTRACT_DATA, PLOT_GEOM, PLOT_DATA, INTERP_DATA, INTEGRATE_DATA.

%   Thomas Guillod.
%   2020 - BSD License.

close('all')
addpath('fem_mesh_utils')

%% load
data_tmp = load('model_simple/simple.mat');
data_2d = data_tmp.data_2d;
data_3d = data_tmp.data_3d;

%% extract and plot the geometry

% extract 2d
data_2d.edge = parse_data_2d(data_2d.edge);
data_2d.surface = parse_data_2d(data_2d.surface);

% extract 3d
data_3d.edge = parse_data_3d(data_3d.edge);
data_3d.surface = parse_data_3d(data_3d.surface);
data_3d.volume = parse_data_3d(data_3d.volume);

%% interpolate the data

% interpolation 2d
x = linspace(-0.15, +0.15, 25);
y = linspace(-0.15, +0.15, 25);
interp_2d(data_2d.surface, x, y);

% interpolation 2d
x = linspace(-0.15, +0.15, 25);
y = linspace(-0.15, +0.15, 25);
z = linspace(-0.15, +0.15, 25);
interp_3d(data_3d.volume, x, y, z);

%% integrate the data

% integral 2d
integrate_2d(data_2d)

% integral 3d
integrate_3d(data_3d)

end

function data = parse_data_2d(data_fem)
%PARSE_DATA_2D Parse a 2d geometry, the associated data, and plot them.
%   data = PARSE_DATA_2D(data_fem)
%   data_fem - geometry and data from the FEM solver (struct)
%   data - parsed geometry and data (struct)

% parse geometry
data.geom = extract_geom(data_fem.geom_fem, true);

% parse data
data.E_x = extract_data(data.geom, data_fem.E_x, @mean);
data.E_y = extract_data(data.geom, data_fem.E_y, @mean);
data.E = extract_data(data.geom, data_fem.E, @mean);

% plot the geometry
figure()
plot_param = struct(...
    'plot_arrow', true,...
    'arrow_scale', 1.0,...
    'arrow_color', 'r',...
    'arrow_width', 1.0,...
    'vertice_marker', 'x',...
    'face_color', [0.8 0.8 1.0],...
    'edge_color', 'k',...
    'face_alpha', 0.5,...
    'edge_width', 1.0...
    );
plot_geom(data.geom, plot_param);
axis('equal')
grid('on')
xlabel('x [m]')
ylabel('y [m]')
title('Geometry')

% plot the data (scalar and vector)
figure()
plt_scalar = struct(...
    'type', 'scalar',...
    'data', sum(abs(data.E), 2),...
    'face_alpha', 0.5,...
    'edge_width', 1.0...
    );
plot_data(data.geom, plt_scalar);
plt_vector = struct(...
    'type', 'vector',...
    'data_x', sum(abs(data.E_x), 2),...
    'data_y', sum(abs(data.E_y), 2),...
    'arrow_scale', 1.0,...
    'arrow_color', 'r',...
    'arrow_width', 1.0...
    );
plot_data(data.geom, plt_vector);
axis('equal')
grid('on')
colorbar();
xlabel('x [m]')
ylabel('y [m]')
title('Electric Field [V/m]')

end

function data = parse_data_3d(data_fem)
%PARSE_DATA_3D Parse a 3d geometry, the associated data, and plot them.
%   data = PARSE_DATA_3D(data_fem)
%   data_fem - geometry and data from the FEM solver (struct)
%   data - parsed geometry and data (struct)

% parse geometry
data.geom = extract_geom(data_fem.geom_fem, true);

% parse data
data.E_x = extract_data(data.geom, data_fem.E_x, @mean);
data.E_y = extract_data(data.geom, data_fem.E_y, @mean);
data.E_z = extract_data(data.geom, data_fem.E_z, @mean);
data.E = extract_data(data.geom, data_fem.E, @mean);

% plot the geometry
figure()
plot_param = struct(...
    'plot_arrow', true,...
    'arrow_scale', 1.0,...
    'arrow_color', 'r',...
    'arrow_width', 1.0,...
    'vertice_marker', 'x',...
    'face_color', [0.8 0.8 1.0],...
    'edge_color', 'k',...
    'face_alpha', 0.5,...
    'edge_width', 1.0...
    );
plot_geom(data.geom, plot_param);
axis('equal')
grid('on')
view([45,45])
xlabel('x [m]')
ylabel('y [m]')
title('Geometry')

% plot the data (scalar and vector)
figure()
plt_scalar = struct(...
    'type', 'scalar',...
    'data', sum(abs(data.E), 2),...
    'face_alpha', 0.5,...
    'edge_width', 1.0...
    );
plot_data(data.geom, plt_scalar);
plt_vector = struct(...
    'type', 'vector',...
    'data_x', sum(abs(data.E_x), 2),...
    'data_y', sum(abs(data.E_y), 2),...
    'data_z', sum(abs(data.E_z), 2),...
    'arrow_scale', 1.0,...
    'arrow_color', 'r',...
    'arrow_width', 1.0...
    );
plot_data(data.geom, plt_vector);
axis('equal')
grid('on')
view([45,45])
colorbar();
xlabel('x [m]')
ylabel('y [m]')
title('Electric Field [V/m]')

end

function interp_2d(data, x, y)
%INTERP_2D Interpolate data in 2d and plot the result.
%   INTERP_2D(data, x, y)
%   data - parsed geometry and data (struct)
%   x - x coordinates of the points (vector of float)
%   y - y coordinates of the points (vector of float)

% create a grid
[x, y] = ndgrid(x, y);
x = x(:).';
y = y(:).';

% interpolate the data
pts = struct('x', x, 'y', y);
v_int = interp_data(data.geom, sum(data.E, 2), pts);

% plot the data
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
%INTERP_3D Interpolate data in 3d and plot the result.
%   INTERP_3D(data, x, y, z)
%   data - parsed geometry and data (struct)
%   x - x coordinates of the points (vector of float)
%   y - y coordinates of the points (vector of float)
%   z - z coordinates of the points (vector of float)

% create a grid
[x, y, z] = ndgrid(x, y, z);
x = x(:).';
y = y(:).';
z = z(:).';

% interpolate the data
pts = struct('x', x, 'y', y, 'z', z);
v_int = interp_data(data.geom, sum(data.E, 2), pts);

% plot the data
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

function integrate_2d(data)
%INTEGRATE_2D Integrate data on a 2d geometry.
%   INTEGRATE_2D(data)
%   data - parsed geometry and data (struct)

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

function integrate_3d(data)
%INTEGRATE_3D Integrate data on a 3d geometry.
%   INTEGRATE_3D(data)
%   data - parsed geometry and data (struct)

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