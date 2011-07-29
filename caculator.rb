class Caculator

  require 'rubygems'
  require 'json'
  require 'net/http'

  load "team.rb"

  attr_accessor :teams, :matches

  def initialize()

    @matches = getMatches()

    @teams = createTeams()

  end

  def createTeams()
    teamsList = Array.new
    teamsList.push Team.new("FC Bayern Müchen", "40", 3)
    teamsList.push Team.new("Borussia Dortmund", "7", 1)
    teamsList.push Team.new("1899 Hoffenheim", "123", 11)
    teamsList.push Team.new("Werder Bremen", "134", 13)
    teamsList.push Team.new("Bor. Mönchengladbach", "87", 16)
    teamsList.push Team.new("1. FC Nürnberg", "79", 6)
    teamsList.push Team.new("1. FC Köln", "65", 10)
    teamsList.push Team.new("1. FC Kaiserslautern", "76", 7)
    teamsList.push Team.new("SC Freiburg", "112", 9)
    teamsList.push Team.new("Hannover 96", "55", 4)
    teamsList.push Team.new("Eintracht Frankfurt", "91", 17)
    teamsList.push Team.new("Hamburger SV", "100", 8)
    teamsList.push Team.new("FC Schalke 04", "9", 14)
    teamsList.push Team.new("1. FSV Mainz 05", "81", 5)
    teamsList.push Team.new("VfB Stuttgart", "16", 12)
    teamsList.push Team.new("FC St. Pauli", "98", 18)
    teamsList.push Team.new("Bayer Leverkusen", "6", 2)
    teamsList.push Team.new("VfL Wolfsburg", "131", 15)
    return teamsList
  end

  def getMatches()

    url = "http://botliga.de/api/matches/2010"
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
    result = JSON.parse(data)

    return result
  end  

  def getResult(matchId)

    matchTeams = getMatchTeams(matchId)

    homeTeamId = getHomeTeamId(matchTeams, matchId)
    awayTeamId = getAwayTeamId(matchTeams, matchId)   

    return caculate(homeTeamId, awayTeamId)

  end 

  def getMatchTeams(matchId)
    completeId = "id"+matchId.to_s
    (0..@matches.length-1).each do |i|        
      line = @matches[i]
      if line.to_s.include?completeId
        return line.to_s
      end
    end
  end

  def getHomeTeamId(m, mid)
    m = m.split("id"+mid.to_s, 2)[0]
    m = m.split("hostId", 2)[1]
    return m
  end

  def getAwayTeamId(m, mid)
    m = m.split("id"+mid.to_s, 2)[1]
    m = m.split("guestId", 2)[1]
    m = m.split("hostName", 2)[0]
    return m
  end

  def caculate(homeTeamId, awayTeamId)
 
    homeTeam = findTeamById(homeTeamId)
    gastTeam = findTeamById(awayTeamId)
    
    different = homeTeam.rank - gastTeam.rank
    
    if different.abs < 2 
      factor = rand(1000)     
      if factor > 700
        different = 0
      else
        if different > 0
	   factor = rand(1000)
	   if factor > 900
	      different = different * (-1)
	   end
        else
	   factor = rand(1000)
	   if factor > 700
	      different = different * (-1)
	   end
        end
      end
    elsif different.abs < 7
      if different > 0
	factor = rand(1000)
	if factor > 900
	  different = different * (-1)
        end
      else
	factor = rand(1000)
	if factor > 800
	  different = different * (-1)
        end
      end

      if rand(1000) > 900
	different = 0
      end
    else	
      factor = rand(1000)

      if factor > 950
        different = different * (-1)
      end

      if rand(1000) < 50
        different = 0
      end
    end

    basicGoals = 4
    if rand(1000) > 950
      basicGoals = 5
    elsif rand(1000) < 25
      basicGoals = 6
    end

    if different < 0
      homegoals = rand(basicGoals)
      if homegoals == 0 
	homegoals = homegoals + 1
        gastgoals = 0
      elsif homegoals == 1
	gastgoals = 1
      else
        gastgoals = rand(homegoals-1)
      end
    elsif different == 0
      homegoals = rand(basicGoals-1)
      gastgoals = homegoals 
    else
      gastgoals = rand(basicGoals)
      if gastgoals == 0
	gastgoals = gastgoals + 1
	homegoals= 0
      elsif gastgoals == 1
        homegoals= 1
      else
	homegoals= rand(gastgoals-1)
      end
    end

    return "#{homegoals}:#{gastgoals}"

  end

  def findTeamById(id)

    (0..@teams.length-1).each do |i|
      if teams[i].id == id
        return teams[i]
      end
    end

  end

end
