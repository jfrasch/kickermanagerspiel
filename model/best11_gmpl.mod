#################################################################
# Best 11 players
#################################################################

set T := 1..18;           # Teams
param pref{T};          # Personal team preference, set in teams.dat

set name_G;             # name of each player (goalie)
set name_D;             # name of each player (defender)
set name_M;             # name of each player (midfielder)
set name_S;             # name of each player (striker)

param p_G{name_G};              # price of each player (goalie)
param p_D{name_D};              # price of each player (defender)
param p_M{name_M};              # price of each player (midfielder)
param p_S{name_S};              # price of each player (striker)

param g_G{name_G};              # gain by each player (goalie)
param g_D{name_D};              # gain by each player (defender)
param g_M{name_M};              # gain by each player (midfielder)
param g_S{name_S};              # gain by each player (striker)

param t_G{name_G};              # team of each player (goalie)
param t_D{name_D};              # team of each player (defender)
param t_M{name_M};              # team of each player (midfielder)
param t_S{name_S};              # team of each player (striker)

param w_G{name_G};              # weight of each player (goalie)
param w_D{name_D};              # weight of each player (defender)
param w_M{name_M};              # weight of each player (midfielder)
param w_S{name_S};              # weight of each player (striker)

var x_G{name_G} binary;             # indicator whether chosen (goalie)
var x_D{name_D} binary;             # indicator whether chosen (defenders)
var x_M{name_M} binary;             # indicator whether chosen (midfielder)
var x_S{name_S} binary;             # indicator whether chosen (striker)

var s_G{name_G} binary;             # indicator whether chosen (goalie) as starting player
var s_D{name_D} binary;             # indicator whether chosen (defenders) as starting player
var s_M{name_M} binary;             # indicator whether chosen (midfielder) as starting player
var s_S{name_S} binary;             # indicator whether chosen (striker) as starting player

#######################
# problem formulation #
#######################

maximize lastSeasonsPoints: sum{k in name_G} g_G[k] * s_G[k] * pref[t_G[k]] * w_G[k] +
                            sum{k in name_D} g_D[k] * s_D[k] * pref[t_D[k]] * w_D[k] +
                            sum{k in name_M} g_M[k] * s_M[k] * pref[t_M[k]] * w_M[k] +
                            sum{k in name_S} g_S[k] * s_S[k] * pref[t_S[k]] * w_S[k];


# budget constraints
s.t. budget: sum{k in name_G} p_G[k]*x_G[k] +
             sum{k in name_D} p_D[k]*x_D[k] +
             sum{k in name_M} p_M[k]*x_M[k] +
             sum{k in name_S} p_S[k]*x_S[k]     <= 42.5;

# number of golies
s.t. goalies: sum{k in name_G} x_G[k] = 3;

# number of defenders
s.t. defenders: sum{k in name_D} x_D[k] = 6;

# number of midfielders
s.t. midfielders: sum{k in name_M} x_M[k] = 8;

# number of strikers
s.t. strikers: sum{k in name_S} x_S[k] = 5;

# team constraints (4 players from each max)
s.t. teamCons{t in T}: sum{k in name_G: t_G[k]=t} x_G[k] +
                       sum{k in name_D: t_D[k]=t} x_D[k] +
                       sum{k in name_M: t_M[k]=t} x_M[k] +
                       sum{k in name_S: t_S[k]=t} x_S[k]     <= 4;

# starting squad must be part of the team
s.t. startingG{k in name_G}: s_G[k] <= x_G[k];
s.t. startingD{k in name_D}: s_D[k] <= x_D[k];
s.t. startingM{k in name_M}: s_M[k] <= x_M[k];
s.t. startingS{k in name_S}: s_S[k] <= x_S[k];

# starting squad constraints (3 players from each max)
s.t. startingSquadCons{t in T}: sum{k in name_G: t_G[k]=t} s_G[k] +
                       sum{k in name_D: t_D[k]=t} s_D[k] +
                       sum{k in name_M: t_M[k]=t} s_M[k] +
                       sum{k in name_S: t_S[k]=t} s_S[k]     <= 3;

# number of golies in starting squad
s.t. startingGoalies: sum{k in name_G} s_G[k] = 1;

# number of defenders in starting squad
s.t. startingDefendersUp: sum{k in name_D} s_D[k] <= 4;
s.t. startingDefendersLo: sum{k in name_D} s_D[k] >= 3;

# number of midfielders in starting squad
s.t. startingMidfieldersUp: sum{k in name_M} s_M[k] <= 5;
s.t. startingMidfieldersLo: sum{k in name_M} s_M[k] >= 3;

# number of strikers in starting squad
s.t. startingStrikersUp: sum{k in name_S} s_S[k] <= 3;
s.t. startingStrikersLo: sum{k in name_S} s_S[k] >= 1;

# 11 Freunde muesst ihr sein!
s.t. elfFreunde: sum{k in name_G} s_G[k] 
                + sum{k in name_D} s_D[k] 
                + sum{k in name_M} s_M[k] 
                + sum{k in name_S} s_S[k] = 11;


solve;

printf "==========================================================\n";
printf "|                                                        |\n";
printf "|  Ergebnis der Optimierung fuer die 11 besten Spieler:  |\n";
printf "|                                                        |\n";
printf "==========================================================\n";
printf "\nPunkte in der Vorsaison: %i\n", sum{k in name_G} g_G[k] * s_G[k]
                                         +sum{k in name_D} g_D[k] * s_D[k]
                                         +sum{k in name_M} g_M[k] * s_M[k]
                                         +sum{k in name_S} g_S[k] * s_S[k];

#Writing this gives an error: invalid reference to objective lastSeasonsPoints, wtf?!										 
#printf "\nGewichtete Punkte in der Vorsaison: %i\n", lastSeasonsPoints;									 
printf "\nGewichtete Punkte in der Vorsaison: %i\n", sum{k in name_G} g_G[k] * s_G[k] * pref[t_G[k]] * w_G[k]
													+sum{k in name_D} g_D[k] * s_D[k] * pref[t_D[k]] * w_D[k]
													+sum{k in name_M} g_M[k] * s_M[k] * pref[t_M[k]] * w_M[k]
													+sum{k in name_S} g_S[k] * s_S[k] * pref[t_S[k]] * w_S[k];

printf "\n";
printf "Torhueter:\n";
printf "==========\n";
for{k in name_G} {
    for{{0} : x_G[k] == 1 }
    {
        for{{0} : s_G[k] == 1 }
            printf "[!] Kaufe %s fuer %.1f Mio EUR ( %i Punkte in der Vorsaison; gewichtet %i Punkte)\n", k, p_G[k], g_G[k], g_G[k]*pref[t_G[k]]*w_G[k];
        for{{0} : s_G[k] == 0 }
            printf "Kaufe %s fuer %.1f Mio EUR ( %i Punkte in der Vorsaison; gewichtet %i Punkte)\n", k, p_G[k], g_G[k], g_G[k]*pref[t_G[k]]*w_G[k];
    }
           
}

printf "\n";
printf "Verteidiger:\n";
printf "============\n";
for{k in name_D} {
    for{{0} : x_D[k] == 1 }
    {
        for{{0} : s_D[k] == 1 }
            printf "[!] Kaufe %s fuer %.1f Mio EUR ( %i Punkte in der Vorsaison; gewichtet %i Punkte)\n", k, p_D[k], g_D[k], g_D[k]*pref[t_D[k]]*w_D[k];
        for{{0} : s_D[k] == 0 }
            printf "Kaufe %s fuer %.1f Mio EUR ( %i Punkte in der Vorsaison; gewichtet %i Punkte)\n", k, p_D[k], g_D[k], g_D[k]*pref[t_D[k]]*w_D[k];
    }
           
}

printf "\n";
printf "Mittelfeldspieler:\n";
printf "==================\n";
for{k in name_M} {
    for{{0} : x_M[k] == 1 }
    {
        for{{0} : s_M[k] == 1 }
            printf "[!] Kaufe %s fuer %.1f Mio EUR ( %i Punkte in der Vorsaison; gewichtet %i Punkte)\n", k, p_M[k], g_M[k], g_M[k]*pref[t_M[k]]*w_M[k];
        for{{0} : s_M[k] == 0 }
            printf "Kaufe %s fuer %.1f Mio EUR ( %i Punkte in der Vorsaison; gewichtet %i Punkte)\n", k, p_M[k], g_M[k], g_M[k]*pref[t_M[k]]*w_M[k];
    }
           
}

printf "\n";
printf "Stuermer:\n";
printf "=========\n";
for{k in name_S} {
    for{{0} : x_S[k] == 1 }
    {
        for{{0} : s_S[k] == 1 }
            printf "[!] Kaufe %s fuer %.1f Mio EUR ( %i Punkte in der Vorsaison; gewichtet %i Punkte)\n", k, p_S[k], g_S[k], g_S[k]*pref[t_S[k]]*w_S[k];
        for{{0} : s_S[k] == 0 }
            printf "Kaufe %s fuer %.1f Mio EUR ( %i Punkte in der Vorsaison; gewichtet %i Punkte)\n", k, p_S[k], g_S[k], g_S[k]*pref[t_S[k]]*w_S[k];
    }
           
}

end;
