function run_fem()

addpath(genpath('fem_utils'))

% load
model = mphload('simple.mph');

% extract 2d data
data_2d.ext_edge = extract_2d(model, 'dset1', 'sel1', 'edge_2d');
data_2d.int_edge = extract_2d(model, 'dset1', 'sel2', 'edge_2d');
data_2d.surface = extract_2d(model, 'dset1', 'sel5', 'surface_2d');

% extract 3d data
data_3d.ext_surface = extract_3d(model, 'dset2', 'sel3', 'surface_3d');
data_3d.int_surface = extract_3d(model, 'dset2', 'sel4', 'surface_3d');
data_3d.ext_edge = extract_3d(model, 'dset2', 'sel7', 'edge_3d');
data_3d.int_edge = extract_3d(model, 'dset2', 'sel8', 'edge_3d');
data_3d.volume = extract_3d(model, 'dset2', 'sel6', 'volume_3d');

% save
save('data.mat', 'data_2d', 'data_3d')

end

function data = extract_2d(model, dataset, sel, type)

% geom
expr = {'es_2d.Ex', 'es_2d.Ey', 'es_2d.normE'};
[data.geom, value] = extract_field(model, dataset, sel, type, expr);
data.Ex = value{1};
data.Ey = value{2};
data.E = value{3};

end

function data = extract_3d(model, dataset, sel, type)

% geom
expr = {'es_3d.Ex', 'es_3d.Ey', 'es_3d.Ez', 'es_3d.normE'};
[data.geom, value] = extract_field(model, dataset, sel, type, expr);
data.Ex = value{1};
data.Ey = value{2};
data.Ez = value{3};
data.E = value{4};

end

function [geom, value] = extract_field(model, dataset, sel, type, expr)

% get the data
data_tmp = model.mpheval(expr,'Dataset', dataset, 'Complexout','on', 'Selection', sel);

% assign the geometry
geom.type = type;
geom.n = size(data_tmp.p,2);
geom.tri = double(data_tmp.t+1).';
geom.x = data_tmp.p(1,:);
geom.y = data_tmp.p(2,:);
switch type
    case 'edge_2d'
        assert(size(data_tmp.t, 1)==2, 'invalid size')
        assert(size(data_tmp.p, 1)==2, 'invalid size')
    case 'edge_3d'
        assert(size(data_tmp.t, 1)==2, 'invalid size')
        assert(size(data_tmp.p, 1)==3, 'invalid size')
        geom.z = data_tmp.p(3,:);
    case 'surface_2d'
        assert(size(data_tmp.t, 1)==3, 'invalid size')
        assert(size(data_tmp.p, 1)==2, 'invalid size')
    case 'surface_3d'
        assert(size(data_tmp.t, 1)==3, 'invalid size')
        assert(size(data_tmp.p, 1)==3, 'invalid size')
        geom.z = data_tmp.p(3,:);
    case 'volume_3d'
        assert(size(data_tmp.t, 1)==4, 'invalid size')
        assert(size(data_tmp.p, 1)==3, 'invalid size')
        geom.z = data_tmp.p(3,:);
    otherwise
        error('invalid type')
end

% assign the data
for i=1:length(expr)
    value{i} = data_tmp.(['d' num2str(i)]).';
end

end