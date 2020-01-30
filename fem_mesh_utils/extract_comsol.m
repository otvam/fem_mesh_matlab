function [geom_fem, value_fem] = extract_comsol(model, dataset, sel, type, expr)

% get the data
data_tmp = model.mpheval(expr,'Dataset', dataset, 'Complexout','on', 'Selection', sel);

% assign the geometry
geom_fem.type = type;
geom_fem.n = size(data_tmp.p,2);
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