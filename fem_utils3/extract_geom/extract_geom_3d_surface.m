function geom = extract_geom_3d_surface(geom)

geom = find_surface(geom);
geom.is_2d = false;

end