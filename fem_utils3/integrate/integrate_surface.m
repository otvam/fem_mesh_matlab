function v_int = integrate_surface(geom,data)

v1 = data(geom.tri(:,1), :);
v2 = data(geom.tri(:,2), :);
v3 = data(geom.tri(:,3), :);

area_tri = geom.area_tri;
v123 = (v1+v2+v3)./3.0;

v_int = area_tri*v123;

end