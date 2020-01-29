function geom = extract_geom_2d_surface(geom)

geom.z = zeros(1, geom.n);
geom = find_surface(geom);
geom.is_2d = true;

end