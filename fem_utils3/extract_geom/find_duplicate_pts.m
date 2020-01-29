function geom = find_duplicate_pts(geom)

pts = [geom.x ; geom.y ; geom.z];
[pts_unique, idx, idx_rev] = unique(pts.','rows');

tri_unique = changem(geom.tri, idx_rev, 1:geom.n);
tri_unique = unique(tri_unique,'rows');

geom.n = length(idx);
geom.tri = tri_unique;

geom.x = geom.x(idx);
geom.y = geom.y(idx);
geom.z = geom.z(idx);

end
