function run_extract()

addpath(genpath('src'))
close('all')

% load
data_tmp = load('data.mat');
data_2d = data_tmp.data_2d;
data_3d = data_tmp.data_3d;

% extract 2d data
data_2d.ext_edge = parse_data(data_2d.ext_edge);
data_2d.int_edge = parse_data(data_2d.int_edge);
data_2d.surface = parse_data(data_2d.surface);

% extract 3d data
data_3d.ext_surface = parse_data(data_3d.ext_surface);
data_3d.int_surface = parse_data(data_3d.int_surface);
data_3d.ext_edge = parse_data(data_3d.ext_edge);
data_3d.int_edge = parse_data(data_3d.int_edge);
data_3d.volume = parse_data(data_3d.volume);

int = struct('type', 'scalar', 'data', data_2d.surface.E);
v = integrate_data(data_2d.surface.geom, int);

int = struct('type', 'scalar', 'data', data_3d.ext_surface.E);
v = integrate_data(data_3d.ext_surface.geom, int);

int = struct('type', 'normal', 'data_x', data_3d.ext_surface.Ex, 'data_y', data_3d.ext_surface.Ey, 'data_z', data_3d.ext_surface.Ez);
v = integrate_data(data_3d.ext_surface.geom, int);

int = struct('type', 'scalar', 'data', data_3d.volume.E);
v = integrate_data(data_3d.volume.geom, int);

int = struct('type', 'scalar', 'data', data_2d.ext_edge.E);
v = integrate_data(data_2d.ext_edge.geom, int);

int = struct('type', 'scalar', 'data', data_3d.ext_edge.E);
v = integrate_data(data_3d.ext_edge.geom, int);


int = struct('type', 'tangential', 'data_x', data_3d.ext_edge.Ex, 'data_y', data_3d.ext_edge.Ey, 'data_z', data_3d.ext_edge.Ez);
v = integrate_data(data_3d.ext_edge.geom, int);

int = struct('type', 'tangential', 'data_x', data_2d.ext_edge.Ex, 'data_y', data_2d.ext_edge.Ey);
v = integrate_data(data_2d.ext_edge.geom, int);

int = struct('type', 'normal', 'data_x', data_2d.ext_edge.Ex, 'data_y', data_2d.ext_edge.Ey);
v = integrate_data(data_2d.ext_edge.geom, int);


%% 2d
% x = linspace(-0.15, +0.15, 25);
% y = linspace(-0.15, +0.15, 25);
% [x, y] = ndgrid(x, y);
% x = x(:).';
% y = y(:).';
% pts = struct('x', x, 'y', y);
% 
% v_int = interp_data(data_2d.surface.geom, data_2d.surface.E, pts);
% 
% figure()
% scatter(x,y, 5, v_int(:,1))

%% 3d
% x = linspace(-0.15, +0.15, 25);
% y = linspace(-0.15, +0.15, 25);
% z = linspace(-0.15, +0.15, 25);
% [x, y, z] = ndgrid(x, y, z);
% x = x(:).';
% y = y(:).';
% z = z(:).';
% pts = struct('x', x, 'y', y, 'z', z);
% 
% v_int = interp_data(data_3d.volume.geom, data_3d.volume.E, pts);
% 
% figure()
% scatter3(x,y, z,5, v_int(:,1))

end

function data = parse_data(data)

% geom
data.geom = extract_geom(data.geom);

% data
data.Ex = extract_data(data.geom, data.Ex, @mean);
data.Ey = extract_data(data.geom, data.Ey, @mean);
if isfield(data, 'Ez')
    data.Ez = extract_data(data.geom, data.Ez, @mean);
end

data.E = extract_data(data.geom, data.E, @mean);

plot_param.face_color = [0.8 0.8 1.0];
plot_param.edge_color = 'k';
plot_param.edge_alpha = 1.0;
plot_param.face_alpha = 0.5;

% figure()
% hold('on')
% plot_geom(data.geom, plot_param);
% axis('tight')
% axis('equal')
% 
% figure()
% hold('on')
% plot_data(data.geom, data.E(:,1));
% axis('tight')
% axis('equal')

end
