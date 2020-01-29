function plot_geom(geom, plot_param)

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

patch(...
    'Vertices', pts,...
    'Faces', tri,...
    'FaceColor', plot_param.face_color,...
    'EdgeColor', plot_param.edge_color,...
    'EdgeAlpha', plot_param.edge_alpha,...
    'FaceAlpha', plot_param.face_alpha...
    );

end