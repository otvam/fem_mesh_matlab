function [geom, value] = extract_comsol(model, dataset, sel, type, expr)

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