function geom = find_edge(geom)

geom = find_duplicate_pts(geom);

is_ok = false(size(geom.tri ,1),1);
lin_vec = {};
[lin_vec, is_ok] = add_elem(lin_vec, is_ok, geom.tri, 1);

while any(is_ok==false)
    idx = find_connection(lin_vec, is_ok, geom.tri);
    [lin_vec, is_ok] = add_elem(lin_vec, is_ok, geom.tri, idx);
end

for i=1:length(lin_vec)
    line.idx = lin_vec{i};
    line.n = length(lin_vec{i});
    
    line.x = geom.x(line.idx);
    line.y = geom.y(line.idx);
    line.z = geom.z(line.idx);
    
    if line.idx(1)==line.idx(end)
        line.close = true;
    else
        line.close = false;
    end
    
    [arc, darc, dx, dy, dz] = compute_arc(line.x, line.y, line.z);
    line.arc = arc;
    line.darc = darc;
    line.dx = dx;
    line.dy = dy;
    line.dz = dz;

    geom.line{i} = line;
end

end

function idx = find_connection(lin_vec, is_ok, tri)

idx_start = lin_vec{end}(1);
idx_end = lin_vec{end}(end);

idx_find = union(find(tri==idx_start), find(tri==idx_end));
[idx_find, idx_tmp] = ind2sub(size(tri) ,idx_find);

idx_free = find(is_ok==false);

idx_connect = intersect(idx_find, idx_free);

if isempty(idx_connect)
    idx = idx_free(1);
else
    idx = idx_connect(1);
end

end

function [lin_vec, is_ok] = add_elem(lin_vec, is_ok, tri, idx)

is_ok(idx) = true;

if isempty(lin_vec)
    lin_vec{end+1} = [];
    lin_vec{end} = tri(idx,:);
else
    idx_start = lin_vec{end}(1);
    idx_end = lin_vec{end}(end);
    
    if tri(idx,1)==idx_start
        lin_vec{end} = [tri(idx,2) lin_vec{end}];
    elseif tri(idx,2)==idx_start
        lin_vec{end} = [tri(idx,1) lin_vec{end}];
    elseif tri(idx,1)==idx_end
        lin_vec{end} = [lin_vec{end} tri(idx,2)];
    elseif tri(idx,2)==idx_end
        lin_vec{end} = [lin_vec{end} tri(idx,1)];
    else
        lin_vec{end+1} = [];
        lin_vec{end} = tri(idx,:);
    end
end

end

function [arc, darc, dx, dy, dz] = compute_arc(x,y,z)

dx = diff(x);
dy = diff(y);
dz = diff(z);

darc = sqrt(dx.^2+dy.^2+dz.^2);
arc = [0 cumsum(darc)];

end