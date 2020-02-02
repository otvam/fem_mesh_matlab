function data_interp = interp_data(geom, data, pts)
%INTERP_DATA Interpolated data at given points (for 2d surface and 3d volumes).
%   data_interp = INTERP_DATA(geom, data, pts)
%   geom - parsed mesh data (struct)
%   data - parsed data (matrix of float)
%   pts - struct with the points to be interpolated (struct)
%      pts.x - x coordinates of the points (vector of float, 2d surface and 3d volumes)
%      pts.y - y coordinates of the points (vector of float, 2d surface and 3d volumes)
%      pts.z - y coordinates of the points (vector of float, 3d volumes)
%   data_interp - interpolated values (matrix of float)
%
%   This function accepts variable with multiple dimensions (see 'extract_data').
%   Extrapolation is not supported.
%
%   See also EXTRACT_GEOM, EXTRACT_DATA, TRIANGULATION.

%   Thomas Guillod.
%   2020 - BSD License.

% check size of the data
assert(size(data,1)==geom.n, 'invalid data length')

% find the elements involved in the interpolation
switch geom.type
    case 'surface_2d'
        tri = triangulation(geom.tri, geom.x.', geom.y.');
        [ti, bc] = tri.pointLocation(pts.x.', pts.y.');
    case 'volume_3d'
        tri = triangulation(geom.tri, geom.x.', geom.y.', geom.z.');
        [ti, bc] = tri.pointLocation(pts.x.', pts.y.', pts.z.');
    otherwise
        error('invalid type')
end

% get the valud and initialize the values
idx = isfinite(ti);
data_interp = NaN(length(ti), size(data, 2));

% for each dimension, interpolate
for i=1:size(data, 2)
    data_tmp = data(:,i);
    data_tri = data_tmp(tri(ti(idx),:));
    data_interp(idx, i) = dot(bc(idx,:)', data_tri')';
end

end