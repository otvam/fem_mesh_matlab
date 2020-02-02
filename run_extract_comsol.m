function run_extract_comsol()

close('all')
addpath('fem_mesh_utils')

%% bridge

% load
model = load_comsol('model_bridge/bridge.mph');

% data
data_edge = extract_bridge(model, 'dset1', 'adj2', 'edge_3d');
data_surface = extract_bridge(model, 'dset1', 'adj1', 'surface_3d');

% save
save('model_bridge/bridge.mat', 'data_edge', 'data_surface')

%% simple

% load
model = load_comsol('model_simple/simple.mph');

% extract 2d data
data_2d.edge = extract_simple_2d(model, 'dset1', 'uni1', 'edge_2d');
data_2d.surface = extract_simple_2d(model, 'dset1', 'sel5', 'surface_2d');

% extract 3d data
data_3d.surface = extract_simple_3d(model, 'dset2', 'uni3', 'surface_3d');
data_3d.edge = extract_simple_3d(model, 'dset2', 'uni2', 'edge_3d');
data_3d.volume = extract_simple_3d(model, 'dset2', 'sel6', 'volume_3d');

% save
save('model_simple/simple.mat', 'data_2d', 'data_3d')

end

function data = extract_bridge(model, dataset, sel, type)

% geom
expr = {'u', 'v', 'w', 'solid.disp'};
[geom_fem, value_fem] = extract_comsol(model, dataset, sel, type, expr);

data.geom_fem = geom_fem;
data.disp_x = value_fem{1};
data.disp_y = value_fem{2};
data.disp_z = value_fem{3};
data.disp = value_fem{4};
data.disp_mat = [value_fem{1:3}];

end

function data = extract_simple_2d(model, dataset, sel, type)

% geom
expr = {'es_2d.Ex', 'es_2d.Ey', 'es_2d.normE'};
[geom_fem, value_fem] = extract_comsol(model, dataset, sel, type, expr);

data.geom_fem = geom_fem;
data.E_x = value_fem{1};
data.E_y = value_fem{2};
data.E = value_fem{3};

end

function data = extract_simple_3d(model, dataset, sel, type)

% geom
expr = {'es_3d.Ex', 'es_3d.Ey', 'es_3d.Ez', 'es_3d.normE'};
[geom_fem, value_fem] = extract_comsol(model, dataset, sel, type, expr);

data.geom_fem = geom_fem;
data.E_x = value_fem{1};
data.E_y = value_fem{2};
data.E_z = value_fem{3};
data.E = value_fem{4};

end

function model = load_comsol(filename)

try
    model = mphload(filename);
catch
    error('COMSOL/MATLAB link is not running')
end

end

function [geom_fem, value_fem] = extract_comsol(model, dataset, sel, type, expr)

% get the data
data_tmp = model.mpheval(expr,'Dataset', dataset, 'Complexout','on', 'Selection', sel);

% assign the geometry
geom_fem.type = type;
geom_fem.tri = double(data_tmp.t+1).';
geom_fem.pts = double(data_tmp.p).';

switch type
    case 'edge_2d'
        assert(size(data_tmp.t, 1)==2, 'invalid size')
        assert(size(data_tmp.p, 1)==2, 'invalid size')
    case 'edge_3d'
        assert(size(data_tmp.t, 1)==2, 'invalid size')
        assert(size(data_tmp.p, 1)==3, 'invalid size')
    case 'surface_2d'
        assert(size(data_tmp.t, 1)==3, 'invalid size')
        assert(size(data_tmp.p, 1)==2, 'invalid size')
    case 'surface_3d'
        assert(size(data_tmp.t, 1)==3, 'invalid size')
        assert(size(data_tmp.p, 1)==3, 'invalid size')
    case 'volume_3d'
        assert(size(data_tmp.t, 1)==4, 'invalid size')
        assert(size(data_tmp.p, 1)==3, 'invalid size')
    otherwise
        error('invalid type')
end

% assign the data
for i=1:length(expr)
    value_fem{i} = data_tmp.(['d' num2str(i)]).';
end

end