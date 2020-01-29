function v_int = integrate_volume(geom, data)

v1 = data(geom.tri(:,1), :);
v2 = data(geom.tri(:,2), :);
v3 = data(geom.tri(:,3), :);
v4 = data(geom.tri(:,4), :);

volume_tri = geom.volume_tri;
v123 = (v1+v2+v3+v4)./4.0;

v_int = volume_tri*v123;

end