struct GalileoE1BBase{C <: AbstractMatrix} <: AbstractGNSS
    codes::C
end

"""
GalileoE1B is in theory CBOC. Here it is approximated as BOCcos.
"""
struct GalileoE1B{C <: AbstractMatrix} <: AbstractGNSSBOCcos{1, 1}
    system::GalileoE1BBase{C}
end

function read_from_documentation(raw_code)
    raw_code_without_spaces = replace(replace(raw_code, " " => ""), "\n" => "")
    code_hex_array = map(x -> parse(UInt16, x, base = 16), collect(raw_code_without_spaces))
    code_bit_string = string(string.(code_hex_array, base = 2, pad = 4)...)
    map(x -> parse(Int8, x, base = 2), collect(code_bit_string)) .* Int8(2) .- Int8(1)
end

function GalileoE1BBase()
    codes = read_in_codes(
        joinpath(dirname(pathof(GNSSSignals)), "..", "data", "codes_galileo_e1b.bin"),
        50,
        4092
    )
    GalileoE1BBase(extend_front_and_back(codes, size(codes, 1)))
end

function GalileoE1B()
    GalileoE1B(GalileoE1BBase())
end

"""
$(SIGNATURES)

Get code length of GNSS system GalileoE1B.
```julia-repl
julia> get_code_length(GalileoE1B)
```
"""
@inline function get_code_length(galileo_e1b_base::GalileoE1BBase)
    4092
end

"""
$(SIGNATURES)

Get shortest code length of GNSS system GalileoE1B.
```julia-repl
julia> get_shortest_code_length(GalileoE1B)
```
"""
@inline function get_secondary_code_length(galileo_e1b_base::GalileoE1BBase)
    1
end

"""
$(SIGNATURES)

Get center frequency of GNSS system GalileoE1B.
```julia-repl
julia> get_center_frequency(GalileoE1B)
```
"""
@inline function get_center_frequency(galileo_e1b_base::GalileoE1BBase)
    1_575_420_000Hz
end

"""
$(SIGNATURES)

Get code frequency of GNSS system GalileoE1B.
```julia-repl
julia> get_code_frequency(GalileoE1B)
```
"""
@inline function get_code_frequency(galileo_e1b_base::GalileoE1BBase)
    1023_000Hz
end

"""
$(SIGNATURES)

Get data frequency of GNSS system GalileoE1B.
```julia-repl
julia> get_data_frequency(GalileoE1B)
```
"""
@inline function get_data_frequency(galileo_e1b_base::GalileoE1BBase)
    250Hz
end