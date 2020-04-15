function [eval_ann, data_compute] = get_design_data_single()
% Return the data required for the compuation of inductor designs.
%
%    Define the variables and how to generate the samples.
%    How to evaluate the ANN/regression.
%    How to filter the invalid design.
%    Data required for the inductor evaulation.
%
%    Returns:
%        sweep (cell): data controlling the generation of the design combinations
%        n_split (int): number of vectorized designs per computation
%        fct (struct): struct with custom functions for filtering invalid designs
%        eval_ann (struct): data for controlling the evaluation of the ANN/regression
%        data_compute (struct): data for the inductor designs
%
%    (c) 2019-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% data for controlling the evaluation of the ANN/regression:
%    - geom_type: type of the geometry input variables
%        - 'rel': boxed volume, geometrical aspect ratio, and relative air gap length
%        - 'abs': absolute core, winding, and air gap length
%    - eval_type: type of the ANN/regression evaluation
%        - 'ann': get the result of the ANN/regression
%        - 'approx': get the analytical solution without the ANN/regression
eval_ann.geom_type = 'abs';
eval_ann.eval_type = 'ann';

% inductor data (data which are common for all the sample)
data_compute.data_const = get_data_const();

% function for getting the inductor data (struct of vector with one value per sample)
data_compute.data_vec = get_data_vec();

% function for getting the operating points data (struct of vector with one value per sample)
data_compute.fct_excitation = @(fom) get_excitation(fom);

end

function data_vec = get_data_vec()
% Function for getting the inductor data (struct of vector with one value per sample)
%
%    Parameters:
%        var (struct): struct of vectors with the samples with all the combinations
%
%    Returns:
%        data_vec (struct:) struct of vector with one value per sample

% inductor geometry
%    - fact_window: ratio between the height and width and the winding window
%    - fact_core: ratio between the length and width of the core cross section
%    - fact_core_window: ratio between the core cross section and the winding window cross section
%    - fact_gap: ratio between the air gap length and the square root of the core cross section
%    - V_box: inductor box volume
%    - n_turn: inductor number of turns
geom.x_window = 10.15e-3;
geom.y_window = 37.40e-3;
geom.t_core = 17.20e-3;
geom.z_core = 21.00e-3;
geom.d_gap = 0.40e-3;
geom.n_turn = 16;

% inductor physical parameters
%    - I_test: test current for computing the magnetic circuit
%    - T_init: initial guess for the component temperature
other.I_test = 10.0;
other.T_init = 80.0;

% inductor scaling factor for the figures of merit
%    - m_scale: scaling factor for the total mass
%    - m_offset: offset for the total mass
%    - V_scale: scaling factor for the box volume
%    - V_offset: offset for the box volume
%    - c_scale: scaling factor for the total cost
%    - c_offset: offset for the total cost
%    - P_scale: scaling factor for the total losses
%    - P_offset: offset for the total losses
fom_data.m_scale = 1.0;
fom_data.m_offset = 0.0;
fom_data.V_scale = 1.0;
fom_data.V_offset = 0.0;
fom_data.c_scale = 1.0;
fom_data.c_offset = 0.0;
fom_data.P_scale = 1.0;
fom_data.P_offset = 0.0;

% bounds for the geometry figures of merit
%    - c_tot: total cost
%    - m_tot: total mass
%    - V_box: box volume
fom_limit.c_tot = struct('min', 0.0, 'max', Inf);
fom_limit.m_tot = struct('min', 0.0, 'max', Inf);
fom_limit.V_box = struct('min', 0.0, 'max', Inf);

% bounds for the circuit figures of merit
%    - L: inductance
%    - V_t_area: saturation voltage time product
%    - I_sat: maximum saturation current
%    - I_rms: maximum RMS current
fom_limit.L = struct('min', 0, 'max', Inf);
fom_limit.V_t_area = struct('min', 0, 'max', Inf);
fom_limit.I_sat = struct('min', 0.0, 'max', Inf);
fom_limit.I_rms = struct('min', 0.0, 'max', Inf);

% bounds for the inductor utilization
%    - stress: stress applied to the inductor for evaluating the utilization
%        - I_dc: applied DC current
%        - V_t_area: applied voltage time product
%        - fact_rms: factor between the peak current and the RMS current
%    - I_rms_tot: total RMS current (AC and DC)
%    - I_peak_tot: total peak current (AC and DC)
%    - r_peak_peak: peak to peak ripple
%    - fact_sat: total peak current with respect to the maximum saturation current
%    - fact_rms: total RMS current with respect to the maximum RMS current
fom_limit.stress = struct('I_dc', 10.0, 'V_t_area', 200./(2.*200e3), 'fact_rms', 1./sqrt(3));
fom_limit.I_rms_tot = struct('min', 0.0, 'max', Inf);
fom_limit.I_peak_tot = struct('min', 0.0, 'max', Inf);
fom_limit.r_peak_peak = struct('min', 0.0, 'max', Inf);
fom_limit.fact_sat = struct('min', 0.0, 'max', Inf);
fom_limit.fact_rms = struct('min', 0.0, 'max', Inf);

% inductor geometry
%    - winding_id: id of the winding material
%    - core_id: id of the core material
%    - iso_id: id of the insulation material
material.winding_id = 100;
material.core_id = 87;
material.iso_id = 1;

% assign the data
data_vec.other = other;
data_vec.material = material;
data_vec.geom = geom;
data_vec.fom_data = fom_data;
data_vec.fom_limit = fom_limit;

end

function excitation = get_excitation(fom)
% Function for getting the operating points data (struct of vector with one value per sample)
%
%    Parameters:
%        var (struct): struct of vectors with the samples with all the combinations
%        fom (struct): computed inductor figures of merit
%
%    Returns:
%        excitation (struct): struct containing the operating points (e.g., full load, half load)

% 200kHz
excitation.f_200k = get_excitation_frequency(fom, 200e3);

% 375kHz
excitation.f_375k = get_excitation_frequency(fom, 375e3);

% 500kHz
excitation.f_500k = get_excitation_frequency(fom, 500e3);

% 625kHz
excitation.f_625k = get_excitation_frequency(fom, 625e3);

% 750kHz
excitation.f_750k = get_excitation_frequency(fom, 750e3);

end

function excitation = get_excitation_frequency(fom, f)
% Function for getting the operating point for a specific frequency.
%
%    Parameters:
%        fom (struct): computed inductor figures of merit
%        n_sol (int): number of designs
%        load (float): operating point load (relative to full load)
%
%    Returns:
%        excitation (struct): struct containing the operating points (e.g., full load, half load)

% extract inductance
L = fom.circuit.L;

% excitation data
%    - T_ambient: ambient temperature
%    - is_pwm: is the waveform are sinus or PWM (triangular)
%    - d_c: duty cycle
%    - f: operating frequency
%    - I_dc: DC current
%    - I_ac_peak: AC peak current
excitation.T_ambient = 40.0;
excitation.is_pwm = false;
excitation.d_c = NaN;
excitation.f = f;
excitation.I_dc = 10.0;
excitation.I_ac_peak = 200./(4.*f.*L);

end

function data_const = get_data_const()
% Get the inductor data which are common for all the sample.
%
%    Returns:
%        data_const (struct): inductor data common for all the sample

% data controlling the thermal/loss iteration:
%     - n_iter: maximum number of iterations
%     - losses.tol_abs: absolute tolerance on the losses
%     - losses.tol_rel: relative tolerance on the losses
%     - losses.relax: relaxation parameter for the losses
%     - thermal.tol_abs: absolute tolerance on the temperatures
%     - thermal.tol_rel: relative tolerance on the temperatures
%     - thermal.relax: relaxation parameter for the temperatures
data_const.iter.n_iter = 15;
data_const.iter.losses.tol_abs = 0.5;
data_const.iter.losses.tol_rel = 0.05;
data_const.iter.losses.relax = 1.0;
data_const.iter.thermal.tol_abs = 2.0;
data_const.iter.thermal.tol_rel = 0.05;
data_const.iter.thermal.relax = 1.0;

% data containing the material (core, winding, and insulation) data:
%    - each material has a unique id
%    - the material data is generated by 'resources/material'
data_const.material_core = load('source_input/material/core_data.mat');
data_const.material_winding = load('source_input/material/winding_data.mat');
data_const.material_iso = load('source_input/material/iso_data.mat');

end