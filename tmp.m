function extract_data()

addpath(genpath('fem_utils'))

% load
model = mphload('test.mph');

% data
t = 43.5;
sel_core = 'sel3';
sel_winding = 'sel1';
sel_ntc = 'uni3';

% temperature
core_temperature = extract_dom_value(model, 'dset4', sel_core, 'T-T_ambient', t);
winding_temperature = extract_dom_value(model, 'dset4', sel_winding, 'T-T_ambient', t);
ntc_temperature = extract_dom_value(model, 'dset4', sel_ntc, 'T-T_ambient', t);

% losses
core_losses = extract_dom_value(model, 'dset4', sel_core, 'p_core_mf', t);
winding_losses = extract_dom_value(model, 'dset4', sel_winding, 'p_winding_mf', t);
ntc_losses = extract_dom_value(model, 'dset4', sel_ntc, '0', t);

% save
save('data.mat', 'core_temperature', 'winding_temperature', 'ntc_temperature', 'core_losses', 'winding_losses', 'ntc_losses')

end

function data = extract_dom_value(model, dataset, sel, expr, t)

data_tmp = model.mpheval(expr,'Dataset', dataset, 'Complexout','on', 'Selection', sel, 't', t);

geom_raw.n = size(data_tmp.p,2);
geom_raw.x = data_tmp.p(1,:);
geom_raw.y = data_tmp.p(2,:);
geom_raw.z = data_tmp.p(3,:);
geom_raw.tri = (data_tmp.t+1).';
geom = extract_geom_3d_surface(geom_raw);

value = data_tmp.d1.';

data.geom = geom;
data.value = value;

end