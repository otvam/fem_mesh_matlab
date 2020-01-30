function v_int = integrate_3d_surface_flux(geom, data_x, data_y, data_z)

assert(geom.is_2d==false, 'invalid geom');

vx = get_component(geom, data_x);
vy = get_component(geom, data_y);
vz = get_component(geom, data_z);

nx = geom.nx;
ny = geom.ny;
nz = geom.nz;

v_int = abs(nx*vx+ny*vy+nz*vz);

end

function v123 = get_component(geom, data)

v1 = data(geom.tri(:,1), :);
v2 = data(geom.tri(:,2), :);
v3 = data(geom.tri(:,3), :);

v123 = (v1+v2+v3)./3;

end