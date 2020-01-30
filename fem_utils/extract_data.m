function v_unique = extract_data(geom, v, fct)

% check size
assert(size(v,1)==length(geom.idx_rev), 'invalid length')

% select and handle duplicates
[xx,yy] = ndgrid(geom.idx_rev, 1:size(v,2));
v_unique = accumarray([xx(:) yy(:)],v(:),[], fct);

end
