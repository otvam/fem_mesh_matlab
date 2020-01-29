function geom = find_surface(geom)
    
geom = find_duplicate_pts(geom);

[area_tri, area, nx, ny, nz] = compute_area(geom.x, geom.y, geom.z, geom.tri);
geom.area_tri = area_tri;
geom.area = area;
geom.nx = nx;
geom.ny = ny;
geom.nz = nz;

end

function [area_tri, area, nx, ny, nz] = compute_area(x, y, z, tri)

AB = [x(tri(:,2))-x(tri(:,1)) ; y(tri(:,2))-y(tri(:,1)) ; z(tri(:,2))-z(tri(:,1))];
AC = [x(tri(:,3))-x(tri(:,1)) ; y(tri(:,3))-y(tri(:,1)) ; z(tri(:,3))-z(tri(:,1))];

cross = [AB(2,:).*AC(3,:)-AB(3,:).*AC(2,:) ; AB(3,:).*AC(1,:)-AB(1,:).*AC(3,:) ; AB(1,:).*AC(2,:)-AB(2,:).*AC(1,:)];

nx = cross(1,:)./2.0;
ny = cross(2,:)./2.0;
nz = cross(3,:)./2.0;

area_tri = sqrt(nx.^2+ny.^2+nz.^2);
area = sum(area_tri);

end