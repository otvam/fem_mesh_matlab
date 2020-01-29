function data = extract_geom_data(geom, geom_tmp, data_tmp, fct)

if geom.is_2d==true
    geom_tmp.z = zeros(1, geom_tmp.n);
end

pts = [geom_tmp.x ; geom_tmp.y ; geom_tmp.z];
[pts_unique, idx, idx_rev] = unique(pts.','rows');

assert(length(idx)==geom.n, 'invalid data');
assert(all(geom_tmp.x(idx)==geom.x), 'invalid data');
assert(all(geom_tmp.y(idx)==geom.y), 'invalid data');
assert(all(geom_tmp.z(idx)==geom.z), 'invalid data');

[xx,yy] = ndgrid(idx_rev, 1:size(data_tmp,2));
data = accumarray([xx(:) yy(:)], data_tmp(:), [], fct);

end