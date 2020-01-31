function plot_data(geom, plt)

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

assert(size(plt.data_x,1)==geom.n, 'invalid data')
assert(size(plt.data_x,2)==1, 'invalid data')
assert(size(plt.data_y,1)==geom.n, 'invalid data')
assert(size(plt.data_y,2)==1, 'invalid data')

quiver(...
    geom.x, geom.y,...
    plt.data_x.', plt.data_y.',...
    plt.arrow_scale,...
    'Color', plt.arrow_color...
    )
hold('on')

end

function plot_data_vector_3d(geom, plt)

assert(size(plt.data_x,1)==geom.n, 'invalid data')
assert(size(plt.data_x,2)==1, 'invalid data')
assert(size(plt.data_y,1)==geom.n, 'invalid data')
assert(size(plt.data_y,2)==1, 'invalid data')
assert(size(plt.data_z,1)==geom.n, 'invalid data')
assert(size(plt.data_z,2)==1, 'invalid data')

quiver3(...
    geom.x, geom.y, geom.z,...
    plt.data_x.', plt.data_y.', plt.data_z.',...
    plt.arrow_scale,...
    'Color', plt.arrow_color...
    )
hold('on')

end

function plot_data_scalar_2d(geom, plt)

assert(size(plt.data,1)==geom.n, 'invalid data')
assert(size(plt.data,2)==1, 'invalid data')

patch(...
    'Vertices', [geom.x ; geom.y].',...
    'CData', plt.data,...
    'Faces', geom.tri,...
    'FaceColor', 'none',...
    'EdgeColor', 'interp',...
    'FaceAlpha', plt.face_alpha...
    );
hold('on')

end

function plot_data_scalar_3d(geom, plt)

assert(size(plt.data,1)==geom.n, 'invalid data')
assert(size(plt.data,2)==1, 'invalid data')

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

patch(...
    'Vertices', [geom.x ; geom.y ; geom.z].',...
    'CData', plt.data,...
    'Faces', tri,...
    'FaceColor', 'interp',...
    'EdgeColor', 'interp',...
    'FaceAlpha', plt.face_alpha...
    );
hold('on')

end