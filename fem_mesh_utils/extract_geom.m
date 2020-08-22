function geom = extract_geom(geom_fem, remove_duplicates)
%EXTRACT_GEOM Extract and parse a 2d/3d meshed geometry.
%   geom = EXTRACT_GEOM(geom_fem, remove_duplicates)
%   geom_fem - raw mesh data from a FEM solver (struct)
%      geom_fem.type - type of the geometry (string)
%         'edge_2d' - An edge for a 2d geometry
%         'edge_3d' - An edge for a 3d geometry
%         'surface_2d' - A surface for a 2d geometry
%         'surface_2d' - A surface for a 2d geometry
%         'volume_3d' - A volume for 3d geometry
%      geom_fem.pts - vertices matrix (matrix of float)
%         n_fem x 2 - for a 2d geometry, n_fem is the number of vertices
%         n_fem x 3 - for a 3d geometry, n_fem is the number of vertices
%      geom_fem.tri - triangulation matrix (matrix of indices)
%         n_tri x 2 - for an edge, n_tri is the number of segments
%         n_tri x 3 - for a surface, n_tri is the number of triangles
%         n_tri x 4 - for a volume, n_tri is the number of tetrahedrons
%   remove_duplicates - remove (or not) duplicated vertices (boolean)
%   geom - parsed mesh data (struct)
%      geom.type - type of the geometry (string)
%         'edge_2d' - An edge for a 2d geometry
%         'edge_3d' - An edge for a 3d geometry
%         'surface_2d' - A surface for a 2d geometry
%         'surface_2d' - A surface for a 2d geometry
%         'volume_3d' - A volume for 3d geometry
%      geom.n - number of vertices (integer)
%      geom.idx_data - vector with information on the removed duplicated vertices (vector of indices)
%      geom.tri - triangulation matrix (matrix of indices)
%         n_tri x 2 - for an edge, n_tri is the number of segments
%         n_tri x 3 - for a surface, n_tri is the number of triangles
%         n_tri x 4 - for a volume, n_tri is the number of tetrahedrons
%      geom.x - x coordinates of the vertices (vector of float, 2d and 3d geometries)
%      geom.y - y coordinates of the vertices (vector of float, 2d and 3d geometries)
%      geom.z - y coordinates of the vertices (vector of float, 3d geometries)
%      geom.length_tri - length of the different segments (vector of float, 2d and 3d edge geometries)
%      geom.length - total length of the edge (float, 2d and 3d edge geometries)
%      geom.d_x - x component of the (non-normalized) vectors along the segements (vector of float, 2d and 3d edge geometries)
%      geom.d_y - y component of the (non-normalized) vectors along the segements (vector of float, 2d and 3d edge geometries)
%      geom.d_z - z component of the (non-normalized) vectors along the segements (vector of float, 3d edge geometries)
%      geom.area_tri - area of the different triangles (vector of float, 2d and 3d surface geometries)
%      geom.area - total area of the surface (float, 2d and 3d surface geometries)
%      geom.n_x - x component of the (non-normalized) normal vectors (vector of float, 3d surface geometries)
%      geom.n_y - y component of the (non-normalized) normal vectors (vector of float, 3d surface geometries)
%      geom.n_z - z component of the (non-normalized) normal vectors (vector of float, 3d surface geometries)
%      geom.volume_tri - volume of the different tetrahedrons (vector of float, 3d volume geometries)
%      geom.volume - total volume of the object (float, 3d volume geometries)
%
%   This function makes the following steps:
%      - remove duplicated vertices (if asked, time consuming on large meshes)
%      - compute tangent and normal vectors (direction taken from the triangulation matrix)
%      - compute length, area, and volume
%
%   See also PLOT_GEOM, EXTRACT_DATA.

%   Thomas Guillod.
%   2015-2020 - BSD License.

% remove duplicated vertices
geom = remove_duplicate_pts(geom_fem, remove_duplicates);

% add feature-dependent information
switch geom.type
    case 'edge_2d'
        geom = compute_edge_2d(geom);
    case 'edge_3d'
        geom = compute_edge_3d(geom);
    case 'surface_2d'
        geom = compute_surface_2d(geom);
    case 'surface_3d'
        geom = compute_surface_3d(geom);
    case 'volume_3d'
        geom = compute_volume_3d(geom);
    otherwise
        error('invalid type')
end

end

function geom = remove_duplicate_pts(geom_fem, remove_duplicates)
%REMOVE_DUPLICATE_PTS Remove duplicated vertices.
%   geom = REMOVE_DUPLICATE_PTS(geom_fem, remove_duplicates)
%   geom_fem - raw mesh data from a FEM solver (struct)
%   remove_duplicates - remove (or not) duplicated vertices (boolean)
%   geom - parsed mesh data (struct)

% number of vertices
n = size(geom_fem.pts, 1);

% get the duplicated points and remove them
if remove_duplicates==true
    [pts_unique, idx, idx_data] = unique(geom_fem.pts, 'rows');
    tri = substitute_mat(geom_fem.tri, idx_data, 1:n);
    tri = unique(tri, 'rows');
else
    idx = 1:n;
    idx_data = 1:n;
    tri = geom_fem.tri;
end

% assign the new geometry
geom.type = geom_fem.type;
geom.n = length(idx);
geom.idx_data = idx_data;
geom.tri = tri;
switch geom_fem.type
    case {'edge_2d', 'surface_2d'}
        geom.x = geom_fem.pts(idx, 1).';
        geom.y = geom_fem.pts(idx, 2).';
    case {'edge_3d', 'surface_3d', 'volume_3d'}
        geom.x = geom_fem.pts(idx, 1).';
        geom.y = geom_fem.pts(idx, 2).';
        geom.z = geom_fem.pts(idx, 3).';
    otherwise
        error('invalid type')
end

end

function geom = compute_edge_2d(geom)
%COMPUTE_EDGE_2D Add information specific for 2d edges.
%   geom = COMPUTE_EDGE_2D(geom)
%   geom - parsed mesh data (struct)

% assign
x = geom.x;
y = geom.y;
tri = geom.tri;

% get the vector
AB = [x(tri(:,2))-x(tri(:,1)) ; y(tri(:,2))-y(tri(:,1))];

% get the tangent vector
d_x = AB(1,:);
d_y = AB(2,:);

% get the length
length_tri = sqrt(d_x.^2+d_y.^2);

% assign
geom.length_tri = length_tri;
geom.length = sum(length_tri);
geom.d_x = d_x;
geom.d_y = d_y;

end

function geom = compute_edge_3d(geom)
%COMPUTE_EDGE_3D Add information specific for 3d edges.
%   geom = COMPUTE_EDGE_3D(geom)
%   geom - parsed mesh data (struct)

% assign
x = geom.x;
y = geom.y;
z = geom.z;
tri = geom.tri;

% get the vector
AB = [x(tri(:,2))-x(tri(:,1)) ; y(tri(:,2))-y(tri(:,1)) ; z(tri(:,2))-z(tri(:,1))];

% get the tangent vector
d_x = AB(1,:);
d_y = AB(2,:);
d_z = AB(3,:);

% get the length
length_tri = sqrt(d_x.^2+d_y.^2+d_z.^2);

% assign
geom.length_tri = length_tri;
geom.length = sum(length_tri);
geom.d_x = d_x;
geom.d_y = d_y;
geom.d_z = d_z;

end

function geom = compute_surface_2d(geom)
%COMPUTE_SURFACE_2D Add information specific for 2d surfaces.
%   geom = COMPUTE_SURFACE_2D(geom)
%   geom - parsed mesh data (struct)

% assign
x = geom.x;
y = geom.y;
tri = geom.tri;

% get the vector
AB = [x(tri(:,2))-x(tri(:,1)) ; y(tri(:,2))-y(tri(:,1))];
AC = [x(tri(:,3))-x(tri(:,1)) ; y(tri(:,3))-y(tri(:,1))];

% get the cross product
cross = AB(1,:).*AC(2,:)-AB(2,:).*AC(1,:);

% get the area
area_tri = cross./2;

% assign
geom.area_tri = area_tri;
geom.area = sum(area_tri);

end

function geom = compute_surface_3d(geom)
%COMPUTE_SURFACE_3D Add information specific for 3d surfaces.
%   geom = COMPUTE_SURFACE_3D(geom)
%   geom - parsed mesh data (struct)

% assign
x = geom.x;
y = geom.y;
z = geom.z;
tri = geom.tri;

% get the vector
AB = [x(tri(:,2))-x(tri(:,1)) ; y(tri(:,2))-y(tri(:,1)) ; z(tri(:,2))-z(tri(:,1))];
AC = [x(tri(:,3))-x(tri(:,1)) ; y(tri(:,3))-y(tri(:,1)) ; z(tri(:,3))-z(tri(:,1))];

% get the cross product
cross = [AB(2,:).*AC(3,:)-AB(3,:).*AC(2,:) ; AB(3,:).*AC(1,:)-AB(1,:).*AC(3,:) ; AB(1,:).*AC(2,:)-AB(2,:).*AC(1,:)];

% assign the normal vector
n_x = cross(1,:);
n_y = cross(2,:);
n_z = cross(3,:);

% get the area
area_tri = sqrt(n_x.^2+n_y.^2+n_z.^2)./2;

% assign
geom.area_tri = area_tri;
geom.area = sum(area_tri);
geom.n_x = n_x;
geom.n_y = n_y;
geom.n_z = n_z;

end

function geom = compute_volume_3d(geom)
%COMPUTE_VOLUME_3D Add information specific for 3d volumes.
%   geom = COMPUTE_VOLUME_3D(geom)
%   geom - parsed mesh data (struct)

% assign
x = geom.x;
y = geom.y;
z = geom.z;
tri = geom.tri;

% get the vector
AB = [x(tri(:,2))-x(tri(:,1)) ; y(tri(:,2))-y(tri(:,1)) ; z(tri(:,2))-z(tri(:,1))];
AC = [x(tri(:,3))-x(tri(:,1)) ; y(tri(:,3))-y(tri(:,1)) ; z(tri(:,3))-z(tri(:,1))];
AD = [x(tri(:,4))-x(tri(:,1)) ; y(tri(:,4))-y(tri(:,1)) ; z(tri(:,4))-z(tri(:,1))];

% compute the determinent
det_p = AB(1,:).*AC(2,:).*AD(3,:)+AC(1,:).*AD(2,:).*AB(3,:)+AD(1,:).*AB(2,:).*AC(3,:);
det_m = AB(3,:).*AC(2,:).*AD(1,:)+AC(3,:).*AD(2,:).*AB(1,:)+AD(3,:).*AB(2,:).*AC(1,:);

% compute the volume
volume_tri = abs(det_p-det_m)./6;

% assign
geom.volume_tri = volume_tri;
geom.volume = sum(volume_tri);

end

function mat_new = substitute_mat(mat_old, v_new, v_old)
%SUBSTITUTE_MAT Substitute values in a matrix.
%   mat_new = SUBSTITUTE_MAT(mat_old, v_new, v_old)
%   mat_old - input matrix (matrix)
%   v_new - value to be substituted (array)
%   v_old - value to be replaced (array)
%   mat_new - output matrix (matrix)

assert(numel(v_new)==numel(v_old), 'invalid substitution')
mat_new = mat_old;
for i=1:numel(v_new)
    mat_new(mat_old==v_old(i)) = v_new(i);
end

end