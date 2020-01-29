function v_int = integrate_3d_edge_line(geom, data_x, data_y, data_z)

assert(geom.is_2d==false, 'invalid geom');

v_int = {};
for i=1:length(geom.line)
    dx = geom.line{i}.dx;
    dy = geom.line{i}.dy;
    dz = geom.line{i}.dz;
    
    vx = data_x(geom.line{i}.idx);
    vy = data_y(geom.line{i}.idx);
    vz = data_z(geom.line{i}.idx);
    
    vx = (vx(1:end-1, :)+vx(2:end, :))./2.0;
    vy = (vy(1:end-1, :)+vy(2:end, :))./2.0;
    vz = (vz(1:end-1, :)+vz(2:end, :))./2.0;
        
    v_int{i} = abs(dx*vx+dy*vy+dz*vz);
end

end