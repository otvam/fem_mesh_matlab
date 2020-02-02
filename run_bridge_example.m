function run_bridge_example()

close('all')
addpath('fem_mesh_utils')

% load
data_tmp = load('model_bridge/bridge.mat');
data_edge = data_tmp.data_edge;
data_surface = data_tmp.data_surface;

% parse geom
geom_edge = deform_geometry(data_edge, 0.0);
geom_surface_def = deform_geometry(data_surface, 100.0);
geom_edge_def = deform_geometry(data_edge, 100.0);

% parse data
disp = extract_data(geom_surface_def, data_surface.disp, @mean);
disp_x = extract_data(geom_edge_def, data_edge.disp_x, @mean);
disp_y = extract_data(geom_edge_def, data_edge.disp_y, @mean);
disp_z = extract_data(geom_edge_def, data_edge.disp_z, @mean);

% plot_param
plot_param = struct(...
    'plot_arrow', false,...
    'vertice_marker', 'none',...
    'face_color', [0.8 0.8 1.0],...
    'edge_color', 'k',...
    'face_alpha', 0.5,...
    'edge_width', 1.0...
    );

% plot
plt_scalar = struct(...
    'type', 'scalar',...
    'data', disp,...
    'face_alpha', 0.25,...
    'edge_width', 1.0...
);
plt_vector = struct(...
    'type', 'vector',...
    'data_x', disp_x,...
    'data_y', disp_y,...
    'data_z', disp_z,...
    'arrow_scale', 1.0,...
    'arrow_color', 'r',...
    'arrow_width', 1.0...
    );

% plot
figure()
plot_data(geom_surface_def, plt_scalar);
plot_data(geom_edge_def, plt_vector);
plot_geom(geom_edge, plot_param);
axis('equal')
axis('tight')
axis('off')
view(200, -65)

end

function geom = deform_geometry(data_fem, scale)

geom_fem = data_fem.geom_fem;
geom_fem.pts = geom_fem.pts+scale.*data_fem.disp_mat;
geom = extract_geom(geom_fem, false);

end

