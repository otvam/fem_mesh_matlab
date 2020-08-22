function run_extract_comsol()
%RUN_EXTRACT_COMSOL Extract 2d/3d mesh and data from COMSOL simulations.
%
%   Two different models are considered:
%      - 'simple' - a simple 2d and 3d electrostatic model meant as a basic example
%      - 'bridge' - a complex 3d structural analysis model meant as a show-off
%
%   The file is the only file that requires on COMSOL.
%   COMSOL is just used for generating the data for the examples.
%
%   See also RUN_BRIDGE_EXAMPLE, RUN_SIMPLE_EXAMPLE, MPHLOAD, MPHEVAL.

%   Thomas Guillod.
%   2015-2020 - BSD License.

close('all')
addpath('fem_mesh_utils')

%% simple / 2d and 3d electrostatic model

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

%% bridge / 3d structural analysis model

% load
model = load_comsol('model_bridge/bridge.mph');

% extract data
data_edge = extract_bridge(model, 'dset1', 'adj2', 'edge_3d');
data_surface = extract_bridge(model, 'dset1', 'adj1', 'surface_3d');

% save
save('model_bridge/bridge.mat', 'data_edge', 'data_surface')

end

function data_fem = extract_simple_2d(model, dataset, sel, type)
%EXTRACT_SIMPLE_2D Extract the data for the 2d electrostatic model.
%   data_fem = EXTRACT_SIMPLE_2D(model, dataset, sel, type)
%   model - COMSOL model livelink object (COMSOL model)
%   dataset - name of the dataset (string)
%   sel - name of the selection containing the geometry (string)
%   type - type of the geometry (string)
%   data_fem - extracted geometry and data (struct)

% extract data from COMSOL
expr = {'es_2d.Ex', 'es_2d.Ey', 'es_2d.normE'};
[geom_fem, value_fem] = extract_comsol(model, dataset, sel, type, expr);

% assign data
data_fem.geom_fem = geom_fem;
data_fem.E_x = value_fem{1};
data_fem.E_y = value_fem{2};
data_fem.E = value_fem{3};

end

function data_fem = extract_simple_3d(model, dataset, sel, type)
%EXTRACT_SIMPLE_3D Extract the data for the 3d electrostatic model.
%   data_fem = EXTRACT_SIMPLE_3D(model, dataset, sel, type)
%   model - COMSOL model livelink object (COMSOL model)
%   dataset - name of the dataset (string)
%   sel - name of the selection containing the geometry (string)
%   type - type of the geometry (string)
%   data_fem - extracted geometry and data (struct)

% extract data from COMSOL
expr = {'es_3d.Ex', 'es_3d.Ey', 'es_3d.Ez', 'es_3d.normE'};
[geom_fem, value_fem] = extract_comsol(model, dataset, sel, type, expr);

% assign data
data_fem.geom_fem = geom_fem;
data_fem.E_x = value_fem{1};
data_fem.E_y = value_fem{2};
data_fem.E_z = value_fem{3};
data_fem.E = value_fem{4};

end

function data_fem = extract_bridge(model, dataset, sel, type)
%EXTRACT_BRIDGE Extract the data for the 3d structural analysis model.
%   data_fem = EXTRACT_BRIDGE(model, dataset, sel, type)
%   model - COMSOL model livelink object (COMSOL model)
%   dataset - name of the dataset (string)
%   sel - name of the selection containing the geometry (string)
%   type - type of the geometry (string)
%   data_fem - extracted geometry and data (struct)

% extract data from COMSOL
expr = {'u', 'v', 'w', 'solid.disp'};
[geom_fem, value_fem] = extract_comsol(model, dataset, sel, type, expr);

% assign data
data_fem.geom_fem = geom_fem;
data_fem.disp_x = value_fem{1};
data_fem.disp_y = value_fem{2};
data_fem.disp_z = value_fem{3};
data_fem.disp = value_fem{4};
data_fem.disp_mat = [value_fem{1:3}];

end

function model = load_comsol(filename)
%LOAD_COMSOL Check if the COMSOL/MATLAB is running and load a model.
%   model = LOAD_COMSOL(filename)
%   filename - filesystem path of the model (string)
%   model - COMSOL model livelink object (COMSOL model)

try
    model = mphload(filename);
catch
    error('COMSOL/MATLAB link is not running')
end

end

function [geom_fem, value_fem] = extract_comsol(model, dataset, sel, type, expr)
%EXTRACT_COMSOL Extract the geometry and data from a COMSOL model.
%   [geom_fem, value_fem] = EXTRACT_COMSOL(model, dataset, sel, type, expr)
%   model - COMSOL model livelink object (COMSOL model)
%   dataset - name of the dataset (string)
%   sel - name of the selection containing the geometry (string)
%   type - type of the geometry (string)
%   expr - expression to be evaluated on the geometry (cell of string)
%   geom_fem - raw mesh data from a FEM solver (struct)
%   data_fem - data from a FEM solver (cell of matrix of float)

% get the data
data_tmp = model.mpheval(expr,'Dataset', dataset, 'Complexout','on', 'Selection', sel);

% assign the geometry
geom_fem.type = type;
geom_fem.tri = double(data_tmp.t+1).';
geom_fem.pts = double(data_tmp.p).';

% check the data
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