function geom = find_volume(geom)

geom = find_duplicate_pts(geom);

[volume_tri, volume] = compute_volume(geom.x, geom.y, geom.z, geom.tri);
geom.volume_tri = volume_tri;
geom.volume = volume;

end

function [volume_tri, volume] = compute_volume(x, y, z, tri)

AB = [x(tri(:,2))-x(tri(:,1)) ; y(tri(:,2))-y(tri(:,1)) ; z(tri(:,2))-z(tri(:,1))];
AC = [x(tri(:,3))-x(tri(:,1)) ; y(tri(:,3))-y(tri(:,1)) ; z(tri(:,3))-z(tri(:,1))];
AD = [x(tri(:,4))-x(tri(:,1)) ; y(tri(:,4))-y(tri(:,1)) ; z(tri(:,4))-z(tri(:,1))];

det_p = AB(1,:).*AC(2,:).*AD(3,:)+AC(1,:).*AD(2,:).*AB(3,:)+AD(1,:).*AB(2,:).*AC(3,:);
det_m = AB(3,:).*AC(2,:).*AD(1,:)+AC(3,:).*AD(2,:).*AB(1,:)+AD(3,:).*AB(2,:).*AC(1,:);
det = det_p-det_m;

volume_tri = abs(det)./6.0;
volume = sum(volume_tri);

end