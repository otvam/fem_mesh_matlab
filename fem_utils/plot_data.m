function plot_data(geom, data)

assert(size(data,1)==geom.n, 'invalid data')
assert(size(data,2)==1, 'invalid data')

switch geom.type
    case 'edge_2d'
        pts = [geom.x ; geom.y].';
        tri = geom.tri;
    case 'edge_3d'
        pts = [geom.x ; geom.y ; geom.z].';
        tri = geom.tri;
    case 'surface_2d'
        pts = [geom.x ; geom.y].';
        tri = geom.tri;
    case 'surface_3d'
        pts = [geom.x ; geom.y ; geom.z].';
        tri = geom.tri;
    case 'volume_3d'
        pts = [geom.x ; geom.y ; geom.z].';
        tri = [geom.tri(:, [2 3 4]) ; geom.tri(:, [1 3 4]) ; geom.tri(:, [1 2 4]) ; geom.tri(:, [1 2 3])];
    otherwise
        error('invalid type')
end

switch geom.type
    case {'edge_2d', 'edge_3d'}
        patch(...
            'Vertices', pts,...
            'CData', data,...
            'Faces', tri,...
            'FaceColor', 'none',...
            'EdgeColor', 'interp'...
            );
    case {'surface_2d', 'surface_3d', 'volume_3d'}
        patch(...
            'Vertices', pts,...
            'CData', data,...
            'Faces', tri,...
            'FaceColor', 'interp',...
            'EdgeColor', 'none'...
            );
    otherwise
        error('invalid type')
end

end