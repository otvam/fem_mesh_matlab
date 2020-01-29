function geom = extract_geom_2d_edge(geom)

geom.z = zeros(1, geom.n);
geom = find_edge(geom);
geom.is_2d = true;

end