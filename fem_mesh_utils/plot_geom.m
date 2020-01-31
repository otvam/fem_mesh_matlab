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
    'Marker', plot_param.marker,...
    'FaceColor', plot_param.face_color,...
    'EdgeColor', plot_param.edge_color,...
    'EdgeAlpha', plot_param.edge_alpha,...
    'FaceAlpha', plot_param.face_alpha...
    );
hold('on')

if plot_param.plot_arrow==true
    switch geom.type
        case 'edge_2d'
            x = (geom.x(geom.tri(:,1))+geom.x(geom.tri(:,2)))./2;
            y = (geom.y(geom.tri(:,1))+geom.y(geom.tri(:,2)))./2;
            d_x = geom.d_x;
            d_y = geom.d_y;
            
            quiver(...
                x, y,...
                d_x, d_y,...
                plot_param.arrow_scale,...
                'Color', plot_param.arrow_color...
                )
        case 'edge_3d'
            x = (geom.x(geom.tri(:,1))+geom.x(geom.tri(:,2)))./2;
            y = (geom.y(geom.tri(:,1))+geom.y(geom.tri(:,2)))./2;
            z = (geom.z(geom.tri(:,1))+geom.z(geom.tri(:,2)))./2;
            d_x = geom.d_x;
            d_y = geom.d_y;
            d_z = geom.d_z;
            
            quiver3(...
                x, y, z,...
                d_x, d_y, d_z,...
                plot_param.arrow_scale,...
                'Color', plot_param.arrow_color...
            )
        case 'surface_2d'
            % pass
        case 'surface_3d'
            x = (geom.x(geom.tri(:,1))+geom.x(geom.tri(:,2))+geom.x(geom.tri(:,3)))./3;
            y = (geom.y(geom.tri(:,1))+geom.y(geom.tri(:,2))+geom.y(geom.tri(:,3)))./3;
            z = (geom.z(geom.tri(:,1))+geom.z(geom.tri(:,2))+geom.z(geom.tri(:,3)))./3;
            n_x = geom.n_x;
            n_y = geom.n_y;
            n_z = geom.n_z;
            
            quiver3(...
                x, y, z,...
                n_x, n_y, n_z,...
                plot_param.arrow_scale,...
                'Color', plot_param.arrow_color...
                )
        case 'volume_3d'
            % pass
        otherwise
            error('invalid type')
    end
end

end