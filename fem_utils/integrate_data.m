function v_int = integrate_data(geom, int)

if strcmp(geom.type, 'edge_2d')&&strcmp(int.type, 'scalar')
    v = get_component_2(geom, int.data);
    v_int = geom.length_tri*v;
elseif strcmp(geom.type, 'edge_2d')&&strcmp(int.type, 'tangential')
    v_x = get_component_2(geom, int.data_x);
    v_y = get_component_2(geom, int.data_y);
    v_int = abs(geom.d_x*v_x+geom.d_y*v_y);
elseif strcmp(geom.type, 'edge_2d')&&strcmp(int.type, 'normal')
    v_x = get_component_2(geom, int.data_x);
    v_y = get_component_2(geom, int.data_y);
    v_int = abs(geom.d_y*v_x-geom.d_x*v_y);
elseif strcmp(geom.type, 'surface_2d')&&strcmp(int.type, 'scalar')
    v = get_component_3(geom, int.data);
    v_int = geom.area_tri*v;
elseif strcmp(geom.type, 'edge_3d')&&strcmp(int.type, 'scalar')
    v = get_component_2(geom, int.data);
    v_int = geom.length_tri*v;
elseif strcmp(geom.type, 'edge_3d')&&strcmp(int.type, 'tangential')
    v_x = get_component_2(geom, int.data_x);
    v_y = get_component_2(geom, int.data_y);
    v_z = get_component_2(geom, int.data_z);
    v_int = abs(geom.d_x*v_x+geom.d_y*v_y+geom.d_z*v_z);
elseif strcmp(geom.type, 'surface_3d')&&strcmp(int.type, 'scalar')
    v = get_component_3(geom, int.data);
    v_int = geom.area_tri*v;
elseif strcmp(geom.type, 'surface_3d')&&strcmp(int.type, 'normal')
    v_x = get_component_3(geom, int.data_x);
    v_y = get_component_3(geom, int.data_y);
    v_z = get_component_3(geom, int.data_z);
    v_int = abs(geom.n_x*v_x+geom.n_y*v_y+geom.n_z*v_z);
elseif strcmp(geom.type, 'volume_3d')&&strcmp(int.type, 'scalar')
    v = get_component_4(geom, int.data);
    v_int = geom.volume_tri*v;
else
    error('invalid integral')
end

end

function v = get_component_2(geom, data)

assert(size(data,1)==geom.n, 'invalid data')

v1 = data(geom.tri(:,1), :);
v2 = data(geom.tri(:,2), :);
v = (v1+v2)./2;

end

function v = get_component_3(geom, data)

assert(size(data,1)==geom.n, 'invalid data')

v1 = data(geom.tri(:,1), :);
v2 = data(geom.tri(:,2), :);
v3 = data(geom.tri(:,3), :);
v = (v1+v2+v3)./3;

end

function v = get_component_4(geom, data)

assert(size(data,1)==geom.n, 'invalid data')

v1 = data(geom.tri(:,1), :);
v2 = data(geom.tri(:,2), :);
v3 = data(geom.tri(:,3), :);
v4 = data(geom.tri(:,4), :);
v = (v1+v2+v3+v4)./4;

end
