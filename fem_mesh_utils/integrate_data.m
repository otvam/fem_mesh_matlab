function data_int = integrate_data(geom, int)
%INTEGRATE_DATA Compute different integrals (flux, scalar, etc.) on the geometry.
%   data_int = INTEGRATE_DATA(geom, int)
%   geom - parsed mesh data (struct)
%   int - struct with the integral type and data (struct)
%      int.type - type of the integral (string)
%         'scalar' - scalar integral ('edge_2d', 'surface_2d', 'edge_3d', 'surface_3d', 'volume_3d')
%         'tangential' - vector integral along an edge ('edge_2d', 'edge_3d')
%         'normal' - vector integral of a flux through an edge or a surface ('edge_2d', 'surface_3d')
%      int.data - data for scalar integral (matrix of float, scalar integral)
%      int.data_x - x data for vector integral (matrix of float, vector 2d and 3d integral)
%      int.data_y - y data for vector integral (matrix of float, vector 2d and 3d integral)
%      int.data_z - z data for vector integral (matrix of float, vector 3d integral)
%   data_int - results and the integral (vector of float)
%
%   This function accepts variable with multiple dimensions (see 'extract_data').
%   The integration is done with linear elements, with can be sub-optimal for high-order FEM.
%
%   See also EXTRACT_GEOM, EXTRACT_DATA.

%   Thomas Guillod.
%   2020 - BSD License.

if strcmp(geom.type, 'edge_2d')&&strcmp(int.type, 'scalar')
    data = get_component_edge(geom, int.data);
    data_int = geom.length_tri*data;
elseif strcmp(geom.type, 'edge_2d')&&strcmp(int.type, 'tangential')
    data_x = get_component_edge(geom, int.data_x);
    data_y = get_component_edge(geom, int.data_y);
    data_int = abs(geom.d_x*data_x+geom.d_y*data_y);
elseif strcmp(geom.type, 'edge_2d')&&strcmp(int.type, 'normal')
    data_x = get_component_edge(geom, int.data_x);
    data_y = get_component_edge(geom, int.data_y);
    data_int = abs(geom.d_y*data_x-geom.d_x*data_y);
elseif strcmp(geom.type, 'surface_2d')&&strcmp(int.type, 'scalar')
    data = get_component_surface(geom, int.data);
    data_int = geom.area_tri*data;
elseif strcmp(geom.type, 'edge_3d')&&strcmp(int.type, 'scalar')
    data = get_component_edge(geom, int.data);
    data_int = geom.length_tri*data;
elseif strcmp(geom.type, 'edge_3d')&&strcmp(int.type, 'tangential')
    data_x = get_component_edge(geom, int.data_x);
    data_y = get_component_edge(geom, int.data_y);
    data_z = get_component_edge(geom, int.data_z);
    data_int = abs(geom.d_x*data_x+geom.d_y*data_y+geom.d_z*data_z);
elseif strcmp(geom.type, 'surface_3d')&&strcmp(int.type, 'scalar')
    data = get_component_surface(geom, int.data);
    data_int = geom.area_tri*data;
elseif strcmp(geom.type, 'surface_3d')&&strcmp(int.type, 'normal')
    data_x = get_component_surface(geom, int.data_x);
    data_y = get_component_surface(geom, int.data_y);
    data_z = get_component_surface(geom, int.data_z);
    data_int = abs(geom.n_x*data_x+geom.n_y*data_y+geom.n_z*data_z);
elseif strcmp(geom.type, 'volume_3d')&&strcmp(int.type, 'scalar')
    data = get_component_volume(geom, int.data);
    data_int = geom.volume_tri*data;
else
    error('invalid integral')
end

end

function data_extract = get_component_edge(geom, data)
%GET_COMPONENT_EDGE Get the value of the data for the edge segments (average of the vertice values).
%   data_extract = GET_COMPONENT_EDGE(geom, data)
%   geom - parsed mesh data (struct)
%   data - parsed data (matrix of float)
%   data_extract - extract data for the geometrical feature (matrix of float)

assert(size(data,1)==geom.n, 'invalid data length length')
data_1 = data(geom.tri(:,1), :);
data_2 = data(geom.tri(:,2), :);
data_extract = (data_1+data_2)./2;

end

function data_extract = get_component_surface(geom, data)
%GET_COMPONENT_EDGE Get the value of the data for the surface triangles (average of the vertice values).
%   data_extract = GET_COMPONENT_EDGE(geom, data)
%   geom - parsed mesh data (struct)
%   data - parsed data (matrix of float)
%   data_extract - extract data for the geometrical feature (matrix of float)

assert(size(data,1)==geom.n, 'invalid data length')
data_1 = data(geom.tri(:,1), :);
data_2 = data(geom.tri(:,2), :);
data_3 = data(geom.tri(:,3), :);
data_extract = (data_1+data_2+data_3)./3;

end

function data_extract = get_component_volume(geom, data)
%GET_COMPONENT_EDGE Get the value of the data for the volume tetrahedrons (average of the vertice values).
%   data_extract = GET_COMPONENT_EDGE(geom, data)
%   geom - parsed mesh data (struct)
%   data - parsed data (matrix of float)
%   data_extract - extract data for the geometrical feature (matrix of float)

assert(size(data,1)==geom.n, 'invalid data length')
data_1 = data(geom.tri(:,1), :);
data_2 = data(geom.tri(:,2), :);
data_3 = data(geom.tri(:,3), :);
data_4 = data(geom.tri(:,4), :);
data_extract = (data_1+data_2+data_3+data_4)./4;

end
