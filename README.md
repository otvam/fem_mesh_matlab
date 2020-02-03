# MATLAB toolbox for handling 2d and 3d FEM meshes

This **MATLAB** toolbox offers numerous functionionalities for handling **2d and 3d meshes**:
* **Parse geometry** (edge, surface, and volume) - 'extract_geom.m'
* **Plot geometry** (edge, surface, volume, normal vector, and tangential vector) - 'plot_geom.m'
* **Assign variables** to the vertices of the meshes - 'extract_data.m'
* **Plot variables** (scalar variable and vector field) - 'plot_data.m'
* **Integrate variables** on the meshes (scalar variable and vector field) - 'integrate_data.m'
* **Interpolate variables** on the meshes - 'interp_data.m'

The toolbox can be used for the following tasks:
* Processing **finite element method (FEM)** results (e.g. COMSOL, ANSYS, OpenFOAM)
* Handling **geographic information system (GIS)** data (e.g. digital elevation model)
* Handling **additive manufacturing** data (e.g. 3d printing)

## Examples

The example [run_bridge_example.m](run_bridge_example.m) handles a complex 3d structural analysis:

<p float="middle">
    <img src="readme_img/bridge.png" width="600">
</p>

The example [run_simple_example.m](run_simple_example.m) uses a simple 2d and 3d electrostatic simulation.
This example is used to systemically test/demonstrates the different functions of the toolbox:

<p float="middle">
    <img src="readme_img/simple_1.png" width="400">
    <img src="readme_img/simple_2.png" width="400">
</p>
<p float="middle">
    <img src="readme_img/simple_3.png" width="400">
    <img src="readme_img/simple_4.png" width="400">
</p>
<p float="middle">
    <img src="readme_img/simple_5.png" width="400">
    <img src="readme_img/simple_6.png" width="400">
</p>

## Limitations

The following limitations apply to the toolbox:
* For 2d meshes and 3d surfaces, only triangular meshes are supported (no quadrilateral meshes)
* For 3d volumes, only tetrahedral meshes are supported (no hexahedral meshes)
* The integration and interpolation methods are considering linear schemes (no higher-order)
* Probably not scalable to meshes with millions of vertices (tested up to 100'000 vertices)

## Compatibility

The toolbox requires the following softwares:
* Tested with MATLAB R2018b
* No toolboxes are required
* Compatibility with GNU Octave not tested but probably problematic

The following softwares are used for generating the data of the examples:
* COMSOL 5.4 for generating the meshes and the solutions
* Inventor 2019 for the CAD drawings

## Author

**Thomas Guillod** - [GitHub Profile](https://github.com/otvam)

## License

This project is licensed under the **BSD License**, see [LICENSE.md](LICENSE.md).
