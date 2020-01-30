function run_simple_fem_extract()

close('all')
addpath('fem_mesh_utils')

% load
model = mphload('model_simple/simple.mph');

% extract 2d data
data_2d.edge = extract_2d(model, 'dset1', 'uni1', 'edge_2d');
data_2d.surface = extract_2d(model, 'dset1', 'sel5', 'surface_2d');

% extract 3d data
data_3d.surface = extract_3d(model, 'dset2', 'uni3', 'surface_3d');
data_3d.edge = extract_3d(model, 'dset2', 'uni2', 'edge_3d');
data_3d.volume = extract_3d(model, 'dset2', 'sel6', 'volume_3d');

% save
save('model_simple/simple.mat', 'data_2d', 'data_3d')

end

function data = extract_2d(model, dataset, sel, type)

% geom
expr = {'es_2d.Ex', 'es_2d.Ey', 'es_2d.normE'};
[data.geom, value] = extract_comsol(model, dataset, sel, type, expr);
data.E_x = value{1};
data.E_y = value{2};
data.E = value{3};

end

function data = extract_3d(model, dataset, sel, type)

% geom
expr = {'es_3d.Ex', 'es_3d.Ey', 'es_3d.Ez', 'es_3d.normE'};
[data.geom, value] = extract_comsol(model, dataset, sel, type, expr);
data.E_x = value{1};
data.E_y = value{2};
data.E_z = value{3};
data.E = value{4};

end
