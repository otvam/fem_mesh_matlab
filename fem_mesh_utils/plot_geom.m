function plot_geom(geom, plot_param)
%PLOT_GEOM Plot a 2d/3d meshed geometry.
%   PLOT_GEOM(geom, plot_param)
%   geom - parsed mesh data (struct)
%   plot_param - plot parameters (struct)
%      plot_param.plot_arrow -  plot (or not) the direction and normal vectors (boolean)
%      plot_param.arrow_scale - scaling factor for the arrows (float)
%      plot_param.arrow_color - color of the arrows (color)
%      plot_param.arrow_width - line tickness for the arrows (float)
%      plot_param.vertice_marker - marker for the vertices (marker)
%      plot_param.face_color - color of the faces (color)
%      plot_param.edge_color - color of the edges (color)
%      plot_param.face_alpha - transparency channel for the faces (float)
%      plot_param.edge_width - line tickness for the edges (float)
%
%   This function plot the following features:
%      - edge, surface, and volumes
%      - direction and normal vectors
%
%   See also EXTRACT_GEOM, PATCH, QUIVER, QUIVER3.

%   Thomas Guillod.
%   2020 - BSD License.

% extract the vertices and the triangulation
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

% plot the vertices and the triangulation
patch(...
    'Vertices', pts,...
    'Faces', tri,...
    'Marker', plot_param.vertice_marker,...
    'FaceColor', plot_param.face_color,...
    'EdgeColor', plot_param.edge_color,...
    'FaceAlpha', plot_param.face_alpha,...
    'LineWidth', plot_param.edge_width...
    );
hold('on')

% plot the normal or tangential vectors
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
                'Color', plot_param.arrow_color,...
                'LineWidth', plot_param.arrow_width...
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
                'Color', plot_param.arrow_color,...
                'LineWidth', plot_param.arrow_width...
                )
        case 'surface_2d'
            % pass, not applicable
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
                'Color', plot_param.arrow_color,...
                'LineWidth', plot_param.arrow_width...
                )
        case 'volume_3d'
            % pass, not applicable
        otherwise
            error('invalid type')
    end
end

end