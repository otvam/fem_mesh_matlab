function v_int = interp_dom(geom, data, pts)

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

idx = isfinite(ti);

v_int = NaN(length(ti), size(data, 2));
for i=1:size(data, 2)
    v_tmp = data(:,i);
    v_tri = v_tmp(tri(ti(idx),:));
    v_int(idx, i) = dot(bc(idx,:)',v_tri')';
end

end