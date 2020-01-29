function geom = extract_geom_3d_edge(geom)

geom = find_edge(geom);
geom.is_2d = false;

end