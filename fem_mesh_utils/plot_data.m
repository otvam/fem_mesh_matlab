function plot_data(geom, plt)
%PLOT_DATA Plot scalar or vector data on a 2d/3d meshed geometry.
%   PLOT_DATA(geom, plt)
%   geom - parsed mesh data (struct)
%   plt - plot type and data (struct)
%      plt.type - plot type (string)
%         'scalar' - scalar plot (string)
%         'vector' - scalar plot (string)
%      plt.face_alpha - transparency channel for the faces (float, scalar plot)
%      plt.edge_width - line tickness for the edges (float, scalar plot)
%      plt.data - data to be plotted (vector float, scalar plot)
%      plt.arrow_scale - scaling factor for the arrows (float, vector plot)
%      plt.arrow_color - color of the arrows (color, vector plot)
%      plt.arrow_width - line tickness for the arrows (float, vector plot)
%      plt.data_x - x component of the data to be plotted (vector float, vector 2d and 3d plot)
%      plt.data_y - y component of the data to be plotted (vector float, vector 2d and 3d plot)
%      plt.data_z - z component of the data to be plotted (vector float, vector 3d plot)
%
%   This function plot the following features:
%      - scalar data (with 'patch')
%      - vector data (with 'quiver' and 'quiver3')
%
%   This function does not variable with multiple dimensions (see 'extract_data').
%
%   See also EXTRACT_GEOM, EXTRACT_DATA, PATCH, QUIVER, QUIVER3.

%   Thomas Guillod.
%   2020 - BSD License.

switch plt.type
    case 'scalar'
        switch geom.type
            case {'edge_2d', 'surface_2d'}
                plot_data_scalar_2d(geom, plt)
            case {'edge_3d', 'surface_3d', 'volume_3d'}
                plot_data_scalar_3d(geom, plt)
            otherwise
                error('invalid type')
        end
    case 'vector'
        switch geom.type
            case {'edge_2d', 'surface_2d'}
                plot_data_vector_2d(geom, plt)
            case {'edge_3d', 'surface_3d', 'volume_3d'}
                plot_data_vector_3d(geom, plt)
            otherwise
                error('invalid type')
        end
    otherwise
        error('invalid type')
end

end

function plot_data_vector_2d(geom, plt)
%PLOT_DATA_VECTOR_2D Plot vector data on a 2d meshed geometry.
%   PLOT_DATA_VECTOR_2D(geom, plt)
%   geom - parsed mesh data (struct)
%   plt - plot type and data (struct)

% check data
assert(size(plt.data_x,1)==geom.n, 'invalid data length')
assert(size(plt.data_x,2)==1, 'invalid data length')
assert(size(plt.data_y,1)==geom.n, 'invalid data length')
assert(size(plt.data_y,2)==1, 'invalid data length')

% plot the vectors
quiver(...
    geom.x, geom.y,...
    plt.data_x.', plt.data_y.',...
    plt.arrow_scale,...
    'Color', plt.arrow_color,...
    'LineWidth', plt.arrow_width...
    )
hold('on')

end

function plot_data_vector_3d(geom, plt)
%PLOT_DATA_VECTOR_3D Plot vector data on a 3d meshed geometry.
%   PLOT_DATA_VECTOR_3D(geom, plt)
%   geom - parsed mesh data (struct)
%   plt - plot type and data (struct)

% check data
assert(size(plt.data_x,1)==geom.n, 'invalid data length')
assert(size(plt.data_x,2)==1, 'invalid data length')
assert(size(plt.data_y,1)==geom.n, 'invalid data length')
assert(size(plt.data_y,2)==1, 'invalid data length')
assert(size(plt.data_z,1)==geom.n, 'invalid data length')
assert(size(plt.data_z,2)==1, 'invalid data length')

% plot the vectors
quiver3(...
    geom.x, geom.y, geom.z,...
    plt.data_x.', plt.data_y.', plt.data_z.',...
    plt.arrow_scale,...
    'Color', plt.arrow_color,...
    'LineWidth', plt.arrow_width...
)
hold('on')

end

function plot_data_scalar_2d(geom, plt)
%PLOT_DATA_SCALAR_2D Plot scalar data on a 2d meshed geometry.
%   PLOT_DATA_SCALAR_2D(geom, plt)
%   geom - parsed mesh data (struct)
%   plt - plot type and data (struct)

% check data
assert(size(plt.data,1)==geom.n, 'invalid data length')
assert(size(plt.data,2)==1, 'invalid data length')

% plot the surfaces and edges
patch(...
    'Vertices', [geom.x ; geom.y].',...
    'CData', plt.data,...
    'Faces', geom.tri,...
    'FaceColor', 'interp',...
    'EdgeColor', 'interp',...
    'FaceAlpha', plt.face_alpha,...
    'LineWidth', plt.edge_width...
    );
hold('on')

end

function plot_data_scalar_3d(geom, plt)
%PLOT_DATA_SCALAR_3D Plot scalar data on a 3d meshed geometry.
%   PLOT_DATA_SCALAR_3D(geom, plt)
%   geom - parsed mesh data (struct)
%   plt - plot type and data (struct)

% check data
assert(size(plt.data,1)==geom.n, 'invalid data length')
assert(size(plt.data,2)==1, 'invalid data length')

% extract and/or construct the triangulation
switch geom.type
    case 'edge_3d'
        tri = geom.tri;
    case 'surface_3d'
        tri = geom.tri;
    case 'volume_3d'
        tri = [geom.tri(:, [2 3 4]) ; geom.tri(:, [1 3 4]) ; geom.tri(:, [1 2 4]) ; geom.tri(:, [1 2 3])];
    otherwise
        error('invalid type')
end

% plot the surfaces and edges
patch(...
    'Vertices', [geom.x ; geom.y ; geom.z].',...
    'CData', plt.data,...
    'Faces', tri,...
    'FaceColor', 'interp',...
    'EdgeColor', 'interp',...
    'FaceAlpha', plt.face_alpha,...
    'LineWidth', plt.edge_width...
    );
hold('on')

end