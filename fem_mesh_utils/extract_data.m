function data = extract_data(geom, data_fem, fct)
%EXTRACT_DATA Extract data associated with a given geometry.
%   geom = EXTRACT_DATA(geom_fem, remove_duplicates
%   geom - parsed mesh data (struct)
%   fct - function to be applied to duplicated vertices (function handle)
%   data_fem - data from a FEM solver (matrix of float)
%   data - parsed data (matrix of float)
%
%   Data with multiple dimensions are accepted:
%      n_fem x n_var - for data_fem, n_var is the number of dimensions (see 'extract_geom')
%      geom.n x n_var - for data, n_var is the number of dimensions (see 'extract_geom')
%
%   The reason why vertices can be duplicated is possible discontinuous values between elements.
%   This is particularly the case for gradient variables.
%   If the duplicated values are eliminated (see 'extract_geom'), the function 'fct' is applied between the values.
%
%   See also EXTRACT_GEOM, PLOT_DATA.

%   Thomas Guillod.
%   2015-2020 - BSD License.

% check size of the data
assert(size(data_fem,1)==length(geom.idx_data), 'invalid length')

% select and handle duplicates
[xx,yy] = ndgrid(geom.idx_data, 1:size(data_fem,2));
data = accumarray([xx(:) yy(:)],data_fem(:),[], fct);

end
