function tests = parse_input_test
    tests = functiontests(localfunctions);
end

function test_parse_good_input(testCase)
    result = util.parse_input('./good_input.csv');
    testCase.verifyEqual(result.load_mass, 100);
    testCase.verifyEqual(result.fuselage_diameter, 0.2);
    testCase.verifyEqual(result.fuselage_length, 4);
    testCase.verifyEqual(result.num_of_fins, 4);
    testCase.verifyEqual(result.fin_span, 0.1);
    testCase.verifyEqual(result.fin_thickness, 0.01);
    testCase.verifyEqual(result.fin_leading_edge_sweep_angle, 45);
    testCase.verifyEqual(result.fin_leading_edge_thickness_angle, 5);
    testCase.verifyEqual(result.burn_time, 10);
    testCase.verifyEqual(result.prop_flow_rate, 3);
    testCase.verifyEqual(result.nozzle_eff, 0.98);
    testCase.verifyEqual(result.c_star, 500);
    testCase.verifyEqual(result.exit_pressure, 10000);
    testCase.verifyEqual(result.chamber_pressure, 20000);
    testCase.verifyEqual(result.exp_area_ratio, 1);
    testCase.verifyEqual(result.nozzle_exit_area, 0.01);
    testCase.verifyEqual(result.thrust_misalign_angle, 0);
    testCase.verifyEqual(result.ballute_alt, 5000);
    testCase.verifyEqual(result.main_chute_alt, 3000);
    testCase.verifyEqual(result.ballute_drag_coeff, 0.7);
    testCase.verifyEqual(result.main_chute_drag_coeff, 0.5);
    testCase.verifyEqual(result.ballute_dia, 1);
    testCase.verifyEqual(result.main_chute_dia, 4);
    testCase.verifyEqual(result.num_of_ballutes, 3);
    testCase.verifyEqual(result.num_of_chutes, 3);
    testCase.verifyEqual(result.chute_attachment_pos, 3);
    testCase.verifyEqual(result.launch_angle, 89);
    testCase.verifyEqual(result.launch_alt, 0);
    testCase.verifyEqual(result.launch_direction, 45);
    testCase.verifyEqual(result.nose_cone_mass, 3);
    testCase.verifyEqual(result.payload_adapter_mass, 2);
    testCase.verifyEqual(result.payload_mass, 10);
    testCase.verifyEqual(result.nose_cone_int_hull_mass, 1);
    testCase.verifyEqual(result.avi_rec_section_hull_mass, 1);
    testCase.verifyEqual(result.avi_mass, 3);
    testCase.verifyEqual(result.rec_sys_mass, 10);
    testCase.verifyEqual(result.rec_chute_mass, 10);
    testCase.verifyEqual(result.pressurant_tank_mass, 10);
    testCase.verifyEqual(result.pressurant_gas_mass, 2);
    testCase.verifyEqual(result.pressurant_mount_mass, 0.5);
    testCase.verifyEqual(result.pressureant_LOX_int_hull_mass, 0.5);
    testCase.verifyEqual(result.pressurant_RCS_mass, 0.15);
    testCase.verifyEqual(result.LOX_tank_mass, 3);
    testCase.verifyEqual(result.LOX_mass, 5);
    testCase.verifyEqual(result.LOX_kero_int_hull_mass, 0.1);
    testCase.verifyEqual(result.kero_tank_mass, 3);
    testCase.verifyEqual(result.kero_mass, 1);
    testCase.verifyEqual(result.kero_engine_int_hull_mass, 0.1);
    testCase.verifyEqual(result.mass_engine, 10);
    testCase.verifyEqual(result.nose_length, 0.3);
    testCase.verifyEqual(result.payload_length, 0.1);
    testCase.verifyEqual(result.rec_sys_length, 0.25);
    testCase.verifyEqual(result.pressurant_tank_length, 1);
    testCase.verifyEqual(result.pressurant_LOX_int_hull_length, 0.1);
    testCase.verifyEqual(result.LOX_tank_length, 1);
    testCase.verifyEqual(result.LOX_kero_int_hull_length, 0.05);
    testCase.verifyEqual(result.kero_tank_length, 1);
    testCase.verifyEqual(result.kero_eng_int_hull_length, 0.1);
    testCase.verifyEqual(result.engine_length, 0.6);
    testCase.verifyEqual(result.mass_flow_LOX, 3);
    testCase.verifyEqual(result.mass_flow_kero, 1);
end

function test_parse_bad_structure(testCase)
    testCase.verifyError(...
        @()util.parse_input('./bad_structure.csv'),...
        'fields_input:bad_input');
end

function test_parse_bad_values(testCase)
    testCase.verifyError(...
        @()util.parse_input('./bad_values.csv'),...
        'fields_input:bad_input');
end

