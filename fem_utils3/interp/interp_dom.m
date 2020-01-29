function v_int = interp_dom(geom, data, x, y)

tri = triangulation(double(geom.tri), geom.x.', geom.y.');

[ti, bc] = tri.pointLocation(x.', y.');
idx_nan = isnan(ti);
idx = (~isnan(ti));

if any(idx_nan)
    idx_nearest = tri.nearestNeighbor(x(idx_nan).', y(idx_nan).');
    v_int(idx_nan,:) = data(idx_nearest, :);
end

if any(idx)
    for i=1:size(data, 2)
        v_tmp = data(:,i);
        v_tri = v_tmp(tri(ti(idx),:));
        v_int(idx, i) = dot(bc(idx,:)',v_tri')';
    end
end

end