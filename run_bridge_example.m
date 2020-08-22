function run_bridge_example()
%RUN_BRIDGE_EXAMPLE Extract and plot the results of 3d structural analysis simulation.
%
%   This example is meant as a show-off with a complex 3d mesh and a beautiful plot.
%   The example 'run_simple_example' is meant to systemically test/demonstrates the different functions.
%
%   See also RUN_EXTRACT_COMSOL, RUN_SIMPLE_EXAMPLE, EXTRACT_GEOM, EXTRACT_DATA, PLOT_GEOM, PLOT_DATA.

%   Thomas Guillod.
%   2015-2020 - BSD License.

close('all')
addpath('fem_mesh_utils')

%% load and parse

% load
data_tmp = load('model_bridge/bridge.mat');
data_edge = data_tmp.data_edge;
data_surface = data_tmp.data_surface;

% deform and parse geometry
geom_edge = deform_geometry(data_edge.geom_fem, data_edge.disp_mat, 0.0);
geom_surface_def = deform_geometry(data_surface.geom_fem, data_surface.disp_mat, 100.0);
geom_edge_def = deform_geometry(data_edge.geom_fem, data_edge.disp_mat, 100.0);

% parse data
disp = extract_data(geom_surface_def, data_surface.disp, @mean);
disp_x = extract_data(geom_edge_def, data_edge.disp_x, @mean);
disp_y = extract_data(geom_edge_def, data_edge.disp_y, @mean);
disp_z = extract_data(geom_edge_def, data_edge.disp_z, @mean);

%% plot

% create figure
figure()

% plot scalar data on the surface
plt_scalar = struct(...
    'type', 'scalar',...
    'data', disp,...
    'face_alpha', 0.25,...
    'edge_width', 1.0...
);
plot_data(geom_surface_def, plt_scalar);

% plot vector data on the edges
plt_vector = struct(...
    'type', 'vector',...
    'data_x', disp_x,...
    'data_y', disp_y,...
    'data_z', disp_z,...
    'arrow_scale', 1.0,...
    'arrow_color', 'r',...
    'arrow_width', 1.0...
    );

% plot the edges
plot_data(geom_edge_def, plt_vector);
plot_param = struct(...
    'plot_arrow', false,...
    'vertice_marker', 'none',...
    'face_color', [0.8 0.8 1.0],...
    'edge_color', 'k',...
    'face_alpha', 0.5,...
    'edge_width', 1.0...
    );
plot_geom(geom_edge, plot_param);

% axis control
axis('equal')
axis('tight')
axis('off')
view(200, -65)

end

function geom = deform_geometry(geom_fem, disp_mat, scale)
%DEFORM_GEOMETRY Deform a geometry with respect to a deformation vector.
%   geom = DEFORM_GEOMETRY(geom_fem, disp_mat, scale)
%   geom_fem - raw mesh data from a FEM solver (struct)
%   disp_mat - matrix with the deformation for each vertices (matrix of float)
%   scale - scaling factor for the deformation (float)
%   geom - parsed mesh data (struct)

geom_fem.pts = geom_fem.pts+scale.*disp_mat;
geom = extract_geom(geom_fem, false);

end

