function geom = extract_geom_3d_volume(geom)

geom = find_volume(geom);
geom.is_2d = false;

end

