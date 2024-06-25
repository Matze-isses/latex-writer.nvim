

local bb = {
    A = "𝔸",
    B = "𝔹",
    C = "ℂ",
    D = "𝔻",
    E = "𝔼",
    F = "𝔽",
    G = "𝔾",
    H = "ℍ",
    I = "𝕀",
    J = "𝕁",
    K = "𝕂",
    L = "𝕃",
    M = "𝕄",
    N = "ℕ",
    O = "𝕆",
    P = "ℙ",
    Q = "ℚ",
    R = "ℝ",
    S = "𝕊",
    T = "𝕋",
    U = "𝕌",
    V = "𝕍",
    W = "𝕎",
    X = "𝕏",
    Y = "𝕐",
    Z = "ℤ"
}

local cal = {
    A = "𝓐",
    B = "𝓑",
    C = "𝓒",
    D = "𝓓",
    E = "𝓔",
    F = "𝓕",
    G = "𝓖",
    H = "𝓗",
    I = "𝓘",
    J = "𝓙",
    K = "𝓚",
    L = "𝓛",
    M = "𝓜",
    N = "𝓝",
    O = "𝓞",
    P = "𝓟",
    Q = "𝓠",
    R = "𝓡",
    S = "𝓢",
    T = "𝓣",
    U = "𝓤",
    V = "𝓥",
    W = "𝓦",
    X = "𝓧",
    Y = "𝓨",
    Z = "𝓩",
}


---@param text string
return function (text)
    for key, value in pairs(cal) do
        local current_search = "\\\\mathcal " .. key
        text = string.gsub(text, current_search, value)
    end
    for key, value in pairs(bb) do
        local current_search = "\\\\mathbb " .. key
        text = string.gsub(text, current_search, value)
    end
end
