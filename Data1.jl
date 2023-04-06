using Random, Distributions
using XLSX

#Get the directory of the current file
dir = @__DIR__


#Hours
h = ["h$i" for i =1:24]
H = length(h)
#Day-Ahead prices and Wind production data
DAfilepath = joinpath(dir, "Data", "DAprices.xlsx")
DA = XLSX.readdata(DAfilepath,"DK2","B2:U25")                    #€/MWh
DA_s = 20
DA_array = [DA[1:H, c] for c = 1:DA_s]
Wfilepath = joinpath(dir, "Data", "WindProduction.xlsx")
W_RT = XLSX.readdata(Wfilepath,"Normalized","B2:K25")             #MW
W_RT_s = 10
W_RT_array = [W_RT[1:H, c] for c = 1:W_RT_s]
W_Cap = 150 #MW

#=
Generate a series of 24 random binary (two-state) variables, e.g., using a bernoulli distribution, indicating
in every hour of the next day, whether the system in the balancing stage will have a deficit in power supply or an excess
0 = DEFICIT
1 = EXCESS

prob_deficit = 0.5
system_balance = zeros(Int, 24, 3)
for i in 1:3
    system_balance[:,i] = rand(Bernoulli(prob_deficit), 24)
end
=#

SB =[0 0 1;
     0 1 1; 
     1 0 1; 
     0 1 1; 
     1 1 0; 
     1 0 1; 
     1 0 0; 
     0 1 0; 
     1 0 1; 
     0 0 0; 
     1 0 1; 
     1 1 0; 
     1 0 1; 
     1 1 0; 
     1 1 0; 
     0 0 0; 
     1 1 0; 
     1 0 1; 
     0 1 0; 
     1 1 1; 
     1 1 0; 
     0 1 1; 
     1 0 1; 
     1 0 1]

SB_s = 3
SB_array = [SB[1:H, c] for c = 1:SB_s]

#GENERATE THE SCENARIOS 
SC_d = Dict()
counter = 0

struct SCENARIO
    WP::Vector{Float64}
    PR::Vector{Float64}
    IM::Vector{Int64}
end


for w=1:W_RT_s
    for p=1:DA_s
        for i=1:SB_s
            global counter += 1
            SC_d[counter] = SCENARIO(W_RT_array[w], DA_array[p], SB_array[i])
        end
    end
end


S = W_RT_s*DA_s*SB_s

#scenarios for step 1.1 and 1.4 
#S1 = sample(1:S, 200, replace=false) used to generate them randomly
S1 = [106, 579, 132, 436, 181, 279, 399, 136, 203, 196, 417, 394, 507, 38, 240, 210, 426, 396, 99, 376, 89, 361, 474, 85, 349, 63, 441, 271, 550, 9, 302, 567, 144, 75, 230, 355, 55, 316, 514, 115, 292, 188, 180, 261, 126, 381, 222, 372, 340, 74, 363, 490, 111, 78, 242, 420, 440, 326, 571, 447, 359, 81, 266, 313, 557, 450, 551, 54, 324, 576, 552, 131, 332, 566, 148, 24, 517, 283, 479, 493, 369, 317, 553, 362, 298, 331, 374, 427, 504, 379, 476, 456, 548, 505, 177, 58, 545, 438, 226, 204, 249, 22, 586, 412, 235, 154, 348, 263, 430, 582, 315, 563, 250, 428, 88, 199, 386, 19, 137, 146, 37, 406, 534, 156, 229, 409, 128, 558, 592, 296, 543, 259, 443, 30, 56, 127, 233, 62, 207, 21, 44, 519, 434, 383, 273, 247, 86, 448, 439, 338, 392, 252, 491, 51, 104, 23, 591, 482, 217, 444, 387, 537, 150, 322, 211, 318, 400, 110, 165, 353, 277, 274, 36, 171, 595, 45, 393, 6, 228, 124, 65, 107, 398, 215, 130, 218, 231, 138, 255, 584, 237, 312, 275, 562, 15, 61, 308, 583, 135, 2]
f_WP1 = zeros(H,length(S1))
f_DA1 = zeros(H,length(S1))
f_SB1 = zeros(H,length(S1))
for s=1:200
    f_WP1[1:H,s] = SC_d[S1[s]].WP #forecasted wind production for the 200 scenarios
    f_DA1[1:H,s] = SC_d[S1[s]].PR #forecasted day-ahead prices for the 200 scenarios
    f_SB1[1:H,s] = SC_d[S1[s]].IM #forecasted system balance for the 200 scenarios
end

#scenarios for step 1.5 and 1.6
#S2 = sample(setdiff(1:600, S1), 400, replace=false) used to generate them randomly making sure they're not in S1 already
S2 = [69, 31, 257, 377, 5, 575, 12, 268, 503, 232, 73, 477, 403, 14, 492, 559, 184, 489, 414, 141, 145, 251, 449, 90, 502, 305, 93, 32, 123, 239, 18, 578, 60, 435, 524, 589, 254, 191, 520, 408, 343, 185, 371, 264, 253, 195, 518, 143, 375, 333, 25, 200, 94, 405, 97, 152, 508, 284, 182, 87, 341, 384, 158, 186, 487, 219, 526, 26, 515, 464, 419, 395, 57, 96, 162, 465, 77, 528, 29, 122, 498, 300, 83, 480, 174, 425, 342, 153, 27, 216, 352, 303, 483, 291, 397, 358, 499, 462, 294, 599, 280, 461, 43, 472, 168, 330, 183, 336, 220, 530, 365, 310, 407, 418, 187, 378, 510, 47, 67, 329, 299, 64, 161, 80, 570, 401, 546, 451, 102, 564, 410, 321, 347, 33, 327, 160, 84, 536, 319, 208, 339, 467, 581, 356, 11, 34, 46, 52, 169, 178, 469, 509, 468, 224, 597, 82, 3, 497, 473, 354, 134, 16, 388, 382, 523, 119, 560, 17, 351, 142, 246, 593, 293, 212, 159, 540, 66, 243, 151, 213, 1, 205, 10, 323, 225, 108, 481, 367, 290, 109, 350, 573, 328, 484, 460, 346, 49, 173, 457, 39, 287, 478, 544, 370, 149, 445, 175, 596, 538, 295, 28, 411, 40, 511, 475, 117, 568, 424, 485, 244, 116, 455, 337, 404, 585, 155, 594, 431, 164, 314, 103, 114, 113, 79, 163, 307, 532, 197, 422, 70, 368, 306, 118, 535, 539, 121, 574, 112, 547, 147, 590, 320, 214, 140, 71, 513, 98, 446, 201, 223, 458, 453, 527, 486, 390, 429, 202, 193, 512, 53, 167, 588, 577, 561, 125, 494, 91, 598, 35, 466, 311, 516, 416, 241, 415, 309, 95, 442, 276, 541, 179, 288, 101, 385, 76, 194, 542, 357, 600, 20, 452, 572, 380, 8, 262, 391, 297, 248, 105, 269, 389, 139, 206, 423, 198, 238, 7, 413, 587, 285, 525, 569, 334, 265, 555, 278, 133, 549, 272, 41, 48, 432, 470, 289, 166, 366, 495, 345, 4, 260, 471, 100, 433, 335, 256, 286, 170, 506, 176, 402, 42, 531, 496, 282, 522, 580, 500, 304, 521, 13, 267, 281, 236, 454, 554, 373, 227, 59, 437, 463, 234, 421, 533, 190, 459, 245, 556, 72, 189, 50, 157, 92, 129, 344, 209, 529, 68, 192, 172, 360, 325, 501, 120, 221, 270, 565, 258, 301, 488, 364]
f_WP2 = zeros(H,length(S2))
f_DA2 = zeros(H,length(S2))
f_SB2 = zeros(H,length(S2))
for s=1:400
    f_WP2[1:H,s] = SC_d[S2[s]].WP #forecasted wind production for the other 400 scenarios
    f_DA2[1:H,s] = SC_d[S2[s]].PR #forecasted day-ahead prices for the other 400 scenarios
    f_SB2[1:H,s] = SC_d[S2[s]].IM #forecasted system balance for the other 400 scenarios
end


