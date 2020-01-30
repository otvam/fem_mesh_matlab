function v_int = integrate_edge(geom, data)

v_int = {};
for i=1:length(geom.line)
    darc = geom.line{i}.darc;
    v = data(geom.line{i}.idx);
    v = (v(1:end-1, :)+v(2:end, :))./2;
    
    v_int{i} = darc*v;
end

end