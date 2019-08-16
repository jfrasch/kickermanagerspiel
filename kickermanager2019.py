# -*- coding: iso-8859-1 -*-

import os
import sys
import platform

def main():

    modelpath = sys.argv[0].replace("kickermanager2019.py", "model")
    datapath = sys.argv[0].replace("kickermanager2019.py", "data")
    resultspath = sys.argv[0].replace("kickermanager2019.py", "results")
	
    goalFile = open( datapath + "/goalie.csv", "r" ) 
    defFile = open( datapath + "/defender.csv", "r" )
    midFile = open( datapath + "/midfielder.csv", "r" )
    strFile = open( datapath + "/striker.csv", "r" )
    wgtFile = open( datapath + "/teamweights.csv", "r" )
    scalingsFile = open( datapath + "/divisionScaling.csv", "r" )

    goalLines = goalFile.readlines()
    defLines = defFile.readlines()
    midLines = midFile.readlines()
    strLines = strFile.readlines()
    wgtLines = wgtFile.readlines()
    sclLines = scalingsFile.readlines()
    
    goalFile.close()
    defFile.close()
    midFile.close()
    strFile.close()
    wgtFile.close()
    scalingsFile.close()
    
    goalies = []
    defenders = []
    midfielders = []
    strikers = []
    teamWeight = []
    
    for line in goalLines:
        line = line.split('\t')
        #skip title
        if("Position") in line or ("\"Position\"") in line:
            continue
        else:
            goalies.append( line )
    
    for line in defLines:
        line = line.split('\t')
        #skip title
        if("Position") in line or ("\"Position\"") in line:
            continue
        else:
            defenders.append( line )
    
    for line in midLines:
        line = line.split('\t')
        #skip title
        if("Position") in line or ("\"Position\"") in line:
            continue
        else:
            midfielders.append( line )
    
    for line in strLines:
        line = line.split('\t')
        #skip title
        if("Position") in line or ("\"Position\"") in line:
            continue
        else:
            strikers.append( line )
    
    for line in wgtLines:
        line = line.split('\t')
        #skip title
        if("Position") in line or ("\"Position\"") in line:
            continue
        else:
            teamWeight.append( line )

    for line in sclLines:
        line = line.split('\t')
        if line[0] == "Erstligafaktor" or line[0] == "\"Erstligafaktor\"":
            scalingFirstDivision = float(line[1])
        elif line[0] == "Zweitligafaktor" or line[0] == "\"Zweitligafaktor\"":
            scalingSecondDivision = float(line[1])
        elif line[0] == "Drittligafaktor" or line[0] == "\"Drittligafaktor\"":
            scalingThirdDivision = float(line[1])
        elif line[0] == "Auslandsfaktor" or line[0] == "\"Auslandsfaktor\"":
            scalingForeignDivisions = float(line[1])
        else:
            continue
            
    playertypes = [goalies, defenders, midfielders, strikers]
    
    #get Teamsplayertype
    teams = []
    for playertype in playertypes:
        for player in playertype:
            if player[1] not in teams:
                teams.append(player[1])
    
    teams.sort()
    
    #unique playernames
    for playertype in playertypes:
        for player in playertype:
            player[0] = player[0] + " " + player[1]
            
    #replace teams by number
    for playertype in playertypes:
        for player in playertype:
            player[1] = str(teams.index(player[1]) + 1)
    
    #replace "" by 0 in gain
    for playertype in playertypes:
        for player in playertype:
            if player[6] == "":
                player[6] = "0"
            
    #replace "," with "." in floating numbers (prices)
    for playertype in playertypes:
        for player in playertype:
            player[3] = player[3].replace(",",".")

    #replace "," with "." in floating numbers (Gewichtung Spieler)
    for playertype in playertypes:
        for player in playertype:
            #print("If found >>>"+player[9]+"<<<")
            if player[9] == "":
                player[9] = "1"
            else:
                player[9] = player[9].replace(",",".")
            
    #replace spaces with underscores in names
    for playertype in playertypes:
        for player in playertype:
            player[0] = player[0].replace(" ","_")
            player[0] = player[0].replace("'","")
            player[0] = player[0].replace(".","")
            player[0] = player[0].replace("Ä","Ae")
            player[0] = player[0].replace("ä","ae")
            player[0] = player[0].replace("Ö","Oe")
            player[0] = player[0].replace("ö","oe")
            player[0] = player[0].replace("Ü","Ue")
            player[0] = player[0].replace("ü","ue")
            player[0] = player[0].replace("ß","ss")
            player[0] = player[0].replace("é","e")
            player[0] = player[0].replace("è","e")
            
    #remove all " and '
    for playertype in playertypes:
        for player in playertype:
            for k in range(len(player)):
                player[k] = player[k].replace("\"","")
                player[k] = player[k].replace("'","")
                player[k] = player[k].strip()
    
    outfile = open( modelpath + "/kicker_gmpl.dat", "w" )
    
    playerliteral = ['G', 'D', 'M', 'S']
    i = 0
    for playertype in playertypes:
        #names
        writeString = "set name_" + playerliteral[i] + " := "
        k = 1
        for k in range(len(playertype)):
            writeString += str(playertype[k][0]) + " "
        writeString += ";\n\n\n"
        
        outfile.writelines(writeString)
        
        #price
        writeString = "param p_" + playerliteral[i] + " := "
        k = 1
        for k in range(len(playertype)):
            writeString += str(playertype[k][0]) + " "
            writeString += str(float(playertype[k][3])) + " "
            writeString += "\n" + 16*" "
        writeString += ";\n\n\n"
        
        outfile.writelines(writeString)
        
        #points
        writeString = "param g_" + playerliteral[i] + " := "
        k = 1
        for k in range(len(playertype)):
            pointsFirstDivision = float(playertype[k][6])
            points = ( scalingFirstDivision * pointsFirstDivision )
            writeString += str(playertype[k][0]) + " "
            writeString += str(points) + " "
            #writeString += str(playertype[k][4]) + " "
            writeString += "\n" + 16*" "
        writeString += ";\n\n\n"
        
        outfile.writelines(writeString)
        
        #team
        writeString = "param t_" + playerliteral[i] + " := "
        k = 1
        for k in range(len(playertype)):
            writeString += str(playertype[k][0]) + " "
            writeString += str(playertype[k][1]) + " "
            writeString += "\n" + 16*" "
        writeString += ";\n\n\n"
        
        outfile.writelines(writeString)
        
        #player weight
        writeString = "param w_" + playerliteral[i] + " := "
        k = 1
        for k in range(len(playertype)):
            writeString += str(playertype[k][0]) + " "
            writeString += str(playertype[k][9]) + " "
            writeString += "\n" + 16*" "
        writeString += ";\n\n\n"
        
        outfile.writelines(writeString)
        
        i += 1
    
    writeString = "param pref := "
    for i in range(len(teams)):
        writeString += " " + str(i+1) + " " + str(1) + "  #" + teams[i]
        writeString += "\n" + 16*" "
    writeString += ";\n\nend;\n\n"
    outfile.writelines(writeString)
    
    outfile.close()
    
    
    print("Detected platform: " + platform.system())
    glpsolpath = "c:/Programme/GnuWin32/bin/glpsol.exe"
    if (platform.system() == "Linux") or (platform.system() == "Darwin"):
        os.system("glpsol --model " + modelpath + "/best11_gmpl.mod --data " + \
	    modelpath + "/kicker_gmpl.dat --display results/best11.txt")
        os.system("glpsol --model " + modelpath + "/best12_gmpl.mod --data " + \
        modelpath + "/kicker_gmpl.dat --display results/best12.txt")
        os.system("glpsol --model " + modelpath + "/best13_gmpl.mod --data " + \
        modelpath + "/kicker_gmpl.dat --display results/best13.txt")
        os.system("glpsol --model " + modelpath + "/best14_gmpl.mod --data " + \
	    modelpath + "/kicker_gmpl.dat --display results/best14.txt")
        os.system("glpsol --model " + modelpath + "/best22_gmpl.mod --data " + \
	    modelpath + "/kicker_gmpl.dat --display results/best22.txt")
    elif platform.system() == "Windows":
        os.system(glpsolpath + " --model " + modelpath + "/best11_gmpl.mod --data " + \
	    modelpath + "/kicker_gmpl.dat --display " + resultspath + "/best11.txt")
        os.system(glpsolpath + " --model " + modelpath + "/best12_gmpl.mod --data " + \
        modelpath + "/kicker_gmpl.dat --display " + resultspath + "/best12.txt")
        os.system(glpsolpath + " --model " + modelpath + "/best13_gmpl.mod --data " + \
        modelpath + "/kicker_gmpl.dat --display " + resultspath + "/best13.txt")
        os.system(glpsolpath + " --model " + modelpath + "/best14_gmpl.mod --data " + \
	    modelpath + "/kicker_gmpl.dat --display " + resultspath + "/best14.txt")
        os.system(glpsolpath + " --model " + modelpath + "/best22_gmpl.mod --data " + \
	    modelpath + "/kicker_gmpl.dat --display " + resultspath + "/best22.txt")
        

if __name__ == '__main__':
    print("Starting Kicker Manager Optimizer...\n")
    main()
