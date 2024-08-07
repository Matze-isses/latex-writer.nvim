local greek_map = {
    alpha      = "α",
    beta       = "β",
    gamma      = "ᵧ",
    delta      = "δ",
    epsilon    = "ϵ",
    varepsilon = "ε",
    zeta       = "ζ",
    eta        = "η",
    theta      = "θ",
    iota       = "ι",
    kappa      = "κ",
    lambda     = "λ",
    mu         = "μ",
    nu         = "ν",
    xi         = "ξ",
    omicron    = "𝜪",
    pi         = "π",
    rho        = "ρ",
    sigma      = "σ",
    tau        = "τ",
    upsilon    = "υ",
    phi        = "ϕ",
    chi        = "χ",
    psi        = "ψ",
    omega      = "ω",
    Gamma      = "Γ",
    Delta      = "Δ",
    Theta      = "Θ",
    Iota       = "ι",
    Lambda     = "Λ",
    Xi         = "Ξ",
    Pi         = "Π",
    Phi        = "Φ",
    Psi        = "Ψ",
    Omega      = "Ω",
}

return {
    parse_letters = function (string)
        for letter, unicode in pairs(greek_map) do
            local search_string = "\\" .. letter
            string = string:gsub(search_string, unicode)
        end
        return string
    end
}
