function v_int = interp_bnd(geom, data, x, y)

tri = delaunayTriangulation(geom.x.', geom.y.');
idx_nearest = tri.nearestNeighbor(x.', y.');

v_int = data(idx_nearest, :);

end