package taillights_pkg;
typedef enum logic [2:0] {
    S000_000,
    S000_100,
    S000_110,
    S000_111,
    S001_000,
    S011_000,
    S111_000,
    S111_111
} state_t;
endpackage

module ucsbece152a_taillights (
    input logic clk,
    input logic rst_n,
    input logic clk_dimmer_i,
    input logic left_i,
    input logic right_i,
    input logic hazard_i,
    input logic brake_i,
    input logic runlights_i,
    output logic [5:0] lights_o
);
    logic [5:0] fsm_pattern;
    logic [5:0] lights_runlightsoff, lights_runlightson;
    logic [5:0] lights_dimmer;

    // Instantiate the FSM
    ucsbece152a_fsm fsm (
        .clk(clk),
        .rst_n(rst_n),
        .left_i(left_i),
        .right_i(right_i),
        .hazard_i(hazard_i),
        .pattern_o(fsm_pattern)
    );

    // Determine the light patterns based on the running light input
    always_comb begin
        lights_runlightsoff = fsm_pattern;
        lights_runlightson = fsm_pattern | 6'b001001; // Example: adding 50% brightness to off lights
    end

    // Generate the dimming effect
    always_ff @(posedge clk_dimmer_i or negedge rst_n) begin
        if (!rst_n) begin
            lights_dimmer <= 6'b0;
        end else begin
            lights_dimmer <= ~lights_dimmer; // Toggle lights for dimming effect
        end
    end

    // MUX to choose between normal and dimmed lights
    assign lights_o = brake_i ? 6'b111111 : // All lights on when brake is active
                      runlights_i ? (lights_dimmer & lights_runlightson) : 
                      lights_runlightsoff;

endmodule

import taillights_pkg::*;
module ucsbece152a_fsm (
    input logic clk,
    input logic rst_n,
    input logic left_i,
    input logic right_i,
    input logic hazard_i,
    output state_t state_o,
    output logic [5:0] pattern_o
);

    // State register
    state_t state_d, state_q = S000_000;

    // Output pattern based on state
    assign pattern_o = (state_q == S000_000) ? 6'b000000 :
                       (state_q == S000_100) ? 6'b000100 :
                       (state_q == S000_110) ? 6'b000110 :
                       (state_q == S000_111) ? 6'b000111 :
                       (state_q == S001_000) ? 6'b001000 :
                       (state_q == S011_000) ? 6'b011000 :
                       (state_q == S111_000) ? 6'b111000 :
                       (state_q == S111_111) ? 6'b111111 : 6'b000000;

    // State transition logic
    always_comb begin
        state_d = state_q; // Default to staying in the current state

        if (hazard_i || (left_i && right_i)) begin
            if (state_q == S111_111) begin
                state_d = S000_000;
            end else begin
                state_d = S111_111;
            end
        end else if (left_i && !right_i) begin
            case (state_q)
                S000_000: state_d = S001_000;
                S001_000: state_d = S011_000;
                S011_000: state_d = S111_000;
                S111_000: state_d = S000_000;
                default: state_d = S000_000;
            endcase
        end else if (right_i && !left_i) begin
            case (state_q)
                S000_000: state_d = S000_100;
                S000_100: state_d = S000_110;
                S000_110: state_d = S000_111;
                S000_111: state_d = S000_000;
                default: state_d = S000_000;
            endcase
        end else begin
            state_d = S000_000;
        end
    end

    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_q <= S000_000;
        end else begin
            state_q <= state_d;
        end
    end

    // Output the current state
    assign state_o = state_q;

endmodule
