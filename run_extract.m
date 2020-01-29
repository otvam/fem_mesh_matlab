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

end

function data = parse_data(data)

% geom
data.geom = extract_geom(data.geom);

% data
data.Ex = extract_data(data.geom, data.Ex, @mean);
data.Ey = extract_data(data.geom, data.Ey, @mean);
data.E = extract_data(data.geom, data.E, @mean);

figure()
hold('on')

plot_data.face_color = [0.8 0.8 1.0];
plot_data.edge_color = 'k';
plot_data.edge_alpha = 1.0;
plot_data.face_alpha = 0.5;

plot_geom(data.geom, plot_data);

axis('tight')
axis('off')
axis('equal')
view([+40 -120])

end
