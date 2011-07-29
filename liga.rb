load "caculator.rb"
require 'net/http'

bot_token = "bojly6llqkddriuwd7k17d0g"

caculator = Caculator.new()

matches = caculator.getMatches()
next_matches = Array.new
(0..matches.length-1).each do |i|        
  line = matches[i]

  next_matches.push line.to_s.split("hostId",2)[1].split("id")[1].split("season")[0]

end

#next_matches = [10014, 10011, 10012,10013,10007,10008,10015,10009,10010]

http = Net::HTTP.new('botliga.de',80)

next_matches.each do |match_id|
  
  # insert smart voodoo calculations here
  result = "#{caculator.getResult(match_id)}"
  puts result

  # post your guess
  response, data = http.post('/api/guess',"match_id=#{match_id}&result=#{result}&token=#{bot_token}")

  # "201 Created" (initial guess) or "200 OK" (guess update)
  puts "#{response.code} #{data}" 
end

